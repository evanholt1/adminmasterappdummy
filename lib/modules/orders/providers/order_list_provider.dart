import 'package:admin_eshop/modules/orders/enums/order_status.dart';
import 'package:admin_eshop/modules/orders/models/order.dart';
import 'package:admin_eshop/modules/orders/repositories/order_repo.dart';
import 'package:flutter/cupertino.dart';

class OrderListProvider extends ChangeNotifier {
  late List<Order> orderList;
  bool loading = true;

  OrderListProvider(int initialSelectedTab) {
    getOrderList(initialSelectedTab);
  }

  void getOrderList([int selectedTab = 0]) async {
    orderList = await OrdersRepository.getOrderList(
        status: OrderStatus.values[selectedTab]);
    loading = false;
    notifyListeners();
  }

  void removeOrderFromList(String orderId) {
    orderList.removeWhere((element) => element.id == orderId);
    notifyListeners();
  }

  void removeOrdersFromList(List<String> orderIds) {
    orderList.removeWhere((element) => orderIds.contains(element.id));
    notifyListeners();
  }

  void addOrder(Order order) {
    this.orderList.add(order);
    notifyListeners();
  }

  void addOrders(List<Order> orders) {
    this.orderList.addAll(orders);
    notifyListeners();
  }

  void clearList() {
    orderList.clear();
    notifyListeners();
  }

  void getAllOrders() async {
    orderList = await OrdersRepository.getAllOrders();
    loading = false;
    notifyListeners();
  }
}
