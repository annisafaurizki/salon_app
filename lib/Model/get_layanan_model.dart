// To parse this JSON data, do
//
//     final getLayanan = getLayananFromJson(jsonString);

import 'dart:convert';

GetLayanan getLayananFromJson(String str) =>
    GetLayanan.fromJson(json.decode(str));

String getLayananToJson(GetLayanan data) => json.encode(data.toJson());

class GetLayanan {
  String? message;
  List<DataLayanan>? data;

  GetLayanan({this.message, this.data});

  factory GetLayanan.fromJson(Map<String, dynamic> json) => GetLayanan(
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<DataLayanan>.from(
            json["data"]!.map((x) => DataLayanan.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class DataLayanan {
  int? id;
  String? name;
  String? description;
  String? price;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? employeeName;
  String? employeePhoto;
  String? servicePhoto;
  String? employeePhotoUrl;
  String? servicePhotoUrl;

  DataLayanan({
    this.id,
    this.name,
    this.description,
    this.price,
    this.createdAt,
    this.updatedAt,
    this.employeeName,
    this.employeePhoto,
    this.servicePhoto,
    this.employeePhotoUrl,
    this.servicePhotoUrl,
  });

  factory DataLayanan.fromJson(Map<String, dynamic> json) => DataLayanan(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    employeeName: json["employee_name"],
    employeePhoto: json["employee_photo"],
    servicePhoto: json["service_photo"],
    employeePhotoUrl: json["employee_photo_url"],
    servicePhotoUrl: json["service_photo_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "price": price,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "employee_name": employeeName,
    "employee_photo": employeePhoto,
    "service_photo": servicePhoto,
    "employee_photo_url": employeePhotoUrl,
    "service_photo_url": servicePhotoUrl,
  };
}
