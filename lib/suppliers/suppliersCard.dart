import 'package:app/suppliers/suppliersSingle.dart';
import 'package:app/suppliers/suppliers_all.dart';
import 'package:flutter/material.dart';
import 'package:app/suppliers/suppliersService.dart';
import 'package:get/get.dart';

class SuppliersCard extends StatefulWidget {
  final String id;
  final String name;
  final String lastname;
  final String phone;
  final String email;
  final String city;
  final String brand;

  final VoidCallback onDelete; // Callback to trigger parent widget's refresh

  const SuppliersCard({
    super.key,
    required this.id,
    required this.name,
    required this.lastname,
    required this.phone,
    required this.email,
    required this.city,
    required this.brand,
    required this.onDelete, // Pass a callback function to handle deletion
  });

  get widget => null;

  @override
  _SuppliersCardState createState() => _SuppliersCardState();
}

class _SuppliersCardState extends State<SuppliersCard> {
  List<Widget> _suppliersList = []; // Lista original de proveedores
  List<Widget> _filteredSuppliersList = []; // Lista filtrada
  String _searchTerm = '';
  bool _isDeleting = false;

  void initState() {
    super.initState();
  }

  void _filterSuppliers(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm;
      _filteredSuppliersList = _suppliersList.where((supplier) {
        final card = supplier as SuppliersCard;
        return card.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
              card.lastname.toLowerCase().contains(searchTerm.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
            Text('City: ${widget.city}'),
            Text('Brand: ${widget.brand}'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Supplierssingle(
                            id: widget.id,
                            name: widget.name,
                            lastname: widget.lastname,
                            phone: widget.phone,
                            email: widget.email,
                            city: widget.city,
                            brand: widget.brand,
                            callback: () {
                              setState(() {
                                widget.onDelete();
                              });
                            },
                          )),
                );
              },
              child: const Text('Ver detalles',
                  style: TextStyle(color: Color(0xFF09184D))),
            ),
          ],
        ),
        trailing: _isDeleting
            ? const CircularProgressIndicator() // Show loader while deleting
            : IconButton(
                icon: const Icon(Icons.delete,
                    color: Color.fromARGB(255, 158, 30, 21)),
                onPressed: () {
                  _showDeleteConfirmationDialog(context);
                },
              ),
        onTap: () {
          print('Supplier selected: ${widget.name}');
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Supplierssingle(
                      id: widget.id,
                      name: widget.name,
                      lastname: widget.lastname,
                      phone: widget.phone,
                      email: widget.email,
                      city: widget.city,
                      brand: widget.brand,
                      callback: () {
                        setState(() {
                          widget.onDelete();
                        });
                      },
                    )),
          );
        },
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
          content:
              const Text('¿Está seguro de que desea eliminar este proveedor?'),
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
                //_deleteSupplier();
                setState(() {
                  SupplierService.deleteSupplier(context, widget.id).then((_) {
                    widget.onDelete();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Proveedor eliminado correctamente'),
                      duration: const Duration(seconds: 2),
                    ));
                  });
                });
                Navigator.of(context).pop(); // Close the dialog
                // Trigger the delete action
              },
            ),
          ],
        );
      },
    );
  }
}
