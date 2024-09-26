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
          producto['IMAGE'] = 'https://microtech.icu:5000/${producto['IMAGE']}';
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

      if (response.statusCode == 200) {
        String responseBody = await response.transform(utf8.decoder).join();
        print("Product added successfully: $responseBody");
        obtenerProductos();
      } else {
        print("Failed to add product, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
    }
  }

  updateProduct(String id, Map<String, Object?> map) {}
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

      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'application/json');

      request.add(utf8.encode(jsonEncode(supplierData)));

      HttpClientResponse response = await request.close();
      print(response);

      if (response.statusCode == 200) {
        print("Supplier updated successfully.");
      } else {
        print("Failed to update supplier, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
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
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Image.network(producto['IMAGE'], width: 50, height: 50),
              title: Text(
                producto['NAME'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Precio: \$${producto['PRICE'].toString()}'),
                  Text('Descripción: ${producto['DESCRIPTION']}'),
                  // Agrega más detalles del producto si es necesario
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalleProductoPage(producto: producto),
                  ),
                );
              },
            ),
          );
        },
      );
    }),
  );
}

}
