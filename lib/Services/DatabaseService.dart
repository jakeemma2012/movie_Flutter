import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movieappprj/Models/Movie.dart';
import 'package:movieappprj/Models/User.dart';
import 'package:movieappprj/Utils/constants.dart';
import 'Global.dart';

class DatabaseService {
  static String _prettyPrintJson(dynamic json) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  static Future<List<Movie>> getNowShowing() async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${User.getUser?.accessToken} ?? ""',
      };

      final response = await http.get(
        Uri.parse('$baseUrl/movies/all'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(_prettyPrintJson(jsonResponse));
        if (jsonResponse is List) {
          return jsonResponse.map((e) => Movie.fromJson(e)).toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception(
          'Failed to load now showing movies: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error in getNowShowing: $e');
      throw Exception('Failed to load now showing movies: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getPopular() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${User.getUser?.accessToken} ?? ""',
    };

    final response = await http.get(
      Uri.parse('$baseUrl/movies/all'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(
        response.body,
      )['results'].map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  static Future<List<Movie>> getAllMovie() async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${User.getUser?.accessToken} ?? ""',
      };

      final response = await http.get(
        Uri.parse('$baseUrl/movies/all'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(_prettyPrintJson(jsonResponse));
        if (jsonResponse is List) {
          return jsonResponse.map((e) => Movie.fromJson(e)).toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception(
          'Failed to load now showing movies: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error in getNowShowing: $e');
      throw Exception('Failed to load now showing movies: $e');
    }
  }

  static Future<void> addToFavorite(int movieId) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${User.getUser?.accessToken} ?? ""',
    };

    final response = await http.post(
      Uri.parse(
        '$baseUrl/movies/add_favorite?email=${User.getUser?.email}&movieId=$movieId',
      ),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('Movie added to favorites');
    } else {
      throw Exception('Failed to add movie to favorites');
    }
  }

  static Future<List<Movie>> getFavorite() async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${User.getUser?.accessToken} ?? ""',
      };

      final response = await http.get(
        Uri.parse('$baseUrl/movies/get_favorite?email=${User.getUser?.email}'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(_prettyPrintJson(jsonResponse));
        if (jsonResponse is List) {
          return jsonResponse.map((e) => Movie.fromJson(e)).toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception(
          'Failed to load now showing movies: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error in getNowShowing: $e');
      throw Exception('Failed to load now showing movies: $e');
    }
  }

  static Future<void> removeFromFavorite(int movieId) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${User.getUser?.accessToken} ?? ""',
    };

    final response = await http.delete(
      Uri.parse(
        '$baseUrl/movies/delete_favorite?email=${User.getUser?.email}&movieId=$movieId',
      ),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('Movie removed from favorites');
    } else {
      throw Exception('Failed to remove movie from favorites');
    }
  }
}
