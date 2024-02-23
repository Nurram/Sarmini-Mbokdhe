// To parse this JSON data, do
//
//     final utilsResponse = utilsResponseFromJson(jsonString);

import 'dart:convert';

ConstantsResponse utilsResponseFromJson(String str) =>
    ConstantsResponse.fromJson(json.decode(str));

String utilsResponseToJson(ConstantsResponse data) =>
    json.encode(data.toJson());

class ConstantsResponse {
  int code;
  bool success;
  List<ConstantsDatum> data;
  String message;

  ConstantsResponse({
    required this.code,
    required this.success,
    required this.data,
    required this.message,
  });

  factory ConstantsResponse.fromJson(Map<String, dynamic> json) =>
      ConstantsResponse(
        code: json["code"],
        success: json["success"],
        data: List<ConstantsDatum>.from(
            json["data"].map((x) => ConstantsDatum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class ConstantsDatum {
  int id;
  String name;
  String value;

  ConstantsDatum({
    required this.id,
    required this.name,
    required this.value,
  });

  factory ConstantsDatum.fromJson(Map<String, dynamic> json) => ConstantsDatum(
        id: json["id"],
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "value": value,
      };
}
