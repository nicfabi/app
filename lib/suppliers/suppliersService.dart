import 'dart:convert';
import 'dart:io';
import 'package:app/suppliers/suppliersCard.dart';
import 'package:flutter/material.dart';

class SupplierService {
  static const String sUrl = "https://microtech.icu:5000/suppliers/all";

  static Future<List<Widget>> fetchSuppliers() async {
    try {
      print("Sending request to: $sUrl");
      HttpClient client = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

      HttpClientRequest request = await client.getUrl(Uri.parse(sUrl));
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');
      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        String jsonString = await response.transform(utf8.decoder).join();
        dynamic jsonData = jsonDecode(jsonString);
        List items = jsonData["suppliers"];
        List<Widget> supplierWidgets = [];

        for (var item in items) {
          supplierWidgets.add(SuppliersCard(
            id: item["ID"].toString(),
            name: item['NAME'].toString(),
            phone: item["PHONE"].toString(),
            email: item["EMAIL"].toString(),
            city: item["CITY"].toString(),
            brand: item["BRAND"].toString(),
            lastname: item["LASTNAME"].toString(),
          ));
        }

        return supplierWidgets;
      } else {
        print("Failed to load suppliers, status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
      return [];
    }
  }
}
