// To parse this JSON data, do
//
//     final discussionResponse = discussionResponseFromJson(jsonString);

import 'dart:convert';

DiscussionEventResponse discussionResponseFromJson(String str) =>
    DiscussionEventResponse.fromJson(json.decode(str));

String discussionResponseToJson(DiscussionEventResponse data) =>
    json.encode(data.toJson());

class DiscussionEventResponse {
  Discussion discussion;

  DiscussionEventResponse({
    required this.discussion,
  });

  factory DiscussionEventResponse.fromJson(Map<String, dynamic> json) =>
      DiscussionEventResponse(
        discussion: Discussion.fromJson(json["discussion"]),
      );

  Map<String, dynamic> toJson() => {
        "discussion": discussion.toJson(),
      };
}

class Discussion {
  int id;
  int userId;
  int productId;
  String message;
  DateTime createdAt;
  DateTime updatedAt;

  Discussion({
    required this.id,
    required this.userId,
    required this.productId,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Discussion.fromJson(Map<String, dynamic> json) => Discussion(
        id: json["id"],
        userId: json["userId"],
        productId: json["productId"],
        message: json["message"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "productId": productId,
        "message": message,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
