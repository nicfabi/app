import 'package:app/categories/categories_service.dart';
import 'package:app/categories/categories_single.dart';
import 'package:flutter/material.dart';
import 'package:app/suppliers/suppliersService.dart';
import 'package:get/get.dart';

class CategoriesCard extends StatefulWidget {
  final String id;
  final String name;
  final String description;

  final VoidCallback onDelete; // Callback to trigger parent widget's refresh

  const CategoriesCard({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.onDelete, // Pass a callback function to handle deletion
  });

  @override
  _CategoriesCardState createState() => _CategoriesCardState();
}

class _CategoriesCardState extends State<CategoriesCard> {
  bool _isDeleting = false;

  void initState() {
    super.initState();
  } // To show a loading state when deleting

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
        leading: const Icon(Icons.category, color: Color(0xFF7E57C2), size: 40),
        title: Text(
          widget.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.description),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategoriesSingle(
                            id: widget.id,
                            name: widget.name,
                            description: widget.description,
                          )),
                );
              },
              child: Text('Ver detalles'),
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
          print('Category selected: ${widget.name}');
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoriesSingle(
                      id: widget.id,
                      name: widget.name,
                      description: widget.description,
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
              const Text('¿Está seguro de que desea eliminar esta categoría?'),
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
                  CategoriesService.deleteCategory(context, widget.id)
                      .then((_) {
                    widget.onDelete(); // Trigger the parent widget's refresh
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Categoría eliminada correctamente'),
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
