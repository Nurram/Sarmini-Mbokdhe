// To parse this JSON data, do
//
//     final orderRequest = orderRequestFromJson(jsonString);

import 'dart:convert';

String orderRequestToJson(OrderRequest data) => json.encode(data.toJson());

class OrderRequest {
  List<Map<String, dynamic>> products;
  int userId;
  int totalPrice;
  String destination;
  String status;
  String? image;
  String paymentMethod;
  String serviceFee;
  String phone;
  int? voucherId;
  int? voucherAmount;
  String? notes;

  OrderRequest({
    required this.products,
    required this.userId,
    required this.totalPrice,
    required this.destination,
    required this.status,
    required this.image,
    required this.paymentMethod,
    required this.serviceFee,
    required this.phone,
    required this.voucherId,
    required this.voucherAmount,
    required this.notes

  });
  Map<String, dynamic> toJson() => {
        "products": products,
        "userId": userId,
        "totalPrice": totalPrice,
        "destination": destination,
        "status": status,
        "image": image,
        "phone": phone,
        "paymentMethod": paymentMethod,
        "serviceFee": serviceFee,
        "voucherId": voucherId,
        "voucherAmount": voucherAmount,
        "notes": notes,
      };
}
