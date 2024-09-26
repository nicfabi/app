import 'dart:convert';
import 'dart:io';
import 'package:app/suppliers/suppliersCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupplierService {
  static String dUrl = dotenv.env['URL']!;
  static String fetchUrl = "$dUrl/suppliers/all";
  static String addUrl = "$dUrl/suppliers/add";

  // Function to fetch suppliers (already implemented)
  static Future<List<Widget>> fetchSuppliers(
      {required Function onDelete}) async {
    try {
      print("Sending request to: $fetchUrl");
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      HttpClientRequest request = await client.getUrl(Uri.parse(fetchUrl));
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
            onDelete: () {
              onDelete();
            }, // Pass a callback function to handle deletion
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

  // Function to add a new supplier
  static Future<void> addSupplier(Map<String, String> supplierData) async {
    try {
      print(supplierData);
      print("Sending request to add supplier at: $addUrl");
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      // Build the request for the add supplier endpoint
      HttpClientRequest request = await client.postUrl(Uri.parse(addUrl));
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');

      // Convert supplierData to JSON and send the request
      request.add(utf8.encode(jsonEncode(supplierData)));

      // Await the response
      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        String responseBody = await response.transform(utf8.decoder).join();
        print("Supplier added successfully: $responseBody");
      } else {
        print("Failed to add supplier, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
    }
  }

  static Future<void> deleteSupplier(BuildContext context, String id) async {
    final url = '$dUrl/suppliers/delete/$id';
    try {
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      HttpClientRequest request = await client.deleteUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'application/json');

      HttpClientResponse response = await request.close();
      print(response);

      if (response.statusCode == 200) {
        print("Supplier deleted successfully.");
      } else {
        print("Failed to delete supplier, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
    }
  }

  static Future<List<Widget>> loadSuppliers(
      {required Function onDelete}) async {
    return await fetchSuppliers(
      onDelete: onDelete,
    );
  }

  static Future<void> updateSupplier(
      Map<String, String> supplierData, String id) async {
    final url = '$dUrl/suppliers/update/$id';
    //final url = 'http://192.168.0.13:3000/suppliers/update/$id';
    try {
      print(url);
      print(supplierData);
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'application/json');

      request.add(utf8.encode(jsonEncode(supplierData)));

      HttpClientResponse response = await request.close();
      print(response);

      if (response.statusCode == 200) {
        print("Supplier updated successfully.");
      } else {
        print("Failed to update supplier, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
    }
  }
}
