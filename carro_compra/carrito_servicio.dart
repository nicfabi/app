import 'package:get/get.dart';

class CarritoService extends GetxController {
  final RxList<Map<String, dynamic>> _productos = <Map<String, dynamic>>[].obs;

  List<Map<String, dynamic>> get productos => _productos;

  double get total => _productos.fold(0.0, (sum, producto) => sum + (producto['precio'] as double));

  void agregarProducto(Map<String, dynamic> producto) {
    _productos.add(producto);
  }

  void eliminarProducto(int index) {
    _productos.removeAt(index);
  }

  void limpiarCarrito() {
    _productos.clear();
  }
}