// To parse this JSON data, do
//
//     final topupResponse = topupResponseFromJson(jsonString);

import 'dart:convert';

TopupResponse topupResponseFromJson(String str) =>
    TopupResponse.fromJson(json.decode(str));

String topupResponseToJson(TopupResponse data) => json.encode(data.toJson());

class TopupResponse {
  int code;
  bool success;
  List<TopupDatum> data;
  String message;

  TopupResponse({
    required this.code,
    required this.success,
    required this.data,
    required this.message,
  });

  factory TopupResponse.fromJson(Map<String, dynamic> json) => TopupResponse(
        code: json["code"],
        success: json["success"],
        data: List<TopupDatum>.from(
            json["data"].map((x) => TopupDatum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class TopupDatum {
  int id;
  int userId;
  int amount;
  String image;
  String status;
  DateTime createdAt;
  dynamic updatedAt;

  TopupDatum({
    required this.id,
    required this.userId,
    required this.amount,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TopupDatum.fromJson(Map<String, dynamic> json) => TopupDatum(
        id: json["id"],
        userId: json["userId"],
        amount: json["amount"],
        image: json["image"] ?? '',
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "amount": amount,
        "image": image,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
      };
}
