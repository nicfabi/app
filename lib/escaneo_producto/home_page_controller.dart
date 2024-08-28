import 'package:app/carro_compra/carrito_servicio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class HomePageController extends GetxController {
  final valorCodigoBarras = ''.obs;
  final CarritoService _carritoService = Get.find<CarritoService>();

  List<Map<String, dynamic>> get productos => _carritoService.productos;
  double get total => _carritoService.total;

  Future<void> escanearCodigoBarras(BuildContext context) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancelar',
      true,
      ScanMode.BARCODE,
    );

    if (barcodeScanRes == '-1') {
      Get.snackbar('Cancelado', 'Lectura Cancelada');
    } else {
      update();
      Get.find<CarritoService>().agregarProductoAPI(context, barcodeScanRes);
    }
  }
}
