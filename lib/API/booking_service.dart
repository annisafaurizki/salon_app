import 'dart:convert';

import 'package:app_salon_projek/api/Endpoint/endpoint.dart';
import 'package:app_salon_projek/model/booking/booking_model.dart';
import 'package:app_salon_projek/model/booking/get_booking.dart';
import 'package:app_salon_projek/model/booking/update_booking.dart';
import 'package:app_salon_projek/share_preferences/share_preferences.dart';
import 'package:http/http.dart' as http;

class BookingApiService {
  /// ✅ Tambah booking baru
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
      // 👇 ini cukup decode sekali aja
      return AddBooking.fromJson(json.decode(response.body));
    } else {
      throw Exception("❌ Gagal booking: ${response.body}");
    }
  }

  /// ✅ Ambil riwayat booking user
  static Future<List<BookingData>> getBookingHistory() async {
    final url = Uri.parse(Endpoint.bookings); // sesuaikan endpoint riwayat
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
      return booking.data; // ini List<Datum>
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal mengambil riwayat booking");
    }
  }

  static Future<UpdateBooking> updateBooking({
  required int id,
  required int serviceId,
  required DateTime bookingTime,
  required String status,
}) async {
  final url = Uri.parse("${Endpoint.bookings}/$id");
  final token = await PreferenceHandler.getToken();

  final response = await http.put(
    url,
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    },
    body: jsonEncode({
      "service_id": serviceId,
      "booking_time": bookingTime.toIso8601String(),
      "status": status,
    }),
  );

  if (response.statusCode == 200) {
    return UpdateBooking.fromJson(json.decode(response.body));
  } else {
    throw Exception("❌ Gagal update booking: ${response.body}");
  }
}

}