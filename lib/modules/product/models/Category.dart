import 'package:admin_eshop/modules/product/models/DBProduct.dart';

class ProductCategory {
  final String id;
  final String? iconUrl;
  final String name;
  final String imageUrl;
  final List<DBProduct> products;

  ProductCategory(
      {required this.id, required this.iconUrl, required this.name, required this.imageUrl, required this.products});

  ProductCategory.fromJson(Map<String, dynamic> json)
      : this.id = json['_id'],
        this.iconUrl = json['icon_url'],
        this.name = (json['name'] as Map).values.first,
        this.imageUrl = json['imageUrl'],
        this.products = DBProduct.productsFromJson(json['items']);

  static categoryListFromJson(List json) => json.map((e) => ProductCategory.fromJson(e)).toList();
}
