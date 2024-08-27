import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'carrito_servicio.dart';

class CarritoPage extends GetView<CarritoService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de Compras',
            style: TextStyle(color: Color(0xFFFAFAFA))),
        backgroundColor: Color(0xFF7E57C2),
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.productos.length,
            itemBuilder: (context, index) {
              final producto = controller.productos[index];
              return ListTile(
                title: Text(producto['nombre']),
                subtitle: Text('Código: ${producto['id']}'),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(producto['urlImagen']),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => controller.eliminarProducto(index),
                ),
              );
            },
          )),
      bottomNavigationBar: Obx(() => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total de artículos: ${controller.productos.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }
}
