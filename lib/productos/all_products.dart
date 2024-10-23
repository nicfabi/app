import 'dart:convert';
import 'dart:io';
import 'package:app/productos/DetalleProductoPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductoService extends GetxController {
  var productos = <Map<String, dynamic>>[].obs;
  var productoSeleccionado = Rxn<Map<String, dynamic>>();

  static const String url = 'https://microtech.icu:5000/products/allProducts';
  Future<void> obtenerProductos() async {
    try {
      print("Sending request to: $url");
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');
      HttpClientResponse response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final List<dynamic> data = jsonDecode(responseBody);
        productos.clear();
        data.forEach((producto) {
          //producto['IMAGE'] = 'https://microtech.icu:5000/${producto['IMAGE']}';
          productos.add(Map<String, dynamic>.from(producto));
        });
      } else {
        Get.snackbar('Error', 'No se pudieron cargar los productos.');
      }
    } catch (e) {
      print(e);
      Get.snackbar(
          'Error', 'Ocurrió un error al intentar cargar los productos.');
    }
  }

  void seleccionarProducto(Map<String, dynamic> producto) {
    productoSeleccionado.value = producto;
  }

  Future<void> DeleteProduct(BuildContext context, int codigoProducto) async {
    final String url =
        'https://microtech.icu:5000/products/delete/$codigoProducto';
    try {
      print("Sending DELETE request to: $url");
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      HttpClientRequest request = await client.deleteUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');
      HttpClientResponse response = await request.close();
      print('Response status: ${response.statusCode}');
      if (response.statusCode < 300) {
        // Eliminar el producto de la lista localmente
        productos.removeWhere((producto) => producto['ID'] == codigoProducto);
        Get.snackbar('Producto Eliminado', 'Producto eliminado correctamente.');
        Navigator.pop(context);
      } else {
        Get.snackbar('Error', 'No se pudo eliminar el producto.');
      }
    } catch (e) {
      print('Error occurred: $e');
      Get.snackbar(
          'Error', 'Ocurrió un error al intentar eliminar el producto.');
    }
  }

  Future<void> addProduct(Map<String, dynamic> productData) async {
    const String url = 'https://microtech.icu:5000/products/addProduct';
    try {
      print(productData);
      print("Sending request to add product at: $url");
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      // Build the request for the add product endpoint
      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');

      // Convert productData to JSON and send the request
      request.add(utf8.encode(jsonEncode(productData)));

      // Await the response
      HttpClientResponse response = await request.close();

      String responseBody = await response.transform(utf8.decoder).join();
        print(responseBody);

      if (response.statusCode == 200) {
        String responseBody = await response.transform(utf8.decoder).join();
        print(responseBody);
        print("Product added successfully: $responseBody");
        obtenerProductos();
      } else {
        print("Failed to add product, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
    }
  }

  Future<void> updateProduct(
      Map<String, String> supplierData, String codigoProducto) async {
    final url = 'https://microtech.icu:5000/products/update/$codigoProducto';
    try {
      print(url);
      print(supplierData);
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      // Build the request to add the category endpoint
      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');

      // Convert categoryData to JSON and send the request
      request.add(utf8.encode(jsonEncode(supplierData)));

      // Await the response
      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        print("Product updated successfully.");
      } else {
        String json = await response.transform(utf8.decoder).join();
        print(jsonDecode(json));
        print("Failed to update product, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
    }
  }
}

class VerProductosPage extends StatelessWidget {
  final ProductoService carritoService = Get.put(ProductoService());

  VerProductosPage() {
    carritoService.obtenerProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos', style: TextStyle(color: Color(0xFFFAFAFA))),
        centerTitle: true,
        backgroundColor: Color(0xFF09184D),
      iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (carritoService.productos.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: carritoService.productos.length,
          itemBuilder: (context, index) {
            final producto = carritoService.productos[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                leading: const SizedBox(
                  width: 40, // Especifica el ancho del ícono
                  height: 40, // Especifica la altura del ícono
                  child: Icon(Icons.menu, color: Color(0xFF09184D)),
                ),
                title: Text(
                  producto['NAME'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Precio: \$${producto['PRICE'].toString()}'),
                    Text(
                        'Cantidad: ${producto['QUANTITY'].toString()}'), // Suponiendo que hay un campo 'QUANTITY'
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetalleProductoPage(producto: producto),
                    ),
                  );
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProductDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String id = '';
    String name = '';
    int price = 0;
    String description = '';
    int? quantity;
    int? categoryId;
    int? supplierId;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar nuevo producto'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'ID (varchar)'),
                    onSaved: (value) => id = value ?? '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el ID';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    onSaved: (value) => name = value ?? '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el nombre';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Precio'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) =>
                        price = int.tryParse(value ?? '0') ?? 0,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el precio';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    onSaved: (value) => description = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => quantity = value != null &&
                            value.isNotEmpty
                        ? int.tryParse(value)
                        : null,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'ID de Categoría'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => categoryId = value != null &&
                            value.isNotEmpty
                        ? int.tryParse(value)
                        : null,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'ID de Proveedor'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => supplierId = value != null &&
                            value.isNotEmpty
                        ? int.tryParse(value)
                        : null,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Agregar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _addProduct(context, id, name, price, description, quantity,
                      categoryId, supplierId);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addProduct(
      BuildContext context,
      String id,
      String name,
      int price,
      String description,
      int? quantity,
      int? categoryId,
      int? supplierId) {
    // Aquí llamas a tu método addProduct del ProductoService
    carritoService
        .addProduct({
          'id': id,
          'name': name,
          'price': price,
          'description': description,
          'quantity': quantity,
          'category_id': categoryId,
          'supplier_id': supplierId,
        })
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto agregado exitosamente')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al agregar el producto')),
      );
    });
  }
}
