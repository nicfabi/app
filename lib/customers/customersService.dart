import 'dart:convert';
import 'dart:io';
import 'package:app/customers/customersCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CustomersService {
  static String dUrl = dotenv.env['URL']!;
  static String fetchUrl = "$dUrl/customers/all";
  static String addUrl = "$dUrl/customers/add";

  // Function to fetch customers
  static Future<List<Widget>> fetchCustomers({required Function onDelete}) async {
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
        List items = jsonData["customers"];
        List<Widget> customerWidgets = [];

        for (var item in items) {
          customerWidgets.add(CustomersCard(
            id: item["ID"].toString(),
            name: item['NAME'].toString(),
            phone: item["PHONE"].toString(),
            email: item["EMAIL"].toString(),
            lastname: item["LASTNAME"].toString(),
            billVia: item["BILL_VIA"].toString(),
            onDelete: () {
              onDelete();
            },
          ));
        }

        return customerWidgets;
      } else {
        print("Failed to load customers, status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
      return [];
    }
  }

  // Function to add a new customer
  static Future<void> addCustomer(Map<String, String> customerData) async {
    try {
      print(customerData);
      print("Sending request to add customer at: $addUrl");
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      HttpClientRequest request = await client.postUrl(Uri.parse(addUrl));
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');

      request.add(utf8.encode(jsonEncode(customerData)));

      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        String responseBody = await response.transform(utf8.decoder).join();
        print("Customer added successfully: $responseBody");
      } else {
        print("Failed to add customer, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
    }
  }

  static Future<void> deleteCustomer(BuildContext context, String id) async {
    final url = '$dUrl/customers/delete/$id';
    try {
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      HttpClientRequest request = await client.deleteUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'application/json');

      HttpClientResponse response = await request.close();
      print(response);

      if (response.statusCode == 200) {
        print("Customer deleted successfully.");
      } else {
        print("Failed to delete customer, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
    }
  }

  static Future<List<Widget>> loadCustomers({required Function onDelete}) async {
    return await fetchCustomers(onDelete: onDelete);
  }

  static Future<void> updateCustomer(Map<String, String> customerData, String id) async {
    print("HOLA GAYS: $id");
    final url = '$dUrl/customers/update/$id';
    try {
      print("Sending request to update customer at: $url");
      print(customerData);
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      HttpClientRequest request = await client.putUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'application/json');

      request.add(utf8.encode(jsonEncode(customerData)));

      HttpClientResponse response = await request.close();
      print(response);

      if (response.statusCode == 200) {
        print("Customer updated successfully.");
      } else {
        print("Failed to update customer, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
    }
  }
}
