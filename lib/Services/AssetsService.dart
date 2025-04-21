import 'package:http/http.dart' as http;
import 'package:movieappprj/Services/Global.dart';
import 'package:movieappprj/Models/User.dart';

class Assetsservice {
  static Future<String> getImageUrl(String imagePath) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/assets?linkAssets=$imagePath'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${User.getUser?.accessToken ?? ""}',
        },
      );

      if (response.statusCode == 302 || response.statusCode == 200) {
        // Lấy URL từ header Location
        final location = response.headers['location'];
        if (location != null) {
          return location;
        }
      }
      throw Exception('Failed to get image URL: ${response.statusCode}');
    } catch (e) {
      print('Error getting image URL: $e');
      throw Exception('Failed to get image URL: $e');
    }
  }
}
