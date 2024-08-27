import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:lector_facturacion/carro_compra/carrito_servicio.dart';

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

    if (barcodeScanRes != '-1') {
      valorCodigoBarras.value = barcodeScanRes;
      // Simular la adición de producto
      final producto = {
        'id': barcodeScanRes,
        'nombre': 'Producto $barcodeScanRes',
        'cantidad': 1,
        'precio': 10.0,
        'urlImagen': 'https://via.placeholder.com/150',
      };
      _carritoService.agregarProducto(producto);
    } else {
      Get.snackbar('Cancelado', 'Lectura Cancelada');
    }
  }
}