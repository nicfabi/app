import 'package:app/customers/customersSingle.dart';
import 'package:flutter/material.dart';
import 'package:app/customers/customersService.dart';

class CustomersCard extends StatefulWidget {
  final String id;
  final String name;
  final String lastname;
  final String phone;
  final String email;
  final String billVia;
  final VoidCallback onDelete; // Callback to trigger parent widget's refresh

  const CustomersCard({
    super.key,
    required this.id,
    required this.name,
    required this.lastname,
    required this.phone,
    required this.email,
    required this.billVia,
    required this.onDelete, // Pass a callback function to handle deletion
  });

  @override
  _CustomersCardState createState() => _CustomersCardState();
}

class _CustomersCardState extends State<CustomersCard> {
  bool _isDeleting = false; // To show a loading state when deleting

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: const Icon(Icons.store, color: Color(0xFF09184D), size: 40),
        title: Text(
          '${widget.name} ${widget.lastname}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phone: ${widget.phone}'),
            Text('Email: ${widget.email}'),
            Text(
              'Send bill via: ${_getBillViaText(widget.billVia)}',
              style: const TextStyle(color: Colors.grey),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomersSingle(
                      id: widget.id,
                      name: widget.name,
                      lastname: widget.lastname,
                      phone: widget.phone,
                      email: widget.email,
                      billVia: widget.billVia,
                      callback: widget.onDelete,
                    ),
                  ),
                );
              },
              child: const Text(
                'Ver detalles',
                style: TextStyle(color: Color(0xFF09184D)),
              ),
            ),
          ],
        ),
      trailing: _isDeleting
    ? const CircularProgressIndicator() 
    : IconButton(
        icon: const Icon(
          Icons.delete,
          color: Color.fromARGB(255, 158, 30, 21),
        ),
        onPressed: _isDeleting ? null : () { _showDeleteConfirmationDialog(context); },
      ),

      ),
    );
  }

  // Function to show a confirmation dialog before deleting
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Está seguro de que desea eliminar este cliente?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                _deleteSupplier(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Function to delete a supplier
 void _deleteSupplier(BuildContext context) {
  Navigator.of(context).pop(); // Close the dialog first
  setState(() {
    _isDeleting = true;
  });

  CustomersService.deleteCustomer(context, widget.id).then((_) {
    if (mounted) {
      setState(() {
        _isDeleting = false;
        widget.onDelete();
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cliente eliminado correctamente')),
    );
  }).catchError((error) {
    if (mounted) {
      setState(() {
        _isDeleting = false;
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error al eliminar el cliente')),
    );
  });
}


  // Function to get the display text for billVia
  String _getBillViaText(String billVia) {
    switch (billVia) {
      case 'W':
        return 'Whatsapp';
      case 'E':
        return 'Email';
      case 'WE':
        return 'Whatsapp and Email';
      default:
        return 'Unknown';
    }
  }
}
