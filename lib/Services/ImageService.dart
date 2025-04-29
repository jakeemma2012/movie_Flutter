import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movieappprj/Services/Global.dart';
import 'package:movieappprj/Models/User.dart';

class ImageService {
  static Future<String> getAssets(String imagePath, String type) async {
    try {
      // First, get the CDN URL from Spring Boot
      final response = await http
          .get(
            Uri.parse(
              '$baseUrl/assets/get_assets?linkAssets=$imagePath&nameTag=$type',
            ),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${User.getUser?.accessToken ?? ""}',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Request timed out');
            },
          );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final cdnUrl = jsonResponse['url'] as String?;

        if (cdnUrl != null) {
          // print('Got CDN URL from Spring Boot: $cdnUrl');
          return cdnUrl;
        }
      }

      throw Exception(
        'Failed to get CDN URL: ${response.statusCode} - ${response.body}',
      );
    } catch (e) {
      print('Error getting image URL: $e');
      throw Exception('Failed to get image URL: $e');
    }
  }

  static Future<String> getTrailer(String imagePath, String type) async {
    try {
      // First, get the CDN URL from Spring Boot
      final response = await http
          .get(
            Uri.parse(
              '$baseUrl/assets/get_trailer?linkAssets=$imagePath&nameTag=$type',
            ),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${User.getUser?.accessToken ?? ""}',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Request timed out');
            },
          );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final cdnUrl = jsonResponse['url'] as String?;

        if (cdnUrl != null) {
          // print('Got CDN URL from Spring Boot: $cdnUrl');
          return cdnUrl;
        }
      }

      throw Exception(
        'Failed to get CDN URL: ${response.statusCode} - ${response.body}',
      );
    } catch (e) {
      print('Error getting image URL: $e');
      throw Exception('Failed to get image URL: $e');
    }
  }

  static Future<String> getCast(String linkCast, String nameMovie) async {
    try {
      // First, get the CDN URL from Spring Boot
      // print('$baseUrl/assets/get_cast?linkCast=$linkCast&nameMovie=$nameMovie');
      final response = await http
          .get(
            Uri.parse(
              '$baseUrl/assets/get_cast?linkCast=$linkCast&nameMovie=$nameMovie',
            ),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${User.getUser?.accessToken ?? ""}',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Request timed out');
            },
          );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final cdnUrl = jsonResponse['url'] as String?;

        if (cdnUrl != null) {
          // print('Got CDN URL from Spring Boot: $cdnUrl');
          return cdnUrl;
        }
      }

      throw Exception(
        'Failed to get CDN URL: ${response.statusCode} - ${response.body}',
      );
    } catch (e) {
      print('Error getting image URL: $e');
      throw Exception('Failed to get image URL: $e');
    }
  }
}
