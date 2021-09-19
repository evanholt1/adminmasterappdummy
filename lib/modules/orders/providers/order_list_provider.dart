import 'package:admin_eshop/modules/orders/models/order.dart';
import 'package:admin_eshop/modules/orders/repositories/order_repo.dart';
import 'package:flutter/cupertino.dart';

class OrderListProvider extends ChangeNotifier {
  late List<Order> orderList;
  bool loading = true;

  OrderListProvider() {
    _getOrderList();
  }

  void _getOrderList() async {
    orderList = await OrdersRepository.getOrderList();
    loading = false;
    notifyListeners();
  }

  void removeOrderFromList(String orderId) {
    orderList.removeWhere((element) => element.id == orderId);
    notifyListeners();
  }
}
