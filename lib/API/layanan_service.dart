import 'dart:convert';
import 'dart:io';

import 'package:app_salon_projek/API/Endpoint/endpoint.dart';
import 'package:app_salon_projek/Share_Preferences/share_preferences.dart';
import 'package:app_salon_projek/model/layanan/add_layanan_model.dart';
import 'package:app_salon_projek/model/layanan/get_layanan_model.dart';
import 'package:http/http.dart' as http;

class AuthenticationAPIServices {
  static Future<AddLayananModel> addServices({
    required String name,
    required String description,
    required String price,
    required String employeeName,
    required File employeePhoto, // base64 string
    required File servicePhoto, // base64 string
  }) async {
    final url = Uri.parse(Endpoint.services);
    final token = await PreferenceHandler.getToken();

    final employee = employeePhoto.readAsBytesSync();
    final service = servicePhoto.readAsBytesSync();
    final employeeb64 = base64Encode(employee);
    final serviceb64 = base64Encode(service);
    print(
      "➡️ POST body: ${{"name": name, "description": description, "price": price, "employee_name": employeeName, "employee_photo": employeeb64, "service_photo": serviceb64}}",
    );

    final response = await http.post(
      url,
      body: {
        "name": name,
        "description": description,
        "price": price,
        "employee_name": employeeName,
        "employee_photo": employeeb64,
        "service_photo": serviceb64,
      },
      headers: {
        "Accept": "application/json",
        // "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return AddLayananModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal menambahkan layanan");
    }
  }

  static Future<AddLayananModel> updateServices({
    required String name,
    required int id,
    required String description,
    required String price,
    required String employeeName,
    required File employeePhoto, // base64 string
    required File servicePhoto, // base64 string
  }) async {
    final url = Uri.parse("${Endpoint.services}/$id");
    final token = await PreferenceHandler.getToken();

    final employee = employeePhoto.readAsBytesSync();
    final service = servicePhoto.readAsBytesSync();
    final employeeb64 = base64Encode(employee);
    final serviceb64 = base64Encode(service);
    print(
      "➡️ POST body: ${{"name": name, "description": description, "price": price, "employee_name": employeeName, "employee_photo": employeeb64, "service_photo": serviceb64}}",
    );

    final response = await http.put(
      url,
      body: {
        "name": name,
        "description": description,
        "price": price,
        "employee_name": employeeName,
        "employee_photo": employeeb64,
        "service_photo": serviceb64,
      },
      headers: {
        "Accept": "application/json",
        // "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print(response.body);
    print(response.statusCode);
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
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return GetLayanan.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal mengambil data layanan");
    }
  }

  static Future<bool> deleteService(int id) async {
    final url = Uri.parse("${Endpoint.services}/$id");
    final token = await PreferenceHandler.getToken();

    final response = await http.delete(
      url,
      headers: {
        "Accept": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      // delete berhasil
      return true;
    } else {
      // kalau ada error, coba ambil pesan
      try {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Gagal menghapus layanan");
      } catch (e) {
        throw Exception(
          "Gagal menghapus layanan (status ${response.statusCode})",
        );
      }
    }
  }
}
