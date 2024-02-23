// To parse this JSON data, do
//
//     final historyResponse = historyResponseFromJson(jsonString);

import 'dart:convert';

HistoryResponse historyResponseFromJson(String str) =>
    HistoryResponse.fromJson(json.decode(str));

String historyResponseToJson(HistoryResponse data) =>
    json.encode(data.toJson());

class HistoryResponse {
  int code;
  bool success;
  List<HistoryDatum> data;
  String message;

  HistoryResponse({
    required this.code,
    required this.success,
    required this.data,
    required this.message,
  });

  factory HistoryResponse.fromJson(Map<String, dynamic> json) =>
      HistoryResponse(
        code: json["code"],
        success: json["success"],
        data: List<HistoryDatum>.from(json["data"].map((x) => HistoryDatum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class HistoryDatum {
  int id;
  int userId;
  int totalPrice;
  String destination;
  String status;
  dynamic image;
  String paymentMethod;
  String serviceFee;
  dynamic voucherId;
  dynamic voucherAmount;
  dynamic notes;
  DateTime createdAt;
  DateTime? updatedAt;
  List<HistoryProduct> products;

  HistoryDatum({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.destination,
    required this.status,
    required this.image,
    required this.paymentMethod,
    required this.serviceFee,
    required this.voucherId,
    required this.voucherAmount,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.products,
  });

  factory HistoryDatum.fromJson(Map<String, dynamic> json) => HistoryDatum(
        id: json["id"],
        userId: json["userId"],
        totalPrice: json["totalPrice"],
        destination: json["destination"],
        status: json["status"],
        image: json["image"],
        paymentMethod: json["paymentMethod"],
        serviceFee: json["serviceFee"],
        voucherId: json["voucherId"],
        voucherAmount: json["voucherAmount"],
        notes: json["notes"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        products: List<HistoryProduct>.from(
            json["products"].map((x) => HistoryProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "totalPrice": totalPrice,
        "destination": destination,
        "status": status,
        "image": image,
        "paymentMethod": paymentMethod,
        "serviceFee": serviceFee,
        "voucherId": voucherId,
        "voucherAmount": voucherAmount,
        "notes": notes,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class HistoryProduct {
  int id;
  int orderId;
  int productId;
  int qty;
  dynamic createdAt;
  dynamic updatedAt;
  String name;
  int price;
  int categoryId;
  String description;
  String file;
  int isFreeService;
  String weight;
  int stock;
  String unit;

  HistoryProduct({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.qty,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.price,
    required this.categoryId,
    required this.description,
    required this.file,
    required this.isFreeService,
    required this.weight,
    required this.stock,
    required this.unit,
  });

  factory HistoryProduct.fromJson(Map<String, dynamic> json) => HistoryProduct(
        id: json["id"],
        orderId: json["orderId"],
        productId: json["productId"],
        qty: json["qty"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        name: json["name"],
        price: json["price"],
        categoryId: json["categoryId"],
        description: json["description"],
        file: json["file"],
        isFreeService: json["isFreeService"],
        weight: json["weight"],
        stock: json["stock"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderId": orderId,
        "productId": productId,
        "qty": qty,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "name": name,
        "price": price,
        "categoryId": categoryId,
        "description": description,
        "file": file,
        "isFreeService": isFreeService,
        "weight": weight,
        "stock": stock,
        "unit": unit,
      };
}
