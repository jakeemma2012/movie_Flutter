import 'dart:convert';

import 'package:http/http.dart' as http;

import 'Global.dart';

class UserService {
    static Future<Map<String, dynamic>> HandlerRegister(
        String username, 
        String name, 
        String email, 
        String password
    ) async {
        try {
            final response = await http.post(
                Uri.parse('$baseUrl/auth/register'),
                body: json.encode({
                    'username': username,
                    'name': name,
                    'email': email,
                    'password': password,
                }),
                headers: {
                    'Content-Type': 'application/json',
                },
            );

            final data = json.decode(response.body);
            return {
                'success': response.statusCode == 200,
                'message': data['message'] ?? 'Unknown error'
            };
        } catch (e) {
            return {
                'success': false,
                'message': e.toString()
            };
        }
    }


  static Future<Map<String, dynamic>> HandlerLogin(String email, String password) async {
    Map data = {"email": email, "password": password};
    var body = jsonEncode(data);
    var url = Uri.parse('$baseUrl/auth/login');
    try {
      http.Response response = await http.post(
        url,
        body: body,
        headers: headers,
      );
      return {
        'success': response.statusCode == 200,
        'message': response.body
      };
    } catch (e) {
      print(e);
      return {
        'success': false,
        'message': e.toString()
      };
    }
  }

}
