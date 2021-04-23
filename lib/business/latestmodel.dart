// To parse this JSON data, do
//
//     final latest = latestFromJson(jsonString);

import 'dart:convert';

Latest latestFromJson(String str) => Latest.fromJson(json.decode(str));

String latestToJson(Latest data) => json.encode(data.toJson());

class Latest {
  Latest({
    this.success,
    this.data,
    this.lastRefreshed,
    this.lastOriginUpdate,
  });

  bool success;
  Data data;
  DateTime lastRefreshed;
  DateTime lastOriginUpdate;

  factory Latest.fromJson(Map<String, dynamic> json) => Latest(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        lastRefreshed: DateTime.parse(json["lastRefreshed"]),
        lastOriginUpdate: DateTime.parse(json["lastOriginUpdate"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "lastRefreshed": lastRefreshed.toIso8601String(),
        "lastOriginUpdate": lastOriginUpdate.toIso8601String(),
      };
}

class Data {
  Data({
    this.summary,
    this.unofficialSummary,
    this.regional,
  });

  Summary summary;
  List<UnofficialSummary> unofficialSummary;
  List<Regional> regional;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        summary: Summary.fromJson(json["summary"]),
        unofficialSummary: List<UnofficialSummary>.from(
            json["unofficial-summary"]
                .map((x) => UnofficialSummary.fromJson(x))),
        regional: List<Regional>.from(
            json["regional"].map((x) => Regional.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "summary": summary.toJson(),
        "unofficial-summary":
            List<dynamic>.from(unofficialSummary.map((x) => x.toJson())),
        "regional": List<dynamic>.from(regional.map((x) => x.toJson())),
      };
}

class Regional {
  Regional({
    this.loc,
    this.confirmedCasesIndian,
    this.confirmedCasesForeign,
    this.discharged,
    this.deaths,
    this.totalConfirmed,
  });

  String loc;
  int confirmedCasesIndian;
  int confirmedCasesForeign;
  int discharged;
  int deaths;
  int totalConfirmed;

  factory Regional.fromJson(Map<String, dynamic> json) => Regional(
        loc: json["loc"],
        confirmedCasesIndian: json["confirmedCasesIndian"],
        confirmedCasesForeign: json["confirmedCasesForeign"],
        discharged: json["discharged"],
        deaths: json["deaths"],
        totalConfirmed: json["totalConfirmed"],
      );

  Map<String, dynamic> toJson() => {
        "loc": loc,
        "confirmedCasesIndian": confirmedCasesIndian,
        "confirmedCasesForeign": confirmedCasesForeign,
        "discharged": discharged,
        "deaths": deaths,
        "totalConfirmed": totalConfirmed,
      };
}

class Summary {
  Summary({
    this.total,
    this.confirmedCasesIndian,
    this.confirmedCasesForeign,
    this.discharged,
    this.deaths,
    this.confirmedButLocationUnidentified,
  });

  int total;
  int confirmedCasesIndian;
  int confirmedCasesForeign;
  int discharged;
  int deaths;
  int confirmedButLocationUnidentified;

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        total: json["total"],
        confirmedCasesIndian: json["confirmedCasesIndian"],
        confirmedCasesForeign: json["confirmedCasesForeign"],
        discharged: json["discharged"],
        deaths: json["deaths"],
        confirmedButLocationUnidentified:
            json["confirmedButLocationUnidentified"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "confirmedCasesIndian": confirmedCasesIndian,
        "confirmedCasesForeign": confirmedCasesForeign,
        "discharged": discharged,
        "deaths": deaths,
        "confirmedButLocationUnidentified": confirmedButLocationUnidentified,
      };
}

class UnofficialSummary {
  UnofficialSummary({
    this.source,
    this.total,
    this.recovered,
    this.deaths,
    this.active,
  });

  String source;
  int total;
  int recovered;
  int deaths;
  int active;

  factory UnofficialSummary.fromJson(Map<String, dynamic> json) =>
      UnofficialSummary(
        source: json["source"],
        total: json["total"],
        recovered: json["recovered"],
        deaths: json["deaths"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "source": source,
        "total": total,
        "recovered": recovered,
        "deaths": deaths,
        "active": active,
      };
}
