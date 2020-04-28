import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:web_consumer_auth/models/user_model.dart';

const String baseUrl = 'https://movil-api.herokuapp.com';

// Login Request
Future<User> login(String email, String password) async {
  final http.Response response = await http.post(
    baseUrl + '/signin',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> body = json.decode(response.body);
    return User.fromJson(json.decode(response.body));
  } else if (response.statusCode == 401) {
    Map<String, dynamic> body = json.decode(response.body)[0];
    throw Exception(body['message']);
  } else {
    throw Exception('Failed to login User');
  }
}

// SignUp request
Future<User> signUp(
    String email, String password, String username, String name) async {
  final http.Response response = await http.post(
    baseUrl + '/signup',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
      'username': email,
      'name': name,
    }),
  );
  if (response.statusCode == 200) {
    return User.fromJson(json.decode(response.body));
  } else if (response.statusCode == 409) {
    throw Exception(response.body);
  } else {
    throw Exception('Failed to register user');
  }
}

// Check token request
Future<bool> checkToken(String token) async {
  final http.Response response = await http.post(
    baseUrl + '/check/token',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Bearer " + token,
    },
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> body = json.decode(response.body);
    bool isValid = body['valid'];
    return isValid;
  } else {
    throw Exception('Failed to register user');
  }
}
