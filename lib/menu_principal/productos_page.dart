import 'package:app/carro_compra/carrito_page.dart';
import 'package:app/menu_principal/ver_productos.dart';
import 'package:flutter/material.dart';

class MenuOpcionesHome extends StatelessWidget {
  const MenuOpcionesHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Principal',
            style: TextStyle(color: Color(0xFFFAFAFA))),
        backgroundColor: const Color(0xFF7E57C2),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerProductosPage(),
                  ),
                );
              },
              child: SizedBox(
                width: 300,
                height: 80,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.menu, size: 25, color: Colors.purple),
                        SizedBox(width: 16),
                        Text(
                          'Ver Productos',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 3),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarritoPage(),
                  ),
                );
              },
              child: SizedBox(
                width: 300,
                height: 80,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.add_box, size: 25, color: Colors.purple),
                        SizedBox(width: 16),
                        Text(
                          'Agregar Productos',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 3),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarritoPage(),
                  ),
                );
              },
              child: SizedBox(
                width: 300,
                height: 80,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.edit, size: 25, color: Colors.purple),
                        SizedBox(width: 16),
                        Text(
                          'Editar Productos',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 3),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarritoPage(),
                  ),
                );
              },
              child: SizedBox(
                width: 300,
                height: 80,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.delete, size: 25, color: Colors.purple),
                        SizedBox(width: 16),
                        Text(
                          'Eliminar Productos',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 3),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarritoPage(),
                  ),
                );
              },
              child: SizedBox(
                width: 300,
                height: 80,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.edit, size: 25, color: Colors.purple),
                        Icon(Icons.person, size: 25, color: Colors.purple),
                        SizedBox(width: 16),
                        Text(
                          'Editar Proveedores',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
