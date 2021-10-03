import 'dart:convert';

import 'package:admin_eshop/Models/driver.dart';
import 'package:admin_eshop/constants/ApiPaths.dart';
import 'package:admin_eshop/modules/orders/enums/order_status.dart';
import 'package:admin_eshop/modules/orders/models/order.dart';
import 'package:admin_eshop/utils/services/RestApiService.dart';

class OrdersRepository {
  static Future<List<Order>> getOrderList({OrderStatus? status}) async {
    final queryParams = {"lang_code": "en"};
    if (status != null)
      queryParams.putIfAbsent("status", () => status.index.toString());
    final res = await RestApiService.get(ApiPaths.ordersToday, queryParams);

    if (res.statusCode == 200) {
      return Order.listFromJson(jsonDecode(res.body) as List);
    } else {
      throw res.body;
    }
  }

  static Future<List<Order>> getAllOrders() async {
    final queryParams = {"lang_code": "en"};

    final res = await RestApiService.get(ApiPaths.allBranchOrders, queryParams);

    if (res.statusCode == 200) {
      return Order.listFromJson(jsonDecode(res.body) as List);
    } else {
      throw res.body;
    }
  }

  static Future<void> changeOrderStatus(String orderId,
      {bool? isCancelled}) async {
    final Map<String, dynamic> payload = {"order": orderId};
    if (isCancelled != null && isCancelled == true)
      payload.putIfAbsent("cancelled", () => true);
    final res = await RestApiService.post(
        ApiPaths.updateOrderStatus, jsonEncode(payload));

    if (res.statusCode == 201 || res.statusCode == 200)
      return;
    else
      throw res.body;
  }

  static Future<void> startNewDay() async {
    final res = await RestApiService.post(ApiPaths.currentDay);
    if (res.statusCode == 201)
      return;
    else
      throw res.body;
  }

  static Future<void> assignDriver(String orderId, String driverId) async {
    final payload = {"order": orderId, "driver": driverId};
    final res =
        await RestApiService.post(ApiPaths.assignDriver, jsonEncode(payload));
    if (res.statusCode == 201)
      return;
    else
      throw res.body;
  }

  static Future<void> clearDriver(String orderId) async {
    final payload = {"order": orderId};
    final res =
        await RestApiService.post(ApiPaths.clearDriver, jsonEncode(payload));
    if (res.statusCode == 201)
      return;
    else
      throw res.body;
  }

  static Future<List<Driver>> getDrivers() async {
    final res = await RestApiService.get(ApiPaths.availableDrivers);

    if (res.statusCode == 200) {
      return Driver.listFromJson(jsonDecode(res.body) as List);
    } else
      throw res.body;
  }
}
