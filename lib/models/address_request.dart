// To parse this JSON data, do
//
//     final addressRequest = addressRequestFromJson(jsonString);

import 'dart:convert';

AddressRequest addressRequestFromJson(String str) =>
    AddressRequest.fromJson(json.decode(str));

String addressRequestToJson(AddressRequest data) => json.encode(data.toJson());

class AddressRequest {
  int userId;
  String name;
  String receipient;
  String address;
  String district;
  String regency;
  String province;
  String phoneNumber;
  double lat;
  double long;
  int postalCode;
  bool isPrimary;

  AddressRequest({
    required this.userId,
    required this.name,
    required this.receipient,
    required this.address,
    required this.district,
    required this.regency,
    required this.province,
    required this.phoneNumber,
    required this.lat,
    required this.long,
    required this.postalCode,
    required this.isPrimary,
  });

  factory AddressRequest.fromJson(Map<String, dynamic> json) => AddressRequest(
        userId: json["userId"],
        name: json["name"],
        receipient: json["receipient"],
        address: json["address"],
        district: json["district"],
        regency: json["regency"],
        province: json["province"],
        phoneNumber: json["phoneNumber"],
        lat: json["lat"]?.toDouble(),
        long: json["long"]?.toDouble(),
        postalCode: json["postalCode"],
        isPrimary: json["isPrimary"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "receipient": receipient,
        "address": address,
        "province": province,
        "district": district,
        "regency": regency,
        "phoneNumber": phoneNumber,
        "lat": lat,
        "long": long,
        "postalCode": postalCode,
        "isPrimary": isPrimary,
      };
}
