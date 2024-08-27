import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lector_facturacion/escaneo_producto/home_page_controller.dart';


class HomePage extends GetView<HomePageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escanear Producto',style: TextStyle(color: Color(0xFFFAFAFA))),
        backgroundColor: Color(0xFF7E57C2),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Escanear Código'),
              onPressed: () => controller.escanearCodigoBarras(context),
            ),
            SizedBox(height: 20),
            Obx(() => Text(
              'Último código escaneado: ${controller.valorCodigoBarras.value}',
              style: TextStyle(fontSize: 18),
            )),
          ],
        ),
      ),
    );
  }
}