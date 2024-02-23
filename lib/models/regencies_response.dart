// To parse this JSON data, do
//
//     final regenciesResponse = regenciesResponseFromJson(jsonString);

import 'dart:convert';

List<RegenciesResponse> regenciesResponseFromJson(String str) =>
    List<RegenciesResponse>.from(
        json.decode(str).map((x) => RegenciesResponse.fromJson(x)));

String regenciesResponseToJson(List<RegenciesResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RegenciesResponse {
  String id;
  String provinceId;
  String name;
  String altName;
  double latitude;
  double longitude;

  RegenciesResponse({
    required this.id,
    required this.provinceId,
    required this.name,
    required this.altName,
    required this.latitude,
    required this.longitude,
  });

  factory RegenciesResponse.fromJson(Map<String, dynamic> json) =>
      RegenciesResponse(
        id: json["id"],
        provinceId: json["province_id"],
        name: json["name"],
        altName: json["alt_name"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "province_id": provinceId,
        "name": name,
        "alt_name": altName,
        "latitude": latitude,
        "longitude": longitude,
      };
}
