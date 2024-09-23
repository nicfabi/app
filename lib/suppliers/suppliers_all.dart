 // ignore_for_file: avoid_print


import 'package:app/suppliers/suppliersService.dart';
import 'package:flutter/material.dart';



class ListaSuppliers extends StatefulWidget {
  const ListaSuppliers({super.key});

  @override
  State<ListaSuppliers> createState() => _ListaSuppliersState();
}

class _ListaSuppliersState extends State<ListaSuppliers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos los proveedores'),
      ),
      body: FutureBuilder<List<Widget>>(
        future: SupplierService.fetchSuppliers(), // Mostrar todos los artículos
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
    );
  }
} 