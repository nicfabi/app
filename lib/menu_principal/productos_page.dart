import 'package:app/carro_compra/carrito_page.dart';
import 'package:app/menu_principal/ver_productos.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class MenuOpcionesHome extends StatelessWidget {
  final RxInt selectedIndexValue;
  const MenuOpcionesHome({super.key, required RxInt selectedIndex, required this.selectedIndexValue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Principal',
            style: TextStyle(color: Color(0xFFFAFAFA))),
        backgroundColor: const Color(0xFF09184D),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                selectedIndexValue.value = 4;
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
                        Icon(Icons.menu, size: 25, color: Color(0xFF09184D)),
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
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                selectedIndexValue.value = 4;
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
                        Icon(Icons.add_box, size: 25, color: Color(0xFF09184D)),
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
            const SizedBox(height: 16),
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
                        Icon(Icons.edit, size: 25, color: Color(0xFF09184D)),
                        Icon(Icons.person, size: 25, color: Color(0xFF09184D)),
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
