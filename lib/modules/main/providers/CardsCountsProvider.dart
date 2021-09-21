import 'package:admin_eshop/modules/main/models/StoreCounts.dart';
import 'package:admin_eshop/modules/main/repos/CardsCountsRepository.dart';
import 'package:flutter/material.dart';

class CardsCountsProvider extends ChangeNotifier {
  ///todo: keep only this field
  late final StoreCounts storeCounts;

  // int orderCount;
  // int productCount;
  // int custCount;
  // int delBoyCount;
  // int soldOutCount;
  bool loading;

  CardsCountsProvider() : this.loading = true {
    _getCounts();
  }

  _getCounts() async {
    this.storeCounts = await CardsCountsRepository.getCounts();
    print("storeCounts is $storeCounts");

    loading = false;
    notifyListeners();
  }
}
