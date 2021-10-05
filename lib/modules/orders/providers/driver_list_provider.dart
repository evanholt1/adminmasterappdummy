import 'dart:convert';

import 'package:admin_eshop/Models/driver.dart';
import 'package:admin_eshop/modules/orders/repositories/order_repo.dart';
import 'package:flutter/cupertino.dart';

class DriverListProvider extends ChangeNotifier {
  bool loading = true;
  List<Driver> availableDrivers = [];

  DriverListProvider() {
    getDrivers();
  }

  startLoading() {
    loading = true;
    notifyListeners();
  }

  Future<void> getDrivers() async {
    availableDrivers =
        await OrdersRepository.getDrivers("613b525a9547087c44a8247b");
    loading = false;
    notifyListeners();
  }

  endLoading() async {
    await Future.delayed(Duration(seconds: 1));
    loading = false;
    notifyListeners();
  }

  // if clicking on driver assignment, but he's now already inactive
  void removeDriverAndGetDrivers(Driver driver) {
    loading = true;
    notifyListeners();
    availableDrivers.removeWhere((element) => element.id == driver.id);
    this.getDrivers();
  }
}
