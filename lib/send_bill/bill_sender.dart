import 'package:app/carro_compra/carrito_servicio.dart';
import 'package:app/send_bill/bill_sender_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillSender extends GetView<CarritoService> {
  final int carritoId;

  const BillSender({super.key, required this.carritoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago', style: TextStyle(color: Color(0xFFFAFAFA))),
        backgroundColor: const Color(0xFF7E57C2),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BillSenderButton(
                callback: () {
                  controller.enviarFactura(context, carritoId);
                },
                text: 'Enviar Factura'),
          ],
        ),
      ),
    );
  }
}
