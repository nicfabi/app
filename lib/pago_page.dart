import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'carro_compra/carrito_servicio.dart';

class PagoPage extends GetView<CarritoService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago', style: TextStyle(color: Color(0xFFFAFAFA))),
        backgroundColor: const Color(0xFF09184D),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
               Obx(() => Row( // Cambiamos a Row para alinear el icono y el texto
            mainAxisAlignment: MainAxisAlignment.center, // Centramos el contenido
            children: [
              Icon(Icons.monetization_on, size: 30, color: Color(0xFF09184D)),// Icono de dinero
              const SizedBox(width: 8), // Espacio entre el icono y el texto
              Text(
                'Total a pagar: \$${controller.total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          )),
      const SizedBox(height: 20),
            Obx(() {
              if (controller.total > 0.00) {
                return ElevatedButton(
                  child: const Text('Realizar Pago',style: TextStyle(color: Colors.white,fontSize: 15)),
                  onPressed: () {
                    controller.agregarCarrito(context);
                    Get.snackbar('Pago', 'Pago realizado con éxito');
                    Get.snackbar(
                        'Factura Enviada', "Factura enviada con éxito!");
                    controller.limpiarCarrito();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF09184D),
                    padding: EdgeInsets.symmetric(horizontal: 29, vertical: 13), 
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), 
                  ),
                  elevation: 10, 
                  )
                );
              } else {
                return Container(); 
              }
            })
          ],
        ),
      ),
    );
  }
}
