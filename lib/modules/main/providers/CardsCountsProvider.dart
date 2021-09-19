import 'package:admin_eshop/modules/main/models/StoreCounts.dart';
import 'package:admin_eshop/modules/main/repos/CardsCountsRepository.dart';
import 'package:flutter/material.dart';

class CardsCountsProvider extends ChangeNotifier {
  late final StoreCounts storeCounts;

  ///todo: keep only this field
  int orderCount;
  int productCount;
  int custCount;
  int delBoyCount;
  int soldOutCount;
  bool loading;

  CardsCountsProvider()
      : this.loading = true,
        this.custCount = 0,
        this.delBoyCount = 0,
        this.orderCount = 0,
        this.productCount = 0,
        this.soldOutCount = 0 {
    _getCounts();
  }

  _getCounts() async {
    this.storeCounts = await CardsCountsRepository.getCounts();
    orderCount = storeCounts.orderCount;
    productCount = storeCounts.productCount;

    loading = false;
    notifyListeners();
  }
}
