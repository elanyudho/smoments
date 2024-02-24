import 'dart:convert';

import 'package:smoments/data/remote/response/default_response.dart';
import 'package:http/http.dart' as http;
import 'package:smoments/data/remote/response/login_response.dart';

import '../response/error_response.dart';

class ApiService{
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';
  static const String _register = '/register';
  static const String _login = '/login';

  Future<DefaultResponse> postRegister(String name, String email, String password) async {
    Map<String, dynamic> requestBody = {
      'name': name,
      'email': email,
      'password': password,
    };

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      Uri.parse(_baseUrl + _register),
      headers: headers,
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 201) {
      return DefaultResponse.fromJson(json.decode(response.body));
    } else {
      final ErrorResponse errorResponse = parseErrorResponse(response.body);
      throw (errorResponse.message);
    }
  }

  Future<LoginResponse> postLogin(String email, String password) async {
    Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
    };

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.post(Uri.parse(_baseUrl + _login), headers: headers, body: jsonEncode(requestBody));

    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      final ErrorResponse errorResponse = parseErrorResponse(response.body);
      throw (errorResponse.message);
    }
  }
}