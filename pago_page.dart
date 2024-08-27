import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lector_facturacion/carro_compra/carrito_servicio.dart';

class PagoPage extends GetView<CarritoService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pago',style: TextStyle(color: Color(0xFFFAFAFA))),
        backgroundColor: Color(0xFF7E57C2),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
              'Total a pagar: \$${controller.total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Realizar Pago'),
              onPressed: () {
                // Implementar lógica de pago aquí
                Get.snackbar('Pago', 'Pago realizado con éxito');
                controller.limpiarCarrito();
              },
            ),
          ],
        ),
      ),
    );
  }
}