import 'package:flutter/cupertino.dart';

class SelectedProductCategoryProvider extends ChangeNotifier {
  late int selectedCatIndex;

  SelectedProductCategoryProvider([int? initialSelected]) {
    this.selectedCatIndex = initialSelected ?? 0;
  }

  selectCat(int index) {
    this.selectedCatIndex = index;
    notifyListeners();
  }
}
