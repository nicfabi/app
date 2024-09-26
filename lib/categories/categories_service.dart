import 'dart:convert';
import 'dart:io';
import 'package:app/categories/categories_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CategoriesService {
  static final String dUrl = dotenv.env['URL'] ?? "https://microtech.icu:5000";
  static String fetchUrl = "$dUrl/categories/all";
  static String addUrl = "$dUrl/categories/add";

  // Function to fetch categories (already implemented)
  static Future<List<Widget>> fetchCategories(
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
        List items = jsonData["categories"];
        List<Widget> categoryWidgets = [];

        for (var item in items) {
          categoryWidgets.add(CategoriesCard(
            id: item["ID"].toString(),
            name: item['NAME'].toString(),
            description: item["DESCRIPTION"].toString(),
            onDelete: () {
              onDelete();
            }, // Pass a callback function to handle deletion
          ));
        }

        return categoryWidgets;
      } else {
        print("Failed to load categories, status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
      return [];
    }
  }

  // Function to add a new category
  static Future<void> addCategory(Map<String, String> categoryData) async {
    try {
      print(categoryData);
      print("Sending request to add category at: $addUrl");
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      // Build the request to add the category endpoint
      HttpClientRequest request = await client.postUrl(Uri.parse(addUrl));
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');

      // Convert categoryData to JSON and send the request
      request.add(utf8.encode(jsonEncode(categoryData)));

      // Await the response
      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        String responseBody = await response.transform(utf8.decoder).join();
        print("Category added successfully: $responseBody");
      } else {
        print("Failed to add category, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
    }
  }

  static Future<void> deleteCategory(BuildContext context, String id) async {
    final url = '$dUrl/categories/delete/$id';
    try {
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      HttpClientRequest request = await client.deleteUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'application/json');

      HttpClientResponse response = await request.close();
      print(response);

      if (response.statusCode == 200) {
        print("Category deleted successfully.");
      } else {
        print("Failed to delete category, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
    }
  }

  static Future<List<Widget>> loadCategories(
      {required Function onDelete}) async {
    return await fetchCategories(onDelete: onDelete);
  }

  static Future<void> updateCategory(
      Map<String, String> categoryData, String id) async {
    final url = '$dUrl/categories/update/$id';

    try {
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'application/json');

      request.add(utf8.encode(jsonEncode(categoryData)));

      HttpClientResponse response = await request.close();
      print(response);

      if (response.statusCode == 200) {
        print("Category updated successfully.");
      } else {
        print("Failed to update category, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
    }
  }
}
