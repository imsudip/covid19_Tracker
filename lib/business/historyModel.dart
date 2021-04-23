// To parse this JSON data, do
//
//     final history = historyFromJson(jsonString);

import 'dart:convert';

import 'latestmodel.dart';

History historyFromJson(String str) => History.fromJson(json.decode(str));

String historyToJson(History data) => json.encode(data.toJson());

class History {
  History({
    this.success,
    this.data,
    this.lastRefreshed,
    this.lastOriginUpdate,
  });

  bool success;
  List<Datum> data;
  DateTime lastRefreshed;
  DateTime lastOriginUpdate;

  factory History.fromJson(Map<String, dynamic> json) => History(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        lastRefreshed: DateTime.parse(json["lastRefreshed"]),
        lastOriginUpdate: DateTime.parse(json["lastOriginUpdate"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "lastRefreshed": lastRefreshed.toIso8601String(),
        "lastOriginUpdate": lastOriginUpdate.toIso8601String(),
      };
}

class Datum {
  Datum({
    this.day,
    this.summary,
    this.regional,
  });

  DateTime day;
  Summary summary;
  List<Regional> regional;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        day: DateTime.parse(json["day"]),
        summary: Summary.fromJson(json["summary"]),
        regional: List<Regional>.from(
            json["regional"].map((x) => Regional.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "day":
            "${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}",
        "summary": summary.toJson(),
        "regional": List<dynamic>.from(regional.map((x) => x.toJson())),
      };
}
