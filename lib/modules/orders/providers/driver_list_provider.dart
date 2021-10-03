import 'dart:convert';

import 'package:admin_eshop/Models/driver.dart';
import 'package:admin_eshop/constants/ApiPaths.dart';
import 'package:admin_eshop/modules/orders/repositories/order_repo.dart';
import 'package:admin_eshop/utils/services/RestApiService.dart';
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
    availableDrivers = await OrdersRepository.getDrivers();
    loading = false;
    print("AD are $availableDrivers");
    notifyListeners();
  }

  endLoading() async {
    await Future.delayed(Duration(seconds: 1));
    loading = false;
    notifyListeners();
  }
}
