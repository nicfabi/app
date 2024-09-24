import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class CarritoService extends GetxController {
  final RxList<Map<String, dynamic>> _productos = <Map<String, dynamic>>[].obs;

  List<Map<String, dynamic>> get productos => _productos;

  get total =>
      _productos.fold(0.0, (sum, producto) => sum + (producto['PRICE']));

  // Método para agregar producto desde la API
  Future<void> agregarProductoAPI(
      BuildContext context, String codigoProducto) async {
    try {
      final pr = ProgressDialog(context,
          type: ProgressDialogType.normal, isDismissible: true);
      final url = 'http://microtech.icu:6969/shopcart/${codigoProducto}';
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        data['IMAGE'] = 'microtech.icu/shopcart/${data['IMAGE']}';
        Map<String, dynamic> nuevoProducto = data;
        _productos.add(nuevoProducto);
        Get.snackbar('Producto Escaneado', data['NAME']);
      } else {
        Get.snackbar('Error', data['status']);
      }
      pr.hide();
    } catch (e) {
      print(e);
    }
  }

  Future<void> agregarCarrito(BuildContext context, List productos) async {
    try {

      //ESTO ES LO NUEVO, CAMBIEN LOS HTTP X ESTO
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      final uri = Uri.parse('https://microtech.icu:5000/shopcart/compra');
      HttpClientRequest request = await client.postUrl(uri);
      request.headers.set('Content-Type', 'application/json');
      final body = jsonEncode(productos);
      request.add(utf8.encode(body));
      HttpClientResponse response = await request.close();
      if (response.statusCode == 200) {
        String responseBody = await response.transform(utf8.decoder).join();
        final data = jsonDecode(responseBody);
        final carritoId = data['id_carro'][0]["ID"];
        enviarFactura(context, carritoId);
      } else {
        print('Error al realizar la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
    }
  }
  
  Future<void> enviarFactura(BuildContext context, int soldCartId) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({'soldCartId': soldCartId});
    const url = 'http://microtech.icu:8888/bill/send';
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      print("Factura enviada correctamente: ${response.body}");
    }
  }

  // Métodos locales del carrito
  void agregarProductoLocal(Map<String, dynamic> producto) {
    _productos.add(producto);
  }

  void eliminarProducto(int index) {
    _productos.removeAt(index);
  }

  void limpiarCarrito() {
    _productos.clear();
  }
}
