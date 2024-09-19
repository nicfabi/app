import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'carro_compra/carrito_servicio.dart';

class PagoPage extends GetView<CarritoService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago', style: TextStyle(color: Color(0xFFFAFAFA))),
        backgroundColor: const Color(0xFF7E57C2),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
                  'Total a pagar: \$${controller.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.total > 0.00) {
                return ElevatedButton(
                  child: const Text('Realizar Pago'),
                  onPressed: () {
                    controller.agregarCarrito(context);
                    Get.snackbar('Pago', 'Pago realizado con éxito');
                    Get.snackbar(
                        'Factura Enviada', "Factura enviada con éxito!");
                    controller.limpiarCarrito();
                  },
                );
              } else {
                return Container(); // or any other widget you want to return when the condition is not met
              }
            })
          ],
        ),
      ),
    );
  }
}
