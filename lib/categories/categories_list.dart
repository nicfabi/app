// ignore_for_file: avoid_print
import 'package:app/categories/categories_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  Future<List<Widget>>? _futureCategories;

  @override
  void initState() {
    super.initState();
    loadCategories_add();
  }

  void loadCategories_add() {
    setState(() {
      _futureCategories = CategoriesService.loadCategories(
        onDelete: () {
          loadCategories_add();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todas las categorias',
            style: TextStyle(color: Color(0xFFFAFAFA))),
        backgroundColor: const Color(0xFF09184D),
        centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Widget>>(
        future: _futureCategories,
        builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView(children: snapshot.data!);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text("No hay datos disponibles."));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSupplierDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddSupplierDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String name = '';
    String description = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar nueva categoría'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
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
              child: const Text('Agregar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _addSupplier(context, name, description);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addSupplier(BuildContext context, String name, String description) {
    CategoriesService.addCategory({'name': name, 'description': description})
        .then((_) {
      loadCategories_add();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Categoría agregada exitosamente')),
    );
  }
}
