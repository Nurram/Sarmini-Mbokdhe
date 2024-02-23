
// To parse this JSON data, do
//
//     final CategoryResponse = categoryResponseFromJson(jsonString);

import 'dart:convert';

CategoryResponse categoryResponseFromJson(String str) =>
    CategoryResponse.fromJson(json.decode(str));

String categoryResponseToJson(CategoryResponse data) =>
    json.encode(data.toJson());

class CategoryResponse {
  int code;
  bool success;
  List<CategoryDatum> data;
  String message;

  CategoryResponse({
    required this.code,
    required this.success,
    required this.data,
    required this.message,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      CategoryResponse(
        code: json["code"],
        success: json["success"],
        data: List<CategoryDatum>.from(json["data"].map((x) => CategoryDatum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class CategoryDatum {
  int id;
  String name;
  String image;
  dynamic createdAt;
  dynamic updatedAt;

  CategoryDatum({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryDatum.fromJson(Map<String, dynamic> json) => CategoryDatum(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
