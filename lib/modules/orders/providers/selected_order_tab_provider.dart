import 'package:flutter/cupertino.dart';

class SelectedOrderTabProvider extends ChangeNotifier {
  int selectedTab = 0;

  selectTab(int index) {
    selectedTab = index;
    notifyListeners();
  }
}