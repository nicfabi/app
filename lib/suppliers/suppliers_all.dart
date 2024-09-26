// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:app/suppliers/suppliersService.dart';

class ListaSuppliers extends StatefulWidget {
  const ListaSuppliers({super.key});

  @override
  State<ListaSuppliers> createState() => _ListaSuppliersState();
}

class _ListaSuppliersState extends State<ListaSuppliers> {
  Future<List<Widget>>? _futureSuppliers;

  @override
  void initState() {
    super.initState();
    loadSuppliers_add();
  }

  void loadSuppliers_add() {
    setState(() {
      _futureSuppliers = SupplierService.loadSuppliers(
        onDelete: () {
          loadSuppliers_add();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todas los proovedores',
            style: TextStyle(color: Color(0xFFFAFAFA))),
        backgroundColor: const Color(0xFF09184D),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Widget>>(
        future: _futureSuppliers,
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
    String phone = '';
    String email = '';
    String city = '';
    String brand = '';
    String lastname = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar nuevo proveedor'),
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
                    decoration: const InputDecoration(labelText: 'Apellido'),
                    onSaved: (value) => lastname = value ?? '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el apellido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Teléfono'),
                    onSaved: (value) => phone = value ?? '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el teléfono';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Correo'),
                    onSaved: (value) => email = value ?? '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el correo';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Ciudad'),
                    onSaved: (value) => city = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Marca'),
                    onSaved: (value) => brand = value ?? '',
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
                  _addSupplier(
                      context, name, phone, email, city, brand, lastname);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addSupplier(BuildContext context, String name, String phone,
      String email, String city, String brand, String lastname) {
    SupplierService.addSupplier({
      'name': name,
      'phone': phone,
      'email': email,
      'city': city,
      'brand': brand,
      'lastname': lastname,
    }).then((_) {
      // After adding a supplier, reload the list
      loadSuppliers_add();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Proveedor agregado exitosamente')),
    );
  }
}
