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

  static Future<Map<String, List<String>>> getCastList(String movieName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/assets/get_cast_list?nameMovie=$movieName'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${User.getUser?.accessToken ?? ""}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final Map<String, dynamic> data =
            jsonResponse['data'] as Map<String, dynamic>;

        final List<dynamic> castFiles = data['castData'] as List<dynamic>;
        final List<dynamic> castNames = data['castName'] as List<dynamic>;

        print(castFiles);
        print(castNames);

        return {
          'castFiles':
              castFiles.map((fileName) => fileName.toString()).toList(),
          'castNames': castNames.map((name) => name.toString()).toList(),
        };
      }

      throw Exception(
        'Failed to get cast list: ${response.statusCode} - ${response.body}',
      );
    } catch (e) {
      print('Error getting cast list: $e');
      throw Exception('Failed to get cast list: $e');
    }
  }

  static Future<String> getCast(String linkCast, String nameMovie) async {
    try {
      // First, get the CDN URL from Spring Boot
      print('$baseUrl/assets/get_cast?linkCast=$linkCast&nameMovie=$nameMovie');
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
