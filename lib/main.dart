import 'package:app/menu_principal/menu_principal.dart';
import 'package:app/perfil/perfil_page.dart';
import 'package:app/productos/all_products.dart'; // Add this line
import 'package:flutter/material.dart';
import 'escaneo_producto/home_page.dart';
import 'escaneo_producto/home_page_controller.dart';
import 'carro_compra/carrito_page.dart';
import 'pago_page.dart';
import 'carro_compra/carrito_servicio.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: "assets/.env"); // Load .env file
  } catch (e) {
    print('.env file not found');
  }

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

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final ProductoService productoService = Get.put(ProductoService());

  final List<Widget> _views = [
    MenuOpcionesHome(), // 0
    HomePage(), // 1
    CarritoPage(), // 2
    PagoPage(), // 3
    PerfilPage(), // 4

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _views,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF09184D),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(
                icon: Icon(Icons.qr_code), label: 'Escanear'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'Carrito'),
            BottomNavigationBarItem(
                icon: Icon(Icons.attach_money), label: 'Pago'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Perfil'),
          ],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
      ),
    );
  }
}
