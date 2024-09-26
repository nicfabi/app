import 'package:app/categories/categories_service.dart';
import 'package:flutter/material.dart';

class CategoriesSingle extends StatefulWidget {
  final String id;
  String name;
  String description;

  CategoriesSingle({
    required this.id,
    required this.name,
    required this.description,
    super.key,
  });

  @override
  State<CategoriesSingle> createState() => _CategoriesSingleState();
}

class _CategoriesSingleState extends State<CategoriesSingle> {
  Color morado = const Color(0xFF7E57C2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: morado,
      ),
      body: Center(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.purple[100],
                  child: Icon(
                    Icons.category_outlined,
                    size: 50,
                    color: Colors.purple[700],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.description, color: morado),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.description,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: morado,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                      style: TextStyle(color: Colors.white), 'Volver'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showEditSupplierDialog(context);
        },
        backgroundColor: morado,
        child: const Icon(Icons.edit),
      ),
    );
  }

  void _showEditSupplierDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String name = widget.name;
    String description = widget.description;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar categoría'),
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
                    initialValue: description,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    onSaved: (value) => description = value ?? '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la descripción';
                      }
                      return null;
                    },
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
                  _updateCategory(context, widget.id, name, description);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _updateCategory(
      BuildContext context, String id, String name, String description) {
    CategoriesService.updateCategory({
      'name': name,
      'description': description,
    }, id)
        .then((_) {
      // After updating a supplier, you can show a confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Categoría actualizada exitosamente')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar la categoría')),
      );
    });
  }
}
