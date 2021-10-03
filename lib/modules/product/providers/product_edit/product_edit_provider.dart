import 'package:admin_eshop/Models/LocalizedText.dart';
import 'package:admin_eshop/modules/product/models/DBProduct.dart';
import 'package:admin_eshop/modules/product/models/DBProductEdit.dart';
import 'package:flutter/cupertino.dart';

class ProductEditProvider extends ChangeNotifier {
  late DBProductEdit eProduct; //edited
  late DBProduct oProduct; //original

  ProductEditProvider(DBProduct product) {
    this.eProduct = DBProductEdit.fromDBProduct(product);
    this.oProduct = product;
  }

  bool namesAreEqual(bool comparingEnglish) {
    if (comparingEnglish)
      return (eProduct.name?.en ?? oProduct.name.en) == oProduct.name.en;
    return (eProduct.name?.ar ?? oProduct.name.ar) == oProduct.name.ar;
  }

  bool descriptionsAreEqual(bool comparingEnglish) {
    if (comparingEnglish)
      return (eProduct.description?.en ?? oProduct.description.en) ==
          oProduct.description.en;
    return (eProduct.description?.ar ?? oProduct.description.ar) ==
        oProduct.description.ar;
  }

  void updateProductName(String? newName, bool updatingEnglishName) {
    if (newName == null) newName = "";
    if (eProduct.name == null) eProduct.name = LocalizedText.optional();

    if (updatingEnglishName) {
      eProduct.name!.en = newName;
      eProduct.name!.en = namesAreEqual(updatingEnglishName) ? null : newName;
    } else {
      eProduct.name!.ar = newName;
      eProduct.name!.ar = namesAreEqual(updatingEnglishName) ? null : newName;
    }
    notifyListeners();
  }

  void resetName(bool isEnglishField) {
    if (eProduct.name == null) return;

    if (isEnglishField) {
      eProduct.name!.en = null;
      if (eProduct.name!.ar == null) eProduct.name = null;
    } else {
      eProduct.name!.ar = null;
      if (eProduct.name!.en == null) eProduct.name = null;
    }
    notifyListeners();
  }

  void updateProductDesc(String? newDesc, bool updatingEnglishDesc) {
    if (newDesc == null) newDesc = "";
    if (eProduct.description == null)
      eProduct.description = LocalizedText.optional();

    if (updatingEnglishDesc) {
      eProduct.description!.en = newDesc;
      eProduct.description!.en =
          descriptionsAreEqual(updatingEnglishDesc) ? null : newDesc;
    } else {
      eProduct.description!.ar = newDesc;
      eProduct.description!.ar =
          descriptionsAreEqual(updatingEnglishDesc) ? null : newDesc;
    }
    notifyListeners();
  }

  void updateProductPrice(String newPrice) {
    eProduct.price = num.parse(newPrice);
    notifyListeners();
  }
}
