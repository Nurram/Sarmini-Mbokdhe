// To parse this JSON data, do
//
//     final otpResponse = otpResponseFromJson(jsonString);

import 'dart:convert';

import 'package:sarmini_mbokdhe/models/user_response.dart';

OtpResponse otpResponseFromJson(String str) =>
    OtpResponse.fromJson(json.decode(str));

String otpResponseToJson(OtpResponse data) => json.encode(data.toJson());

class OtpResponse {
  int code;
  String message;
  User user;
  String token;

  OtpResponse({
    required this.code,
    required this.message,
    required this.user,
    required this.token,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) => OtpResponse(
        code: json["code"],
        message: json["message"],
        user: User.fromJson(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "user": user.toJson(),
        "token": token,
      };
}
