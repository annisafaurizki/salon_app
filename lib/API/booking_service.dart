import 'dart:convert';
import 'package:app_salon_projek/API/Endpoint/endpoint.dart';
import 'package:app_salon_projek/Share_Preferences/share_preferences.dart';
import 'package:app_salon_projek/model/booking_model.dart';
import 'package:app_salon_projek/model/riwayat_booking.dart';
import 'package:http/http.dart' as http;

class BookingService {
  // ---- Helpers ----
  static Future<String> _readToken() async {
    final t = await PreferenceHandler.getToken();
    if (t == null || t.toString().trim().isEmpty) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }
    return t.toString();
  }

  static Map<String, String> _headers(String token, {bool form = true}) => {
        "Accept": "application/json",
        if (form) "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer $token",
      };

  static Never _throwApi(http.Response r, {String defaultMsg = "Permintaan gagal"}) {
    try {
      final obj = json.decode(r.body);
      if (obj is Map && obj["message"] != null) {
        throw Exception(obj["message"]);
      }
    } catch (_) {
      // body bukan JSON valid, biarkan lanjut
    }
    throw Exception("$defaultMsg (HTTP ${r.statusCode}): ${r.body}");
  }

  // ---- API ----
static Future<BookingModel> addServices({
  required String serviceId,       // biarkan String di signature-mu
  required String bookingTime,     // contoh: "2025-06-20T14:00:00"
}) async {
  final url = Uri.parse(Endpoint.bookings);
  final token = await _readToken();

  // siapkan payload sesuai contoh API (JSON + service_id integer)
  final payload = {
    "service_id": int.tryParse(serviceId) ?? serviceId, // coba kirim int kalau bisa
    "booking_time": bookingTime,                        // ISO8601 tanpa milidetik
  };

  print("📤 [POST] $url");
  print("🧾 Payload: $payload");

  final response = await http.post(
    url,
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
    body: json.encode(payload),
  );

  print("📡 [POST] ${response.statusCode}");
  print("📩 Body: ${response.body}");

  if (response.statusCode == 200 || response.statusCode == 201) {
    return BookingModel.fromJson(json.decode(response.body));
  }

  // Tangani 422 agar pesan validasinya kelihatan
  try {
    final map = json.decode(response.body);
    final msg = map['message']?.toString();
    final errs = map['errors'];
    if (errs is Map) {
      final details = errs.entries
          .map((e) => "${e.key}: ${(e.value as List).join(', ')}")
          .join(" | ");
      throw Exception("${msg ?? 'Gagal melakukan booking'} — $details");
    }
    throw Exception(msg ?? "Gagal melakukan booking (HTTP ${response.statusCode})");
  } catch (_) {
    _throwApi(response, defaultMsg: "Gagal melakukan booking");
  }
}


  static Future<HasilBooking> getBookings() async {
    final url = Uri.parse(Endpoint.bookings);
    final token = await _readToken();

    final response = await http.get(
      url,
      headers: _headers(token, form: false), // GET tidak butuh Content-Type
    );

    print("📡 [GET] ${response.statusCode}");
    print("📥 Response Body (Riwayat): ${response.body}");

    if (response.statusCode == 200) {
      return HasilBooking.fromJson(json.decode(response.body));
    } else {
      _throwApi(response, defaultMsg: "Gagal mengambil riwayat booking");
    }
  }

  /// Opsional: cek cepat apakah token valid (endpoint: /api/profile).
  static Future<void> pingAuth() async {
    final token = await _readToken();
    final url = Uri.parse(Endpoint.profile);
    final res = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });
    print("🔎 [AUTH CHECK] ${res.statusCode} -> ${res.body}");
    if (res.statusCode != 200) _throwApi(res, defaultMsg: "Token tidak valid");
  }
}
