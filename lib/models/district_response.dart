// To parse this JSON data, do
//
//     final districtResponse = districtResponseFromJson(jsonString);

import 'dart:convert';

List<DistrictResponse> districtResponseFromJson(String str) =>
    List<DistrictResponse>.from(
        json.decode(str).map((x) => DistrictResponse.fromJson(x)));

String districtResponseToJson(List<DistrictResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DistrictResponse {
  String id;
  String regencyId;
  String name;
  String altName;
  double? latitude;
  double? longitude;

  DistrictResponse({
    required this.id,
    required this.regencyId,
    required this.name,
    required this.altName,
    required this.latitude,
    required this.longitude,
  });

  factory DistrictResponse.fromJson(Map<String, dynamic> json) =>
      DistrictResponse(
        id: json["id"],
        regencyId: json["regency_id"],
        name: json["name"],
        altName: json["alt_name"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "regency_id": regencyId,
        "name": name,
        "alt_name": altName,
        "latitude": latitude,
        "longitude": longitude,
      };
}
