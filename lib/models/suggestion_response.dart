// To parse this JSON data, do
//
//     final suggestionResponse = suggestionResponseFromJson(jsonString);

import 'dart:convert';

SuggestionResponse suggestionResponseFromJson(String str) =>
    SuggestionResponse.fromJson(json.decode(str));

String suggestionResponseToJson(SuggestionResponse data) =>
    json.encode(data.toJson());

class SuggestionResponse {
  int code;
  bool success;
  List<SuggestionDatum> data;
  String message;

  SuggestionResponse({
    required this.code,
    required this.success,
    required this.data,
    required this.message,
  });

  factory SuggestionResponse.fromJson(Map<String, dynamic> json) =>
      SuggestionResponse(
        code: json["code"],
        success: json["success"],
        data: List<SuggestionDatum>.from(json["data"].map((x) => SuggestionDatum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class SuggestionDatum {
  int id;
  String name;

  SuggestionDatum({
    required this.id,
    required this.name,
  });

  factory SuggestionDatum.fromJson(Map<String, dynamic> json) => SuggestionDatum(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
