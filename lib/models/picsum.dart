// To parse this JSON data, do
//
//     final picsum = picsumFromJson(jsonString);

import 'dart:convert';

List<Picsum> picsumFromJson(String str) =>
    List<Picsum>.from(json.decode(str).map((x) => Picsum.fromJson(x)));

String picsumToJson(List<Picsum> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Picsum {
  Picsum({
    required this.id,
    required this.author,
    required this.width,
    required this.height,
    required this.url,
    required this.downloadUrl,
  });

  final String id;
  final String author;
  final int width;
  final int height;
  final String url;
  final String downloadUrl;

  factory Picsum.fromJson(Map<String, dynamic> json) => Picsum(
        id: json["id"],
        author: json["author"],
        width: json["width"],
        height: json["height"],
        url: json["url"],
        downloadUrl: json["download_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "author": author,
        "width": width,
        "height": height,
        "url": url,
        "download_url": downloadUrl,
      };
}
