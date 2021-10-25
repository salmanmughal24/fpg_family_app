// To parse this JSON data, do
//
//     final channel = channelFromJson(jsonString);

import 'dart:convert';

Channel channelFromJson(String str) => Channel.fromJson(json.decode(str));

String channelToJson(Channel data) => json.encode(data.toJson());

class Channel {
  Channel({
    required this.title,
    required this.url,
    required this.thumbnail,
  });

  String title;
  String url;
  String thumbnail;

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
    title: json["title"],
    url: json["url"],
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "url": url,
    "thumbnail": thumbnail,
  };
}
