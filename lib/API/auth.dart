import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:salon_app/API/Endpoint/endpoint.dart';
import 'package:salon_app/Model/get_user_model.dart';
import 'package:salon_app/Model/login_model.dart';
import 'package:salon_app/Model/register_model.dart';
import 'package:salon_app/Share_Preferences/share_preferences.dart';



class AuthenticationAPI {
  static Future<RegisterModel> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    final url = Uri.parse(Endpoint.register);
    final response = await http.post(
      url,
      body: {"name": name, "email": email, "password": password},
      headers: {"Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      return RegisterModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Register gagal");
    }
  }

  static Future<LoginModel> loginUser({
    required String email,
    required String password,
    String? token
  }) async {
    final url = Uri.parse(Endpoint.login);
    final response = await http.post(
      url,
      body: {"email": email, "password": password},
      headers: {"Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      PreferenceHandler.saveToken(token ?? "");
      return LoginModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Register gagal");
    }
  }
}
