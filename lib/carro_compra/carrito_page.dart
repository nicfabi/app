
import 'package:app/carro_compra/carrito_servicio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarritoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CarritoService carritoService = Get.find<CarritoService>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de Compras', style: TextStyle(color: Color(0xFFFAFAFA))),
        centerTitle: true,
        backgroundColor: Color(0xFF09184D),
      ),
      body: Obx(() => ListView.builder(
            itemCount: carritoService.productos.length,
            itemBuilder: (context, index) {
              final producto = carritoService.productos[index];
              return ListTile(
                title: Text(producto['NAME']),
                subtitle: Text('\$ ${producto['PRICE']} pesos'),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(producto['IMAGE']),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => carritoService.eliminarProducto(index),
                ),
              );
            },
          )),
      bottomNavigationBar: Obx(() => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total de artículos: ${carritoService.productos.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }
}




/* class CarritoPage extends GetView<CarritoService> {
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
                title: Text(producto['NAME']),
                subtitle: Text('\$: ${producto['PRICE']}'),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(producto['IMAGE']),
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
} */



