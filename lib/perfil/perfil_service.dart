import 'dart:convert';
import 'dart:io';



class PerfilService {
  static const String dUrl = "https://microtech.icu:5000";
  static String fetchUrl = "$dUrl/employees/getEmployee";

  static Future<List<dynamic>> fetchPerfil() async {
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
        return jsonData["employee"];
      } else {
        print("Failed to load perfil, status code: ${response.statusCode}");
        return [];
      }

    } catch (e) {
      print("ERROR WHILE SENDING/RECEIVING REQUEST: $e");
      return [];
    }
  }
}
