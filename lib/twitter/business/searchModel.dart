// To parse this JSON data, do
//
//     final tweetarticle = tweetarticleFromJson(jsonString);

import 'dart:convert';

List<Tweetarticle> tweetarticleFromJson(String str) => List<Tweetarticle>.from(
    json.decode(str).map((x) => Tweetarticle.fromJson(x)));

String tweetarticleToJson(List<Tweetarticle> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tweetarticle {
  Tweetarticle({
    this.show,
    this.phone,
    this.retweetCount,
    this.replyCount,
    this.status,
    this.id,
    this.v,
    this.authorId,
    this.createdAt,
    this.tweetarticleId,
    this.postedAt,
    this.text,
    this.updatedAt,
    this.url,
  });

  bool show;
  List<String> phone;
  int retweetCount;
  int replyCount;
  int status;
  String id;
  int v;
  String authorId;
  DateTime createdAt;
  String tweetarticleId;
  DateTime postedAt;
  String text;
  DateTime updatedAt;
  String url;

  factory Tweetarticle.fromJson(Map<String, dynamic> json) => Tweetarticle(
        show: json["show"],
        phone: List<String>.from(json["phone"].map((x) => x)),
        retweetCount: json["retweetCount"],
        replyCount: json["replyCount"],
        status: json["status"],
        id: json["_id"],
        v: json["__v"],
        authorId: json["authorId"],
        createdAt: DateTime.parse(json["createdAt"]),
        tweetarticleId: json["id"],
        postedAt: DateTime.parse(json["postedAt"]),
        text: json["text"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "show": show,
        "phone": List<dynamic>.from(phone.map((x) => x)),
        "retweetCount": retweetCount,
        "replyCount": replyCount,
        "status": status,
        "_id": id,
        "__v": v,
        "authorId": authorId,
        "createdAt": createdAt.toIso8601String(),
        "id": tweetarticleId,
        "postedAt": postedAt.toIso8601String(),
        "text": text,
        "updatedAt": updatedAt.toIso8601String(),
        "url": url,
      };
}
