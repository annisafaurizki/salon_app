import 'dart:convert';

import 'package:app_salon_projek/API/Endpoint/endpoint.dart';
import 'package:app_salon_projek/Model/add_layanan_model.dart';
import 'package:app_salon_projek/Model/get_layanan_model.dart';
import 'package:app_salon_projek/Share_Preferences/share_preferences.dart';
import 'package:http/http.dart' as http;

class AuthenticationAPIServices {
  static Future<AddLayananModel> addServices({
    required String name,
    required String description,
    required int price,
    required String employeeName,
    required String employeePhoto,   // base64 string
    required String servicePhoto,    // base64 string
  }) async {
    final url = Uri.parse(Endpoint.services);
    final token = await PreferenceHandler.getToken();

    
    print("➡️ POST body: ${{
      "name": name,
      "description": description,
      "price": price,
      "employee_name": employeeName,
      "employee_photo": employeePhoto,
      "service_photo": servicePhoto,
    }}");

    final response = await http.post(
      url,
      body: jsonEncode({
        "name": name,
        "description": description,
        "price": price,
        "employee_name": employeeName,
        "employee_photo": employeePhoto,
        "service_photo": servicePhoto,
      }),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return AddLayananModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal menambahkan layanan");
    }
  }


  static Future<GetLayanan> getService() async {
    final url = Uri.parse(Endpoint.services);
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return GetLayanan.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal mengambil data layanan");
    }
  }
}
