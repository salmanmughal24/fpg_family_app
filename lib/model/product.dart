// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    required this.category,
    required this.id,
    this.thumbnail,
    required this.title,
    required this.url,
  });

  String category;
  String id;
  String? thumbnail;
  String title;
  String url;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    category: json["category"],
    id: json["id"],
    thumbnail: json["thumbnail"],
    title: json["title"],
    url: json["url"]??"",
  );

  Map<String, dynamic> toJson() => {
    "category": category,
    "id": id,
    "thumbnail": thumbnail,
    "title": title,
    "url": url,
  };
}
