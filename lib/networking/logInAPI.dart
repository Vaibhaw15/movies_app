import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> loginUser({
  required String email,
  required String password,
}) async {
  final url = Uri.parse('https://admin.imboxo.com/api/login');

  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  final body = jsonEncode({
    'email': email,
    'password': password,
  });

  try {
    final response = await http.post(url, headers: headers, body: body);
    return response.statusCode;
  } catch (e) {
    return 'Login failed. Something went wrong.';
  }
}
