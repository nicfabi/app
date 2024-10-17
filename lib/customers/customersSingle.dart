import 'package:flutter/material.dart';
import 'package:app/customers/customersService.dart';

class CustomersSingle extends StatefulWidget {
  final String id;
  String name;
  String lastname;
  String phone;
  String email;
  String billVia;
  final Function callback;

  CustomersSingle({
    required this.id,
    required this.name,
    required this.lastname,
    required this.phone,
    required this.email,
    required this.billVia,
    required this.callback,
    super.key,
  });

  @override
  State<CustomersSingle> createState() => _CustomersSingleState();
}

class _CustomersSingleState extends State<CustomersSingle> {
  Color morado = const Color(0xFF09184D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.name} ${widget.lastname}', style: const TextStyle(color: Color(0xFFFAFAFA))),
        backgroundColor: morado,
        centerTitle: true,
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
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF09184D),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${widget.name} ${widget.lastname}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.book, color: morado),
                    const SizedBox(width: 10),
                    Text('Número de identificación: ${widget.id}'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.phone, color: morado),
                    const SizedBox(width: 10),
                    Text('Teléfono: ${widget.phone}'),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.email, color: morado),
                    const SizedBox(width: 10),
                    Text('Email: ${widget.email}'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.message, color: morado),
                    const SizedBox(width: 10),
                    Text(_getBillViaText(widget.billVia)),
                  ],
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
                  child: const Text('Volver', style: TextStyle(color: Colors.white)),
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
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  String _getBillViaText(String billVia) {
    switch (billVia) {
      case 'W':
        return 'Whatsapp';
      case 'E':
        return 'Email';
      case 'WE':
        return 'Whatsapp y Email';
      default:
        return 'Desconocido';
    }
  }

  void _showEditSupplierDialog(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  String name = widget.name;
  String phone = widget.phone;
  String email = widget.email;
  String billVia = widget.billVia;
  String lastname = widget.lastname;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Editar cliente'),
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
                  initialValue: lastname,
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
                  initialValue: phone,
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
                  initialValue: email,
                  decoration: const InputDecoration(labelText: 'Correo'),
                  onSaved: (value) => email = value ?? '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el correo';
                    }
                    return null;
                  },
                ),
                DropdownButton<String>(
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
                    billVia = value ?? 'W';
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
                _updateCustomer(
                  context,
                  widget.id,
                  name,
                  phone,
                  email,
                  lastname,
                  billVia,
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

void _updateCustomer(BuildContext context, String id, String name,
    String phone, String email, String lastname, String billVia) {
  CustomersService.updateCustomer({
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'lastname': lastname,
    'bill_via': billVia,
  }, id).then((_) {
    if (mounted) {
      setState(() {
        widget.callback();
        widget.name = name;
        widget.lastname = lastname;
        widget.phone = phone;
        widget.email = email;
        widget.billVia = billVia;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('cliente actualizado exitosamente')),
      );
    }
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error al actualizar el cliente')),
    );
  });
}
}