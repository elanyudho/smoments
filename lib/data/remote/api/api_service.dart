import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:smoments/data/remote/response/default_response.dart';
import 'package:smoments/data/remote/response/detail_story_response.dart';
import 'package:smoments/data/remote/response/login_response.dart';
import 'package:smoments/data/remote/response/stories_response.dart';

import '../response/error_response.dart';

class ApiService{
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';
  static const String _register = '/register';
  static const String _login = '/login';
  static const String _stories = '/stories';

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
      throw Exception("Network is unreachable");
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

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("Network is unreachable");
    }
  }

  Future<StoriesResponse> getStories(String page, String token) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(Uri.parse('$_baseUrl$_stories?page=$page&size=10'), headers: headers);
    if (response.statusCode == 200) {
      return StoriesResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("Network is unreachable");
    }
  }

  Future<DetailStoryResponse> getDetailStory(String id, String token) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(Uri.parse('$_baseUrl$_stories/$id'), headers: headers);

    if (response.statusCode == 200) {
      return DetailStoryResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("Network is unreachable");
    }
  }

  Future<DefaultResponse> postStory(String description, List<int> photo, String fileName, String token) async {
    final Map<String, String> fields = {
      "description": description,
    };

    final MultipartFile multiPartFile = http.MultipartFile.fromBytes(
      "photo",
      photo,
      filename: fileName,
    );

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token'
    };

    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl$_stories'));
    request.fields.addAll(fields);
    request.files.add(multiPartFile);
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;
    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (statusCode == 200 || statusCode == 201) {
      return DefaultResponse.fromJson(json.decode(responseData));
    } else {
      throw "Failed to post story. Status code: $statusCode";
    }
  }
}