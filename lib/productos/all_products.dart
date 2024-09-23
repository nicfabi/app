import 'dart:convert';

import 'package:app/productos/DetalleProductoPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductoService extends GetxController {
  var productos = <Map<String, dynamic>>[].obs;
  var productoSeleccionado = Rxn<Map<String, dynamic>>();

  Future<void> obtenerProductos() async {
    try {
      const url = 'https://microtech.icu:5000/products/allProducts';
      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        productos.clear();
        data.forEach((producto) {
          producto['IMAGE'] =
              'https://microtech.icu:5000/product/${producto['IMAGE']}';
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
    try {
      final url = 'https://microtech.icu:5000/products/delete/$codigoProducto';
      print(url);
      final response = await http.delete(Uri.parse(url));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode < 300) {
        // Eliminar el producto de la lista localmente
        productos.removeWhere((producto) => producto['ID'] == codigoProducto);
        Get.snackbar('Producto Eliminado', 'Producto eliminado correctamente.');
      } else {
        Get.snackbar('Error', 'No se pudo eliminar el producto.');
      }
    } catch (e) {
      print('Error occurred: $e');
      Get.snackbar(
          'Error', 'Ocurrió un error al intentar eliminar el producto.');
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
        title: Text('Productos'),
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
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading:
                    Image.network(producto['IMAGE'], width: 50, height: 50),
                title: Text(producto['NAME']),
                subtitle: Text('Precio: \$${producto['PRICE'].toString()}'),
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