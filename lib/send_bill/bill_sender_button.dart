import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillSenderButton extends StatelessWidget {
  final Function callback;
  final String text;

  const BillSenderButton(
      {super.key, required this.callback, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          callback();
          Get.snackbar(
              "Factura Enviada", "Factura enviada correctamente a $text");
        },
        child: Text(text));
  }
}
