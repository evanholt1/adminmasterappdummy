import 'dart:convert';

import 'package:admin_eshop/constants/ApiPaths.dart';
import 'package:admin_eshop/modules/product/models/Category.dart';
import 'package:admin_eshop/utils/services/RestApiService.dart';

class ProductListRepository {
  Future<List<ProductCategory>> getProductList() async {
    final res = await RestApiService.get(ApiPaths.categoriesWithItems);

    if (res.statusCode == 200) {
      print((jsonDecode(res.body) as List)[1]);
      return ProductCategory.categoryListFromJson(jsonDecode(res.body) as List);
    } else {
      throw res.body;
    }
  }
}
