import 'package:admin_eshop/Models/AddonCategory.dart';
import 'package:admin_eshop/Models/LocalizedText.dart';
import 'package:admin_eshop/modules/product/models/DBProduct.dart';
import 'package:equatable/equatable.dart';

class DBProductEdit extends Equatable {
  LocalizedText? name;
  LocalizedText? description;
  String? category;
  String? subcategory;
  String? brand;
  num? price;
  num? discountValue;
  String? imageUrl;
  List<AddonCategory>? addonsByCat;
  num? salesCount;
  bool? isRecommended;
  List<String>? itemPhotos;
  num? rating;
  int? ratingCount;
  bool? isActive;

  DBProductEdit(
      {this.name,
      this.description,
      this.category,
      this.subcategory,
      this.brand,
      this.price,
      this.discountValue,
      this.imageUrl,
      this.addonsByCat,
      this.salesCount,
      this.isRecommended,
      this.itemPhotos,
      this.rating,
      this.ratingCount,
      this.isActive});

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;

  toJson() => {
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

  static DBProductEdit fromDBProduct(DBProduct product) {
    return DBProductEdit(
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
