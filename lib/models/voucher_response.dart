// To parse this JSON data, do
//
//     final voucherResponse = voucherResponseFromJson(jsonString);

import 'dart:convert';

VoucherResponse voucherResponseFromJson(String str) =>
    VoucherResponse.fromJson(json.decode(str));

String voucherResponseToJson(VoucherResponse data) =>
    json.encode(data.toJson());

class VoucherResponse {
  int code;
  bool success;
  List<VoucherDatum> data;
  String message;

  VoucherResponse({
    required this.code,
    required this.success,
    required this.data,
    required this.message,
  });

  factory VoucherResponse.fromJson(Map<String, dynamic> json) =>
      VoucherResponse(
        code: json["code"],
        success: json["success"],
        data: List<VoucherDatum>.from(
            json["data"].map((x) => VoucherDatum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class VoucherDatum {
  int id;
  String title;
  String code;
  String description;
  String type;
  int amount;
  int minimumTrx;
  DateTime validFrom;
  DateTime validTo;
  String image;
  DateTime createdAt;
  dynamic updatedAt;

  VoucherDatum({
    required this.id,
    required this.title,
    required this.code,
    required this.description,
    required this.type,
    required this.amount,
    required this.minimumTrx,
    required this.validFrom,
    required this.validTo,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VoucherDatum.fromJson(Map<String, dynamic> json) => VoucherDatum(
        id: json["id"],
        title: json["title"],
        code: json["code"],
        description: json["description"],
        type: json["type"],
        amount: int.parse(json["amount"]),
        minimumTrx: int.parse(json["minimumTrx"]),
        validFrom: DateTime.parse(json["validFrom"]),
        validTo: DateTime.parse(json["validTo"]),
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "code": code,
        "description": description,
        "type": type,
        "amount": amount,
        "minimumTrx": minimumTrx,
        "validFrom": validFrom.toIso8601String(),
        "validTo": validTo.toIso8601String(),
        "image": image,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
      };
}
