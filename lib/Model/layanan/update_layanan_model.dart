// To parse this JSON data, do
//
//     final deleteModel = deleteModelFromJson(jsonString);

import 'dart:convert';

UpdateList deleteModelFromJson(String str) =>
    UpdateList.fromJson(json.decode(str));

String deleteModelToJson(UpdateList data) => json.encode(data.toJson());

class UpdateList {
  String? message;
  Data? data;

  UpdateList({this.message, this.data});

  factory UpdateList.fromJson(Map<String, dynamic> json) => UpdateList(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  int? id;
  String? name;
  String? description;
  int? price;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? employeeName;
  String? employeePhoto;
  String? servicePhoto;
  String? employeePhotoUrl;
  String? servicePhotoUrl;

  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
