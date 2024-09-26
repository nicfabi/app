import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CarritoService extends GetxController {
  final RxList<Map<String, dynamic>> _productos = <Map<String, dynamic>>[].obs;
  static String dUrl = dotenv.env['URL']!;
  static String compraUrl = '$dUrl/shopcart/compra';

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
        //data['IMAGE'] = 'microtech.icu/shopcart/${data['IMAGE']}';
        data['IMAGE'] =
            'https://i.pinimg.com/564x/5f/4b/ad/5f4bad284f80e3e69924e826c574418a.jpg';
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

  Future<void> agregarCarrito(BuildContext context) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode(productos);
    print(body);

    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    HttpClientRequest request = await client.postUrl(Uri.parse(compraUrl));
    request.headers.set('Content-Type', 'application/json; charset=UTF-8');
    request.add(utf8.encode(body));
    HttpClientResponse response = await request.close();

    if (response.statusCode == 200) {
      String jsonString = await response.transform(utf8.decoder).join();
      final carrito = jsonDecode(jsonString);
      enviarFactura(context, carrito['id_carro'][0]["ID"]);
      print("Compra realizada correctamente: ${carrito}");
    } else {
      Get.snackbar('Error', 'No se pudo realizar la compra');
    }
  }

  Future<void> enviarFactura(BuildContext context, int soldCartId) async {
    final dUrl = dotenv.env['URL'];
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({'soldCartId': soldCartId});
    String url = '$dUrl/bill/send';
    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('Content-Type', 'application/json; charset=UTF-8');
    request.add(utf8.encode(body));
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      String jsonString = await response.transform(utf8.decoder).join();
      print("Factura enviada correctamente: ${jsonDecode(jsonString)}");
    } else {
      Get.snackbar('Error', 'No se pudo enviar la factura');
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
