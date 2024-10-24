import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'carro_compra/carrito_servicio.dart';

class PagoPage extends GetView<CarritoService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pago',
          style: TextStyle(color: Color(0xFFFAFAFA)),
        ),
        backgroundColor: const Color(0xFF09184D),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(
              () => Text(
                'Total a pagar: \$${controller.total.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF09184D),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Obx(
              () {
                if (controller.total > 0.00) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Ingrese el número de identificación del cliente',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                        ),
                        onChanged: (value) {
                          controller.setClienteSeleccionado(value);
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: const Color(0xFF09184D),
                        ),
                        child: const Text(
                          'Realizar Pago',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onPressed: () {
                          
                          
                            controller.agregarCarrito(
                              context, controller.clienteSeleccionado);
                            Get.snackbar('Pago', 'Pago realizado con éxito',
                                snackPosition: SnackPosition.BOTTOM);
                            Get.snackbar(
                              'Factura Enviada',
                              "Factura enviada con éxito!",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            controller.limpiarCarrito();
                          
                        },
                      ),
                    ],
                  );
                } else {
                  return const Text(
                    'No hay productos en el carrito para pagar',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
