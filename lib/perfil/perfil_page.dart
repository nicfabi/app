import 'package:app/perfil/perfil_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PerfilPage> {

  final PerfilService perfilService = Get.put(PerfilService());
  List<dynamic> perfil = [];

    @override
  void initState() {
    loadPerfil(); 
    super.initState(); 
  }

  Future<void> loadPerfil() async {
    try {
      List<dynamic> fetchedPerfil = await PerfilService.fetchPerfil();
      setState(() {
        perfil = fetchedPerfil;
      });
    } catch (e) {
      print("Error al cargar el perfil: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil Empleado', style: TextStyle(color: Color(0xFFFAFAFA))),
        backgroundColor: const Color(0xFF09184D),
        centerTitle: true,
      ),
      body:  Center(child: Padding ( 
        padding: const EdgeInsets.all(30),
        child: Column(
        children: [
          ClipOval(
            child: Image.network('https://watermark.lovepik.com/photo/20211210/large/lovepik-man-clerk-holding-a-menu-smiling-picture_501790475.jpg', 
            width: 200, 
            height: 200, 
            fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),
          perfil.isNotEmpty
                ? Column (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children : [
                  Text('${perfil[0]['NAME']} ${perfil[0]['LASTNAME']}',
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  const Text('Teléfono', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 112, 122, 161)),),
                  Text('${perfil[0]['PHONE']}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 15),

                  const Text('Correo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 112, 122, 161)),),
                  Text('${perfil[0]['EMAIL']}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 15),

                  const Text('Dirección', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 112, 122, 161)),),
                  Text('${perfil[0]['ADDRESS']}', style: const TextStyle(fontSize: 18)),
                ])
                : const CircularProgressIndicator(),
        ],
      ),
      )
    )
    );
  }
}