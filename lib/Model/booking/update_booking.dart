// To parse this JSON data, do
//
//     final updateBooking = updateBookingFromJson(jsonString);

import 'dart:convert';

UpdateBooking updateBookingFromJson(String str) => UpdateBooking.fromJson(json.decode(str));

String updateBookingToJson(UpdateBooking data) => json.encode(data.toJson());

class UpdateBooking {
    String message;
    DataBooking data;

    UpdateBooking({
        required this.message,
        required this.data,
    });

    factory UpdateBooking.fromJson(Map<String, dynamic> json) => UpdateBooking(
        message: json["message"],
        data: DataBooking.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
    };
}

class DataBooking {
    int id;
    int userId;
    int serviceId;
    DateTime bookingTime;
    String status;
    DateTime createdAt;
    DateTime updatedAt;

    DataBooking({
        required this.id,
        required this.userId,
        required this.serviceId,
        required this.bookingTime,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
    });

    factory DataBooking.fromJson(Map<String, dynamic> json) => DataBooking(
        id: json["id"],
        userId: json["user_id"],
        serviceId: json["service_id"],
        bookingTime: DateTime.parse(json["booking_time"]),
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "service_id": serviceId,
        "booking_time": bookingTime.toIso8601String(),
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
