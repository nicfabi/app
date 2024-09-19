import 'package:app/escaneo_producto/home_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomePageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escanear Producto',
            style: TextStyle(color: Color(0xFFFAFAFA))),
        backgroundColor: Color(0xFF7E57C2),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Escanear Código'),
              onPressed: () => controller.escanearCodigoBarras(context),
            ),
          ],
        ),
      ),
    );
  }
}
