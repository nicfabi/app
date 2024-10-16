// ignore_for_file: avoid_print

import 'package:app/customers/customersService.dart';
import 'package:flutter/material.dart';

class ListaCustomers extends StatefulWidget {
  const ListaCustomers({super.key});

  @override
  State<ListaCustomers> createState() => _ListaCustomersState();
}

class _ListaCustomersState extends State<ListaCustomers> {
  Future<List<Widget>>? _futureCustomers;

  @override
  void initState() {
    super.initState();
    loadCustomers_add();
  }

  void loadCustomers_add() {
    setState(() {
      _futureCustomers = CustomersService.loadCustomers(
        onDelete: () {
          loadCustomers_add();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos los proveedores',
            style: TextStyle(color: Color(0xFFFAFAFA))),
        backgroundColor: const Color(0xFF09184D),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Widget>>(
        future: _futureCustomers,
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
          _showAddCustomerDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCustomerDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String name = '';
    String phone = '';
    String email = '';
    String billVia = 'W'; // Default value for bill via
    String lastname = '';
    String id='';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar nuevo Cliente'),
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
                    decoration: const InputDecoration(labelText: 'Número de identificación'),
                    onSaved: (value) => id = value ?? '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el número de identificación';
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
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Medio de facturación'),
                    value: billVia,
                    items: const [
                      DropdownMenuItem(
                        child: Text('Whatsapp'),
                        value: 'W',
                      ),
                      DropdownMenuItem(
                        child: Text('Correo'),
                        value: 'E',
                      ),
                      DropdownMenuItem(
                        child: Text('Whatsapp y Correo'),
                        value: 'WE',
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        billVia = value!;
                      });
                    },
                    onSaved: (value) => billVia = value ?? 'W',
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
                  _addCustomer(
                      context, name, phone, email, billVia, lastname, id);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addCustomer(BuildContext context, String name, String phone,
      String email, String billVia, String lastname, String id) {
    CustomersService.addCustomer({
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'bill_via': billVia,
      'lastname': lastname,
    }).then((_) {
      // After adding a customer, reload the list
      loadCustomers_add();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cliente agregado exitosamente')),
    );
  }
}
