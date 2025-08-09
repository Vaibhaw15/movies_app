import 'dart:convert';
import 'package:http/http.dart' as http;
class SignUpService {
 static Future<dynamic> signUpUser({
    required String name,
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    final url = Uri.parse('https://admin.imboxo.com/api/signup');

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body = jsonEncode({
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'role': role,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.statusCode;
      } else if(response.statusCode == 422){
        return response.statusCode;
      }else {
        return response.statusCode;
      }
    } catch (e) {
      return 'Something went wrong. Please try again.';
    }
  }
}