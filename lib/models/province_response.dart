// To parse this JSON data, do
//
//     final provinceResponse = provinceResponseFromJson(jsonString);

import 'dart:convert';

List<ProvinceResponse> provinceResponseFromJson(String str) =>
    List<ProvinceResponse>.from(
        json.decode(str).map((x) => ProvinceResponse.fromJson(x)));

String provinceResponseToJson(List<ProvinceResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProvinceResponse {
  String id;
  String name;
  String altName;
  double latitude;
  double longitude;

  ProvinceResponse({
    required this.id,
    required this.name,
    required this.altName,
    required this.latitude,
    required this.longitude,
  });

  factory ProvinceResponse.fromJson(Map<String, dynamic> json) =>
      ProvinceResponse(
        id: json["id"],
        name: json["name"],
        altName: json["alt_name"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "alt_name": altName,
        "latitude": latitude,
        "longitude": longitude,
      };
}
