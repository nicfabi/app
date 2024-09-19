import 'package:app/menu_principal/productos_page.dart';
import 'package:app/menu_principal/ver_productos.dart';
import 'package:flutter/material.dart';
import 'escaneo_producto/home_page.dart';
import 'escaneo_producto/home_page_controller.dart';
import 'carro_compra/carrito_page.dart';
import 'pago_page.dart';
import 'carro_compra/carrito_servicio.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(CarritoService());
  Get.put(HomePageController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Facturación Electrónica',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFFAFAFA),
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  final RxInt _selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: _selectedIndex.value,
            children: [
              MenuOpcionesHome(),   // 0
              HomePage(),           // 1
              CarritoPage(),        // 2
              PagoPage(),           // 3
              VerProductosPage(),      // 4
            ],
          )),
      bottomNavigationBar: Obx(() => CustomBottomNavBar(
            selectedIndex: _selectedIndex.value,
            onItemTapped: (index) => _selectedIndex.value = index,
          )),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF09184D),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'Escanear'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Carrito'),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: 'Pago'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: onItemTapped,
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
