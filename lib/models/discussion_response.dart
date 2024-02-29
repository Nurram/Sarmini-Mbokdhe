// To parse this JSON data, do
//
//     final discussionResponse = discussionResponseFromJson(jsonString);

import 'dart:convert';

DiscussionResponse discussionResponseFromJson(String str) =>
    DiscussionResponse.fromJson(json.decode(str));

String discussionResponseToJson(DiscussionResponse data) =>
    json.encode(data.toJson());

class DiscussionResponse {
  int code;
  bool success;
  List<DiscussionDatum> data;
  String message;

  DiscussionResponse({
    required this.code,
    required this.success,
    required this.data,
    required this.message,
  });

  factory DiscussionResponse.fromJson(Map<String, dynamic> json) =>
      DiscussionResponse(
        code: json["code"],
        success: json["success"],
        data: List<DiscussionDatum>.from(json["data"].map((x) => DiscussionDatum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class DiscussionDatum {
  int id;
  int userId;
  int productId;
  String message;
  DateTime createdAt;
  dynamic updatedAt;

  DiscussionDatum({
    required this.id,
    required this.userId,
    required this.productId,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DiscussionDatum.fromJson(Map<String, dynamic> json) => DiscussionDatum(
        id: json["id"],
        userId: json["userId"],
        productId: json["productId"],
        message: json["message"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "productId": productId,
        "message": message,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
      };
}