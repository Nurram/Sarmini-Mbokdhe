// To parse this JSON data, do
//
//     final chatListResponse = chatListResponseFromJson(jsonString);

import 'dart:convert';

ChatListResponse chatListResponseFromJson(String str) =>
    ChatListResponse.fromJson(json.decode(str));

String chatListResponseToJson(ChatListResponse data) =>
    json.encode(data.toJson());

class ChatListResponse {
  int code;
  bool success;
  List<ChatListDatum> data;
  String message;

  ChatListResponse({
    required this.code,
    required this.success,
    required this.data,
    required this.message,
  });

  factory ChatListResponse.fromJson(Map<String, dynamic> json) =>
      ChatListResponse(
          code: json["code"],
          success: json["success"],
          data: List<ChatListDatum>.from(
              json["data"].map((x) => ChatListDatum.fromJson(x))),
          message: json["message"]);

  Map<String, dynamic> toJson() => {
        "code": code,
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class ChatListDatum {
  int id;
  int userId;
  int senderId;
  int productId;
  String message;
  String name;
  String file;
  bool isRead;
  DateTime createdAt;
  DateTime? updatedAt;

  ChatListDatum({
    required this.id,
    required this.userId,
    required this.senderId,
    required this.productId,
    required this.message,
    required this.name,
    required this.file,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatListDatum.fromJson(Map<String, dynamic> json) => ChatListDatum(
        id: json["id"] is String ? int.parse(json["id"]) : json["id"],
        userId: json["userId"] is String
            ? int.parse(json['userId'])
            : json['userId'],
        senderId: json["senderId"] is String
            ? int.parse(json['senderId'])
            : json['senderId'],
        productId: json["productId"] is String
            ? int.parse(json['productId'])
            : json['productId'],
        message: json["message"],
        name: json["name"] ?? '',
        file: json["file"] ?? '',
        isRead: json['isRead'] == "1",
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "senderId": senderId,
        "productId": productId,
        "message": message,
        "name": name,
        "file": file,
        "isRead": isRead,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
