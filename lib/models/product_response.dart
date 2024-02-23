// To parse this JSON data, do
//
//     final productResponse = productResponseFromJson(jsonString);

import 'dart:convert';

ProductResponse productResponseFromJson(String str) =>
    ProductResponse.fromJson(json.decode(str));

String productResponseToJson(ProductResponse data) => json.encode(data.toJson());

class ProductResponse {
  int code;
  bool success;
  List<ProductDatum> data;
  String message;

  ProductResponse({
    required this.code,
    required this.success,
    required this.data,
    required this.message,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) => ProductResponse(
        code: json["code"],
        success: json["success"],
        data: List<ProductDatum>.from(json["data"].map((x) => ProductDatum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class ProductDatum {
  int id;
  String name;
  int price;
  int categoryId;
  String description;
  String file;
  int isFreeService;
  String weight;
  int stock;
  String unit;
  dynamic createdAt;
  dynamic updatedAt;

  ProductDatum({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    required this.description,
    required this.file,
    required this.isFreeService,
    required this.weight,
    required this.stock,
    required this.unit,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductDatum.fromJson(Map<String, dynamic> json) => ProductDatum(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        categoryId: json["categoryId"],
        description: json["description"],
        file: json["file"],
        isFreeService: json["isFreeService"],
        weight: json["weight"],
        stock: json["stock"],
        unit: json["unit"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "categoryId": categoryId,
        "description": description,
        "file": file,
        "isFreeService": isFreeService,
        "weight": weight,
        "stock": stock,
        "unit": unit,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
