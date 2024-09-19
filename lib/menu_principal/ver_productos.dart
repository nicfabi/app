import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductoService extends GetxController {
  final RxList<Map<String, dynamic>> _productos = <Map<String, dynamic>>[].obs;

  List<Map<String, dynamic>> get productos => _productos;

  Future<void> obtenerProductos() async {
  try {
    const url = 'http://microtech.icu:6969/allProducts';
    final response = await http.get(Uri.parse(url));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      _productos.clear();
      data.forEach((producto) {
        producto['IMAGE'] =
            'http://microtech.icu:6969/product/${producto['IMAGE']}';
        _productos.add(Map<String, dynamic>.from(producto));
      });
      Get.snackbar('Productos cargados',
          'Todos los productos se han cargado correctamente.');
    } else {
      Get.snackbar('Error', 'No se pudieron cargar los productos.');
    }
  } catch (e) {
    print(e);
    Get.snackbar(
        'Error', 'Ocurrió un error al intentar cargar los productos.');
  }
}

}

class VerProductosPage extends StatelessWidget {
  final ProductoService carritoService =
      Get.put(ProductoService()); // Instancia del controlador

  @override
  Widget build(BuildContext context) {
    // Llamar el método de obtener productos al inicializar el widget
    carritoService.obtenerProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: Obx(() {
        // Si no hay productos, mostrar un indicador de carga o mensaje
        if (carritoService.productos.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        // Mostrar los productos en un ListView
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
                trailing: Icon(Icons.add_shopping_cart),
              ),
            );
          },
        );
      }),
    );
  }
}