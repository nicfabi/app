import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class CarritoService extends GetxController {



  final RxList<Map<String, dynamic>> _productos = <Map<String, dynamic>>[].obs;
  static const String compraUrl = 'http://microtech.icu:6969/shopcart/compra';
  var clienteSeleccionado = RxnString(); // Estado del cliente seleccionado

  List<Map<String, dynamic>> get productos => _productos;
  get total => _productos.fold(0.0, (sum, producto) => sum + (producto['PRICE']));

  // Método para configurar el cliente seleccionado
  void setClienteSeleccionado(String id) {
    clienteSeleccionado.value = id;
  }

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
        data['IMAGE'] = 'https://i.pinimg.com/564x/5f/4b/ad/5f4bad284f80e3e69924e826c574418a.jpg';
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

  // Método para agregar el carrito
  Future<void> agregarCarrito(BuildContext context, RxnString id) async {

    final headers = {
      'Content-Type': 'application/json',
    };
      final body = jsonEncode({
    'cliente_id': id.value, 
    'productos': productos,
  });

    try {
      final response = await http.post(
        Uri.parse(compraUrl),
        headers: headers,
        body: body,
      );
      final rta = jsonDecode(response.body);
      final approved = rta["status"];
      if (approved == "approved") {
        final carritoId = rta['id_carro'][0]["ID"];
        enviarFactura(context, carritoId);
      } else {
        Get.snackbar('Error', 'No se pudo realizar la compra');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error al realizar la compra');
    }
  }

  Future<void> enviarFactura(BuildContext context, int soldCartId) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({'soldCartId': soldCartId});
    const url = 'http://microtech.icu:8888/bill/send';
    await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
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
    clienteSeleccionado.value = null; // Desseleccionar el cliente al limpiar
  }
}
