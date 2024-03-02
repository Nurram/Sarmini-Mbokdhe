// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'dart:convert';

UserResponse userResponseFromJson(String str) =>
    UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  int code;
  String message;
  User user;
  String? token;

  UserResponse({
    required this.code,
    required this.message,
    required this.user,
    required this.token,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        code: json["code"],
        message: json["message"],
        user: User.fromJson(json["data"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "user": user.toJson(),
        "token": token,
      };
}

class User {
  int id;
  String phone;
  String? firstname;
  String? lastname;
  String? email;
  String? image;
  int balance;
  dynamic createdAt;
  dynamic updatedAt;

  User({
    required this.id,
    required this.phone,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.image,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        phone: json["phone"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        image: json["image"],
        balance: json["balance"] is String
            ? int.parse(json["balance"])
            : json["balance"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "image": image,
        "balance": balance.toString(),
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
