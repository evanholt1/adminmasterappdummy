import 'package:admin_eshop/Models/AddonCategory.dart';
import 'package:admin_eshop/Models/LocalizedText.dart';
import 'package:equatable/equatable.dart';

class DBProduct extends Equatable {
  final String id;
  final LocalizedText name;
  final LocalizedText description;
  final String category;
  final String? subcategory;
  final String? brand;
  final num price;
  final num discountValue;
  final String imageUrl;
  final List<AddonCategory> addonsByCat;
  final num salesCount;
  final bool isRecommended;
  final List<String> itemPhotos;
  final num rating;
  final int ratingCount;
  final bool isActive;

  DBProduct(
      {required this.id,
      required this.name,
      required this.description,
      required this.category,
      this.subcategory,
      this.brand,
      required this.price,
      required this.discountValue,
      required this.imageUrl,
      required this.addonsByCat,
      required this.salesCount,
      required this.isRecommended,
      required this.itemPhotos,
      required this.rating,
      required this.ratingCount,
      required this.isActive});

  @override
  List<Object> get props => [id];

  @override
  bool get stringify => true;

  toJson() => {
        "_id": this.id,
        "name": this.name,
        "description": this.description,
        "category": this.category,
        "subcategory": this.subcategory,
        "brand": this.brand,
        "price": this.price,
        "discountValue": this.discountValue,
        "image_url": this.imageUrl,
        "addonsByCat": this.addonsByCat,
        'salesCount': this.salesCount,
        "isRecommended": this.isRecommended,
        "item_photos": this.itemPhotos,
        "rating": this.rating,
        "rating_count": this.ratingCount,
        "isActive": this.isActive,
      };

  DBProduct.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.name = LocalizedText.fromJson(json['name']),
        this.description = LocalizedText.fromJson(json['description']),
        this.category = json['category'],
        this.subcategory = json['subcategory'],
        this.brand = json['brand'],
        this.price = json['price'],
        this.discountValue = json['discountValue'],
        this.imageUrl = json['image_url'],
        this.addonsByCat =
            AddonCategory.addonCategoriesFromJson(json['addonsByCat'] as List),
        this.salesCount = json['salesCount'],
        this.isRecommended = json['isRecommended'],
        this.itemPhotos = (json['item_photos'] as List).cast<String>(),
        this.rating = json['rating'],
        this.ratingCount = json['rating_count'],
        this.isActive = json['isActive'] {
    print(json);
  }

  static List<DBProduct> productsFromJson(List json) =>
      json.map((e) => DBProduct.fromJson(e)).toList();

  static DBProduct copy(DBProduct product) {
    return DBProduct(
        id: product.id,
        name: LocalizedText.copy(product.name),
        description: LocalizedText.copy(product.description),
        category: product.category,
        subcategory: product.subcategory,
        brand: product.brand,
        price: product.price,
        discountValue: product.discountValue,
        imageUrl: product.imageUrl,
        addonsByCat: AddonCategory.copyList(product.addonsByCat),
        salesCount: product.salesCount,
        isRecommended: product.isRecommended,
        itemPhotos: List.of(product.itemPhotos),
        rating: product.rating,
        ratingCount: product.ratingCount,
        isActive: product.isActive);
  }
}
