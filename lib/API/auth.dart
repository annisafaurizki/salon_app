import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_salon_projek/API/Endpoint/endpoint.dart';

import 'package:app_salon_projek/Model/login_model.dart';
import 'package:app_salon_projek/Model/register_model.dart';
import 'package:app_salon_projek/Share_Preferences/share_preferences.dart';

class AuthenticationAPI {
  // Helper: ambil token dari berbagai bentuk response
  static String? _extractToken(Map<String, dynamic> m) {
    // Langsung di root
    if (m['token'] is String && (m['token'] as String).isNotEmpty) {
      return m['token'] as String;
    }
    if (m['access_token'] is String && (m['access_token'] as String).isNotEmpty) {
      return m['access_token'] as String;
    }

    // Di dalam "data"
    if (m['data'] is Map<String, dynamic>) {
      final d = m['data'] as Map<String, dynamic>;
      if (d['token'] is String && (d['token'] as String).isNotEmpty) {
        return d['token'] as String;
      }
      if (d['access_token'] is String && (d['access_token'] as String).isNotEmpty) {
        return d['access_token'] as String;
      }
    }
    return null;
  }

  static Future<RegisterModel> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    final url = Uri.parse(Endpoint.register);
    final res = await http.post(
      url,
      // server kamu sebelumnya pakai form-urlencoded, jadi kita deklarasi jelas
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {"name": name, "email": email, "password": password},
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return RegisterModel.fromJson(json.decode(res.body));
    } else {
      try {
        final err = json.decode(res.body);
        throw Exception(err["message"] ?? "Register gagal (HTTP ${res.statusCode})");
      } catch (_) {
        throw Exception("Register gagal (HTTP ${res.statusCode}): ${res.body}");
      }
    }
  }

  static Future<LoginModel> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(Endpoint.login);
    final res = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {"email": email, "password": password},
    );

    // Log ringan supaya mudah debug di console
    // print("🔐 [LOGIN] ${res.statusCode}");
    // print("🔐 Body: ${res.body}");

    if (res.statusCode == 200 || res.statusCode == 201) {
      // 1) parse JSON mentah dulu untuk ambil token
      final map = json.decode(res.body) as Map<String, dynamic>;
      final token = _extractToken(map);

      if (token == null || token.trim().isEmpty) {
        // kalau modelmu punya data.data.token kamu bisa tetap parse dan cek juga di sini
        // tapi agar robust, kita error kalau tidak ketemu di JSON
        throw Exception("Login berhasil tapi token tidak ditemukan di response.");
      }

      // 2) simpan token + flag login
      await PreferenceHandler.saveToken(token);
      await PreferenceHandler.saveLogin();

      // 3) tetap kembalikan model agar kompatibel dengan kode lain
      return LoginModel.fromJson(map);
    } else {
      try {
        final err = json.decode(res.body);
        throw Exception(err["message"] ?? "Login gagal (HTTP ${res.statusCode})");
      } catch (_) {
        throw Exception("Login gagal (HTTP ${res.statusCode}): ${res.body}");
      }
    }
  }
}
