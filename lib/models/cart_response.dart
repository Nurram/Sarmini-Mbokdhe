// To parse this JSON data, do
//
//     final cartResponse = cartResponseFromJson(jsonString);

import 'dart:convert';

CartResponse cartResponseFromJson(String str) =>
    CartResponse.fromJson(json.decode(str));

String cartResponseToJson(CartResponse data) => json.encode(data.toJson());

class CartResponse {
  int code;
  bool success;
  List<CartDatum> data;
  String message;

  CartResponse({
    required this.code,
    required this.success,
    required this.data,
    required this.message,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
        code: json["code"],
        success: json["success"],
        data: List<CartDatum>.from(
            json["data"].map((x) => CartDatum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class CartDatum {
  int id;
  int productId;
  int userId;
  DateTime createdAt;
  dynamic updatedAt;
  String name;
  String file;
  int price;
  String unit;
  bool selected;
  int cartQty;

  CartDatum({
    required this.id,
    required this.productId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.file,
    required this.price,
    required this.unit,
    this.selected = false,
    this.cartQty = 1,
  });

  factory CartDatum.fromJson(Map<String, dynamic> json) => CartDatum(
        id: json["id"],
        productId: json["productId"],
        userId: json["userId"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        name: json["name"],
        file: json["file"],
        price: json["price"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "userId": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
        "name": name,
        "file": file,
        "price": price,
        "unit": unit,
      };
}
