import 'dart:convert';

import 'package:admin_eshop/constants/ApiPaths.dart';
import 'package:admin_eshop/modules/category/models/category.dart';
import 'package:admin_eshop/utils/services/RestApiService.dart';

class CategoriesRepository {
  static Future<List<Category>> getCategories() async {
    final res = await RestApiService.get(ApiPaths.allCategories);

    if (res.statusCode == 200) {
      return Category.listFromJson(jsonDecode(res.body) as List);
    } else {
      throw res.body;
    }
  }
}
