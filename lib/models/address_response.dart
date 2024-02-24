// To parse this JSON data, do
//
//     final addressResponse = addressResponseFromJson(jsonString);

import 'dart:convert';

AddressResponse addressResponseFromJson(String str) =>
    AddressResponse.fromJson(json.decode(str));

String addressResponseToJson(AddressResponse data) =>
    json.encode(data.toJson());

class AddressResponse {
  int code;
  bool success;
  List<AddressDatum> data;
  String message;

  AddressResponse({
    required this.code,
    required this.success,
    required this.data,
    required this.message,
  });

  factory AddressResponse.fromJson(Map<String, dynamic> json) =>
      AddressResponse(
        code: json["code"],
        success: json["success"],
        data: List<AddressDatum>.from(
            json["data"].map((x) => AddressDatum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class AddressDatum {
  int id;
  int userId;
  String name;
  String receipient;
  String phoneNumber;
  String address;
  String province;
  String district;
  String regency;
  String lat;
  String long;
  int postalCode;
  bool isPrimary;
  DateTime createdAt;
  dynamic updatedAt;

  AddressDatum({
    required this.id,
    required this.userId,
    required this.name,
    required this.receipient,
    required this.phoneNumber,
    required this.address,
    required this.province,
    required this.district,
    required this.regency,
    required this.lat,
    required this.long,
    required this.postalCode,
    required this.isPrimary,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressDatum.fromJson(Map<String, dynamic> json) => AddressDatum(
        id: json["id"],
        userId: json["userId"],
        name: json["name"],
        receipient: json["receipient"],
        phoneNumber: json["phoneNumber"],
        address: json["address"],
        province: json["province"] ?? "",
        district: json["district"] ?? "",
        regency: json["regency"] ?? "",
        lat: json["lat"],
        long: json["long"],
        postalCode: json["postalCode"],
        isPrimary: json["isPrimary"] == 1 ? true : false,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "name": name,
        "receipient": receipient,
        "phoneNumber": phoneNumber,
        "address": address,
        "province": province,
        "district": district,
        "regency": regency,
        "lat": lat,
        "long": long,
        "postalCode": postalCode,
        "isPrimary": isPrimary ? 1 : 0,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
      };
}
