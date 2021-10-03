import 'package:admin_eshop/modules/category/models/category.dart';
import 'package:admin_eshop/modules/category/repositories/categories_repository.dart';
import 'package:admin_eshop/modules/product/models/Category.dart';
import 'package:flutter/cupertino.dart';

class CategoriesListProvider extends ChangeNotifier {
  late List<Category> categories;
  bool loading = true;

  CategoriesListProvider() {
    _getCategoriesList();
  }

  Future<void> _getCategoriesList() async {
    categories = await CategoriesRepository.getCategories();
    loading = false;
    notifyListeners();
  }
}
