import 'package:app/productos/all_products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Asegúrate de importar el servicio

class DetalleProductoPage extends StatelessWidget {
  final Map<String, dynamic> producto;
  final ProductoService productoService = Get.find<ProductoService>();

  DetalleProductoPage({
    required this.producto,
  });

  Color morado = Color(0xFF09184D);

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Productos', style: TextStyle(color: Color(0xFFFAFAFA))),
      centerTitle: true,
      backgroundColor: Color(0xFF09184D),
    ),
    body: Obx(() {
      if (productoService.productos.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }

      return ListView.builder(
        itemCount: productoService.productos.length,
        itemBuilder: (context, index) {
          final producto = productoService.productos[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: SizedBox(
                width: 40, // Especifica el ancho del ícono
                height: 40, // Especifica la altura del ícono
                child: const Icon(Icons.store, color: Color(0xFF09184D)), // Ícono en lugar de imagen
              ),
              title: Text(
                producto['NAME'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Precio: \$${producto['PRICE'].toString()}'),
                  Text('Cantidad: ${producto['QUANTITY'].toString()}'), // Suponiendo que hay un campo 'QUANTITY'
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalleProductoPage(producto: producto),
                  ),
                );
              },
            ),
          );
        },
      );
    }),
  );
}



  Widget _buildDetailRow(IconData icon, String label, String value) { // Cambiar a String
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, color: morado),
        const SizedBox(width: 10),
        Expanded( // Permitir que el texto se ajuste y ocupe el espacio restante
          child: Text(
            '$label: $value',
            style: const TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis, // Manejo de texto que excede
            maxLines: 3, // Limitar a 3 líneas
          ),
        ),
      ],
    );
  }

  void _showEditProductDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String name = producto['NAME'];
    double price = producto['PRICE'].toDouble(); // Cambiar a double
    String description = producto['DESCRIPTION'];
    String quantity = producto['QUANTITY'].toString(); // Conversión a String
    String categoryId = producto['CATEGORY_ID'].toString(); // Conversión a String
    String supplierId = producto['SUPPLIER_ID'].toString(); // Conversión a String

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Producto'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: name,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    onSaved: (value) => name = value ?? '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el nombre';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: price.toString(), // Conversión a String
                    decoration: const InputDecoration(labelText: 'Precio'),
                    onSaved: (value) => price = double.tryParse(value ?? '0') ?? 0.0, // Guardar como double
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el precio';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: description,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    onSaved: (value) => description = value ?? '',
                  ),
                  TextFormField(
                    initialValue: quantity, // Ya es String
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                    onSaved: (value) => quantity = value ?? '',
                  ),
                  TextFormField(
                    initialValue: categoryId, // Ya es String
                    decoration: const InputDecoration(labelText: 'Categoría ID'),
                    onSaved: (value) => categoryId = value ?? '',
                  ),
                  TextFormField(
                    initialValue: supplierId, // Ya es String
                    decoration: const InputDecoration(labelText: 'Proveedor ID'),
                    onSaved: (value) => supplierId = value ?? '',
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Actualizar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _updateProduct(
                    context,
                    producto['ID'],
                    name,
                    price,
                    description,
                    int.tryParse(quantity),
                    int.tryParse(categoryId),
                    int.tryParse(supplierId),
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _updateProduct(BuildContext context, String id, String name, double price, String description, int? quantity, int? categoryId, int? supplierId) {
    // Lógica para actualizar el producto en tu servicio
    productoService.updateProduct(id, {
      'NAME': name,
      'PRICE': price,
      'DESCRIPTION': description,
      'QUANTITY': quantity,
      'CATEGORY_ID': categoryId,
      'SUPPLIER_ID': supplierId,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto actualizado exitosamente')),
      );
      // Aquí podrías actualizar la UI o hacer algo más después de la actualización
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar el producto')),
      );
    });
  }
}
