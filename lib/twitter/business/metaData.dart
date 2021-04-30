// To parse this JSON data, do
//
//     final metadata = metadataFromJson(jsonString);

import 'dart:convert';

List<Metadata> metadataFromJson(String str) =>
    List<Metadata>.from(json.decode(str).map((x) => Metadata.fromJson(x)));

String metadataToJson(List<Metadata> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Metadata {
  Metadata({
    this.data,
  });

  Data data;

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.avatar,
    this.name,
    this.username,
    this.createdAt,
    this.heartCount,
    this.ctaType,
    this.type,
  });

  String id;
  Avatar avatar;
  String name;
  String username;
  int createdAt;
  String heartCount;
  String ctaType;
  String type;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        avatar: Avatar.fromJson(json["avatar"]),
        name: json["name"],
        username: json["username"],
        createdAt: json["createdAt"],
        heartCount: json["heartCount"],
        ctaType: json["ctaType"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "avatar": avatar.toJson(),
        "name": name,
        "username": username,
        "createdAt": createdAt,
        "heartCount": heartCount,
        "ctaType": ctaType,
        "type": type,
      };
}

class Avatar {
  Avatar({
    this.normal,
  });

  String normal;

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
        normal: json["normal"],
      );

  Map<String, dynamic> toJson() => {
        "normal": normal,
      };
}
