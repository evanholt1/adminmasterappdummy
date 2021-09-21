import 'dart:convert';

import 'package:admin_eshop/constants/ApiPaths.dart';
import 'package:admin_eshop/modules/orders/enums/order_status.dart';
import 'package:admin_eshop/modules/orders/models/order.dart';
import 'package:admin_eshop/utils/services/RestApiService.dart';

class OrdersRepository {
  static Future<List<Order>> getOrderList({OrderStatus? status}) async {
    const queryParams = {"lang_code": "en"};
    if (status != null) queryParams.putIfAbsent("status", () => status.index.toString());
    final res = await RestApiService.get(ApiPaths.ordersToday, queryParams);

    if (res.statusCode == 200) {
      print("paylaod is ${((jsonDecode(res.body) as List)[0])['driver']} ${((jsonDecode(res.body) as List)[0])['driver'].runtimeType}");
      return Order.listFromJson(jsonDecode(res.body) as List);
    } else {
      throw res.body;
    }
  }

  static Future<void> changeOrderStatus(String orderId, {bool? isCancelled}) async {
    final Map<String,dynamic> payload = {"order": orderId};
    if (isCancelled != null && isCancelled == true) payload.putIfAbsent("cancelled", () => true);
    final res = await RestApiService.post(ApiPaths.updateOrderStatus, jsonEncode(payload));

    if (res.statusCode == 201 || res.statusCode == 200)
      return;
    else
      throw res.body;
  }
}
