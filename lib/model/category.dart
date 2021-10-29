// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category({
    required this.name,
    required this.id,
    required this.index,
  });

  String name;
  String id;
  int index;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    name: json["name"],
    id: json["id"],
    index: json["index"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "index": index,
  };
}
