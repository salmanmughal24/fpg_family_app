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
    required this.index,
  });

  String title;
  String url;
  String thumbnail;

  int index;

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
    title: json["title"],
    url: json["url"],
    thumbnail: json["thumbnail"],
    index: json["index"]
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "url": url,
    "thumbnail": thumbnail,
    "index":index
  };
}
