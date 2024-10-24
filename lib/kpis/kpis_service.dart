import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class KpisService {
  static final String dUrl = dotenv.env['URL'] ?? "https://microtech.icu:5000";
  static String fetchDataUrl = "$dUrl/kpis/data";
  static String fetchKpisUrl = "$dUrl/kpis";

  // Function to fetch sold amount
  static Future<List<Map<String, String>>> fetchSoldAmount(
      String iDate, String fDate) async {
    try {
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      HttpClientRequest request =
          await client.postUrl(Uri.parse("$fetchDataUrl/sold-amount"));
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');

      request.add(utf8.encode(jsonEncode({
        'iDate': iDate,
        'fDate': fDate,
      })));

      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        String jsonString = await response.transform(utf8.decoder).join();
        dynamic jsonData = jsonDecode(jsonString);
        List items = jsonData["soldAmount"];
        List<Map<String, String>> soldAmount = [];

        for (var item in items) {
          soldAmount.add({
            "date": item["date"].toString(),
            "total": item["total"].toString(),
          });
        }

        return soldAmount;
      } else {
        print(
            "Failed to load sold amount, status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
      return [];
    }
  }

  // Function to fetch top customers
  static Future<List<Map<String, String>>> fetchTopCustomers() async {
    try {
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      HttpClientRequest request =
          await client.getUrl(Uri.parse("$fetchDataUrl/top-customers"));
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');

      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        String jsonString = await response.transform(utf8.decoder).join();
        dynamic jsonData = jsonDecode(jsonString);
        List items = jsonData["customers"];
        List<Map<String, String>> customers = [];

        for (var item in items) {
          customers.add({
            "names": item["names"].toString(),
            "total": item["total"].toString(),
          });
        }

        return customers;
      } else {
        print(
            "Failed to load top customers, status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
      return [];
    }
  }

  // Function to fetch top products
  static Future<List<Map<String, String>>> fetchTopProducts(bool most) async {
    try {
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      String url = most
          ? "$fetchDataUrl/top-products/most"
          : "$fetchDataUrl/top-products/least";

      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');

      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        String jsonString = await response.transform(utf8.decoder).join();
        dynamic jsonData = jsonDecode(jsonString);
        List items = jsonData["products"];
        List<Map<String, String>> topProducts = [];

        for (var item in items) {
          topProducts.add({
            "name": item["name"].toString(),
            "quantity": item["quantity"].toString(),
          });
        }

        return topProducts;
      } else {
        print(
            "Failed to load top products, status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
      return [];
    }
  }

  // Function to fetch products by date
  static Future<List<Map<String, String>>> fetchProductsByDate(
      String iDate, String fDate) async {
    try {
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      HttpClientRequest request =
          await client.postUrl(Uri.parse("$fetchDataUrl/products-by-date"));
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');
      request.add(
        utf8.encode(
          jsonEncode({
            'iDate': iDate,
            'fDate': fDate,
          }),
        ),
      );

      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        String jsonString = await response.transform(utf8.decoder).join();
        dynamic jsonData = jsonDecode(jsonString);
        List items = jsonData["products"];
        List<Map<String, String>> products = [];

        for (var item in items) {
          products.add({
            "name": item["name"].toString(),
            "quantity": item["quantity"].toString(),
          });
        }

        return products;
      } else {
        print(
            "Failed to load products by date, status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
      return [];
    }
  }

  // Function to fetch sales growth kpi
  static Future<double> fetchSalesGrowth(String iDate, String fDate) async {
    try {
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      HttpClientRequest request =
          await client.postUrl(Uri.parse("$fetchKpisUrl/sales-growth"));
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');
      request.add(
        utf8.encode(
          jsonEncode({
            'iDate': iDate,
            'fDate': fDate,
          }),
        ),
      );

      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        String jsonString = await response.transform(utf8.decoder).join();
        dynamic jsonData = jsonDecode(jsonString);
        double salesGrowth = double.parse(jsonData["salesGrowth"].toString());
        return salesGrowth;
      } else {
        print(
            "Failed to load sales growth, status code: ${response.statusCode}");
        return 0.0;
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
      return 0.0;
    }
  }

  // Function to fetch average transaction size kpi
  static Future<double> fetchAvgTransactionSize() async {
    try {
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      HttpClientRequest request =
          await client.getUrl(Uri.parse("$fetchKpisUrl/avg-transaction-size"));
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');

      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        String jsonString = await response.transform(utf8.decoder).join();
        dynamic jsonData = jsonDecode(jsonString);
        double avgTransSize =
            double.parse(jsonData["avgTransactionSize"].toString());
        return avgTransSize;
      } else {
        print("Failed to load ATS, status code: ${response.statusCode}");
        return 0.0;
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
      return 0.0;
    }
  }

  // Function to fetch top categories
  static Future<List<Map<String, String>>> fetchTopCategories() async {
    try {
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      HttpClientRequest request =
          await client.getUrl(Uri.parse("$fetchDataUrl/top-categories"));
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');

      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        String jsonString = await response.transform(utf8.decoder).join();
        dynamic jsonData = jsonDecode(jsonString);
        List items = jsonData["categories"];
        List<Map<String, String>> categories = [];

        for (var item in items) {
          categories.add({
            "name": item["name"].toString(),
            "percentage": item["quantity"].toString(),
          });
        }

        return categories;
      } else {
        print(
            "Failed to load top categories, status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
      return [];
    }
  }

  // Function to fetch repeat purchase rate kpi
  static Future<double> fetchRepeatPurchaseRate() async {
    try {
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      HttpClientRequest request =
          await client.getUrl(Uri.parse("$fetchKpisUrl/rpr"));
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');

      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        String jsonString = await response.transform(utf8.decoder).join();
        dynamic jsonData = jsonDecode(jsonString);
        double rpr = double.parse(jsonData["rpr"].toString());
        return rpr;
      } else {
        print("Failed to load RPR, status code: ${response.statusCode}");
        return 0.0;
      }
    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
      return 0.0;
    }
  }
}
