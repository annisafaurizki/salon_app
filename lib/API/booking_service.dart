import 'dart:convert';

import 'package:app_salon_projek/api/Endpoint/endpoint.dart';
import 'package:app_salon_projek/model/booking/booking_model.dart';
import 'package:app_salon_projek/model/booking/get_booking.dart';
import 'package:app_salon_projek/share_preferences/share_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BookingApiService {
  /// ✅ UPDATE STATUS BOOKING - FIXED
  static Future<bool> updateBookingStatus({
    required int id,
    required String status,
  }) async {
    try {
      final token = await PreferenceHandler.getToken();

      if (token == null) {
        debugPrint("❌ Token tidak tersedia");
        return false;
      }

      // PASTIKAN ENDPOINT INI BENAR - tanya backend Anda
      final url = Uri.parse("${Endpoint.bookings}/$id");

      debugPrint("🌐 URL Update: $url");
      debugPrint("📤 Mengupdate status: $status");

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"status": status}),
      );

      debugPrint("📊 Status Code: ${response.statusCode}");
      debugPrint("📦 Response Body: ${response.body}");

      // CEK JIKA BERHASIL
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("✅ Status berhasil diupdate");
        return true;
      } else {
        debugPrint(
          "❌ Gagal update status. Status code: ${response.statusCode}",
        );
        return false;
      }
    } catch (e) {
      debugPrint("❌ Error saat update status: $e");
      return false;
    }
  }

  /// ✅ AMBIL RIWAYAT BOOKING
  static Future<List<BookingData>> getBookingHistory() async {
    final url = Uri.parse(Endpoint.bookings);
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final booking = GetBooking.fromJson(decoded);
      return booking.data;
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal mengambil riwayat booking");
    }
  }

  /// ✅ TAMBAH BOOKING BARU
  static Future<AddBooking> addBooking({
    required int serviceId,
    required DateTime bookingTime,
  }) async {
    final url = Uri.parse(Endpoint.bookings);
    final token = await PreferenceHandler.getToken();

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "service_id": serviceId,
        "booking_time": bookingTime.toIso8601String(),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AddBooking.fromJson(json.decode(response.body));
    } else {
      throw Exception("❌ Gagal booking: ${response.body}");
    }
  }

  static Future<bool> deleteBooking(int id) async {
    final url = Uri.parse("${Endpoint.bookings}/$id");
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
        throw Exception(error["message"] ?? "Gagal menghapus Booking");
      } catch (e) {
        throw Exception(
          "Gagal menghapus Booking (status ${response.statusCode})",
        );
      }
    }
  }
}
