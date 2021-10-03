import 'package:admin_eshop/Models/LocalizedText.dart';
import 'package:flutter/foundation.dart';

class Category extends ChangeNotifier {
  final String id;
  final String imageUrl;
  final String iconUrl;
  final LocalizedText name;

  Category(
      {required this.id,
      required this.imageUrl,
      required this.iconUrl,
      required this.name});

  Category.fromJson(Map<String, dynamic> json)
      : this.id = json["_id"],
        this.imageUrl =
            json['imageUrl'] == null ? throw json : json['imageUrl'],
        this.iconUrl = json['icon_url'],
        this.name = LocalizedText.fromJson(json['name']);

  static listFromJson(List json) =>
      json.map((e) => Category.fromJson(e)).toList();
}
