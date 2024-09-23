import 'package:app/productos/all_products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Asegúrate de importar el servicio

class DetalleProductoPage extends StatelessWidget {
  final Map<String, dynamic> producto;
  final RxInt selectedIndexValue; // Recibir el selectedIndexValue

  final ProductoService productoService = Get.find<ProductoService>();

  DetalleProductoPage({
    required this.producto,
    required this.selectedIndexValue, // Incluir selectedIndexValue en el constructor
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(producto['NAME']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                producto['IMAGE'],
                width: 200,
                height: 200,
              ),
            ),
            SizedBox(height: 16),
            Text('Nombre: ${producto['NAME']}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('Precio: \$${producto['PRICE']}',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('Descripción: ${producto['DESCRIPTION']}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Cantidad: ${producto['QUANTITY']}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Categoría: ${producto['CATEGORY_ID']}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Proveedor: ${producto['SUPPLIER_ID']}',
                style: TextStyle(fontSize: 16)),
            Spacer(),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Acción para editar el producto (si lo necesitas)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF09184D),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    child: Text('Editar'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      // Eliminar el producto
                      await productoService.DeleteProduct(
                          context, producto['ID']);

                      // Refrescar los productos
                      await productoService.obtenerProductos();

                      // Mostrar snackbar confirmando la eliminación
                      Get.snackbar('Producto Eliminado',
                          'El producto ha sido eliminado correctamente.');

                      // Forzar navegación a la página de productos si Get.back() no funciona
                      Get.offAllNamed(
                          VerProductosPage() as String); // Navega a la página de productos, limpiando la pila de navegación
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    child: Text('Eliminar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}