import 'package:flutter/material.dart';

class SuppliersCard extends StatelessWidget {
  final String id;
  final String name;
  final String lastname;
  final String phone;
  final String email;
  final String city;
  final String brand;

  const SuppliersCard({
    super.key,
    required this.id,
    required this.name,
    required this.lastname,
    required this.phone,
    required this.email,
    required this.city,
    required this.brand,
  });

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
        leading: const Icon(Icons.store, color: Color(0xFF7E57C2), size: 40),
        title: Text(
          '$name $lastname',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phone: $phone'),
            Text('Email: $email'),
            Text('City: $city'),
            Text('Brand: $brand'),
          ],
        ),
        trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30),
        onTap: () {
          // Acción al presionar la tarjeta
          print('Supplier selected: $name');
        },
      ),
    );
  }
}
