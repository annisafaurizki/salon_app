import 'dart:convert';

import 'package:app_salon_projek/API/Endpoint/endpoint.dart';
import 'package:app_salon_projek/Model/add_layanan_model.dart';
import 'package:app_salon_projek/Share_Preferences/share_preferences.dart';
import 'package:app_salon_projek/model/booking_model.dart';
import 'package:http/http.dart' as http;

class BookingService {
  static Future<AddLayananModel> addServices({
    required String serviceId,
    required String bookingTime,
  }) async {
    final url = Uri.parse(Endpoint.bookings);
    final token = await PreferenceHandler.getToken();

    final response = await http.post(
      url,
      body: {"service_id": serviceId, "booking_time": bookingTime},
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

  static Future<BookingModel> updateBookings({
    required String serviceId,
    required String status,
    required String bookingTime,
  }) async {
    final url = Uri.parse("${Endpoint.bookings}/$serviceId");
    final token = await PreferenceHandler.getToken();
    print(
      "➡️ POST body: ${{"id": serviceId, "BookingTime": bookingTime, "Status": status}}",
    );

    final response = await http.put(
      url,
      body: {"service_id": serviceId, "booking_time": bookingTime},
      headers: {
        "Accept": "application/json",
        // "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return BookingModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal menambahkan layanan");
    }
  }

  // static Future<GetLayanan> getService() async {
  //   final url = Uri.parse(Endpoint.services);
  //   final token = await PreferenceHandler.getToken();

  //   final response = await http.get(
  //     url,
  //     headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
  //   );

  //   if (response.statusCode == 200) {
  //     return GetLayanan.fromJson(json.decode(response.body));
  //   } else {
  //     final error = json.decode(response.body);
  //     throw Exception(error["message"] ?? "Gagal mengambil data layanan");
  //   }
  // }

  // static Future<DeleteModel> deleteService(int id) async {
  //   final url = Uri.parse("${Endpoint.services}/$id");
  //   final token = await PreferenceHandler.getToken();

  //   final response = await http.delete(
  //     url,
  //     headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
  //   );

  //   if (response.statusCode == 200) {
  //     return DeleteModel.fromJson(json.decode(response.body));
  //   } else {
  //     final error = json.decode(response.body);
  //     throw Exception(error["message"] ?? "Gagal mengambil data layanan");
  //   }
  // }
}
