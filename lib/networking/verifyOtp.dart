import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> verifyEmailOtp({
  required String email,
  required String otp,
}) async {
  final url = Uri.parse('https://admin.imboxo.com/api/email-verify');

  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  final body = jsonEncode({
    'email': email,
    'otp': otp,
  });

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  } catch (e) {
    return 'Something went wrong during OTP verification.';
  }
}
