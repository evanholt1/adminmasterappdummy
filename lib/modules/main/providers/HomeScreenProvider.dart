import 'dart:math';

import 'package:flutter/cupertino.dart';

class HomeScreenProvider extends ChangeNotifier {
  int _touchedIndex = -1;

  int get touchedIndex => _touchedIndex;

  set touchedIndex(int touchedIndex) {
    _touchedIndex = touchedIndex;
    notifyListeners();
  }

  List<Color> _colorList = [];

  List<Color> get colorList => _colorList;

  set colorList(List<Color> colorList) {
    _colorList = colorList;
    notifyListeners();
  }

  setColorList() {
    final List<Color> colorsList = [];
    for (int i = 0; i < catList.length; i++) colorsList.add(_generateRandomColorForColorList());
    this.colorList = colorsList;
  }

  Color _generateRandomColorForColorList() {
    Random random = Random();
    double randomDouble = random.nextDouble();
    return Color((randomDouble * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  List catCountList = [], catList = [];
}
