// To parse this JSON data, do
//
//     final hasilBooking = hasilBookingFromJson(jsonString);

import 'dart:convert';

HasilBooking hasilBookingFromJson(String str) =>
    HasilBooking.fromJson(json.decode(str));

String hasilBookingToJson(HasilBooking data) => json.encode(data.toJson());

class HasilBooking {
  String message;
  List<Data> data;

  HasilBooking({
    required this.message,
    required this.data,
  });

  factory HasilBooking.fromJson(Map<String, dynamic> json) => HasilBooking(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Data {
  int? id;
  int? userId;
  int? serviceId;
  String? bookingTime;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.userId,
    this.serviceId,
    this.bookingTime,
    this.createdAt,
    this.updatedAt, 
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        serviceId: json["service_id"],
        bookingTime: json["booking_time"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "service_id": serviceId,
        "booking_time": bookingTime,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
