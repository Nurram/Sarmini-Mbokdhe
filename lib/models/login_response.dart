// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  int code;
  bool success;
  LoginResponseData data;
  String message;

  LoginResponse({
    required this.code,
    required this.success,
    required this.data,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        code: json["code"],
        success: json["success"],
        data: LoginResponseData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class LoginResponseData {
  int userId;
  LoginData data;

  LoginResponseData({
    required this.userId,
    required this.data,
  });

  factory LoginResponseData.fromJson(Map<String, dynamic> json) =>
      LoginResponseData(
        userId: json["userId"],
        data: LoginData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "data": data.toJson(),
      };
}

class LoginData {
  String detail;
  List<String> id;
  String process;
  bool status;
  List<String> target;

  LoginData({
    required this.detail,
    required this.id,
    required this.process,
    required this.status,
    required this.target,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        detail: json["detail"],
        id: List<String>.from(json["id"].map((x) => x)),
        process: json["process"],
        status: json["status"],
        target: List<String>.from(json["target"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "detail": detail,
        "id": List<dynamic>.from(id.map((x) => x)),
        "process": process,
        "status": status,
        "target": List<dynamic>.from(target.map((x) => x)),
      };
}
