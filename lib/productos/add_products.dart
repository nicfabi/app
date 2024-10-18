import 'package:app/productos/all_products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProducts extends StatefulWidget {
  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final ProductoService productoService = Get.put(ProductoService());

  @override
  void initState() {
    super.initState();
    productoService.obtenerProductos();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos los productos'),
      ),
      body: Obx(() {
        if (productoService.productos.isEmpty) {
          return const Center(child: Text("No hay productos disponibles."));
        } else {
          return ListView.builder(
            itemCount: productoService.productos.length,
            itemBuilder: (context, index) {
              final producto = productoService.productos[index];
              return ListTile(
                title: Text(producto['name']),
                subtitle: Text('Precio: \$${producto['price']}'),
                leading: Image.network(producto['image'], width: 50, height: 50),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    productoService.DeleteProduct(context, producto['id']);
                  },
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProductDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String id = '',
        name = '',
        price = '',
        description = '',
        quantity = '',
        categoryId = '',
        supplierId = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar nuevo producto'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'ID'),
                    onSaved: (value) => id = value ?? '',
                    validator: (value) =>
                        value!.isEmpty ? 'Por favor ingrese el ID del producto' : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    onSaved: (value) => name = value ?? '',
                    validator: (value) =>
                        value!.isEmpty ? 'Por favor ingrese el nombre' : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Precio'),
                    onSaved: (value) => price = value ?? '',
                    validator: (value) =>
                        value!.isEmpty ? 'Por favor ingrese el precio' : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    onSaved: (value) => description = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                    onSaved: (value) => quantity = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'ID de Categoría'),
                    onSaved: (value) => categoryId = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'ID del Proveedor'),
                    onSaved: (value) => supplierId = value ?? '',
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Agregar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _addProduct(context, id, name, price, description, quantity, categoryId, supplierId);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addProduct(
    BuildContext context,
    String id,
    String name,
    String price,
    String description,
    String quantity,
    String categoryId,
    String supplierId,
  ) {
    productoService.addProduct({
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'quantity': quantity,
      'category_id': categoryId,
      'supplier_id': supplierId,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto agregado exitosamente')),
    );
  }
}
