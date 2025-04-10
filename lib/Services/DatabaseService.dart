import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movieappprj/Models/Movie.dart';
import 'package:movieappprj/Models/User.dart';
import 'package:movieappprj/Utils/constants.dart';
import 'Global.dart';


class DatabaseService{

  static Future<List<dynamic>> getNowShowing() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqYWtlbW1hIiwiaWF0IjoxNzQ0MTA4MDA0LCJleHAiOjE3NDQxMTA1MDR9.TfIGvgBxEiy9PFfZqw05E-Dwaw2XI6O8bkP0oYSBoVo' 
    };

    final response = await http.get(Uri.parse('$baseUrl/movies/all'), headers: headers);
    
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body)['results'].map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load now showing movies');
    }
  }

  static Future<List<Map<String, dynamic>>> getPopular() async {
     final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqYWtlbW1hIiwiaWF0IjoxNzQ0MTAyNTA5LCJleHAiOjE3NDQxMDUwMDl9.S_q-2VhgXJpabcLMpheO3O14IqrlJ1dGPrYAy2ADjC8' 
    };

    final response = await http.get(Uri.parse('$baseUrl/movies/all'), headers: headers);
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body)['results'];
    } else {
      throw Exception('Failed to load popular movies');
    }
  }
}

