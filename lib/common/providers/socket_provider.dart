import 'dart:async';
import 'dart:convert';

import 'package:admin_eshop/common/blocs/locale/locale_cubit.dart';
import 'package:admin_eshop/modules/orders/enums/order_status.dart';
import 'package:admin_eshop/modules/orders/models/order.dart';
import 'package:admin_eshop/modules/orders/providers/order_list_provider.dart';
import 'package:admin_eshop/modules/orders/providers/selected_order_tab_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketProvider extends ChangeNotifier {
  late Socket socket;
  bool loading = true;
  bool initialized = false;

  OrderListProvider orderListP;
  SelectedOrderTabProvider selectedTabP;

  SocketProvider(this.orderListP, this.selectedTabP);

  Future<void> connect() async {
    if (loading == false) return;

    print("starting socket IO");
    socket = io(
        'https://small-mart.herokuapp.com',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            // optional
            .setQuery({"role": "Admin", "id": "613b525a9547087c44a8247b"})
            .enableForceNewConnection()
            .enableReconnection()
            .enableAutoConnect()
            .build());

    socket.onConnect((_) {
      print('connected !');
      loading = false;
      initialized = true;
      notifyListeners();
    });
    socket.onReconnect((data) {
      print("reconnected !");
    });
    socket.onReconnecting((data) async {
      print("reconnecting to socket server ${data}");

      ///show loading indicator maybe?
      notifyListeners();
    });
    socket.onerror((data) {
      print("socket error ${data}");
      loading = false;
      notifyListeners();
    });
    socket.onDisconnect((_) {
      print('disconnect');
      loading = true;
      initialized = false;
      notifyListeners();
    });
    socket.on("toAdminPendingOrder", (data) {
      if (selectedTabP.selectedTab != OrderStatus.pending.index) return;
      orderListP.addOrder(Order.fromBilingualJson(data));
    });
    socket.on("toAdminDeliveringOrder", (data) {
      if (selectedTabP.selectedTab == OrderStatus.prepared.index)
        orderListP.removeOrderFromList(data['_id']);
      else if (selectedTabP.selectedTab == OrderStatus.delivering.index)
        orderListP.addOrder(Order.fromBilingualJson(data));
    });
    socket.on("toAdminDeliveringOrders", (data) {
      if (selectedTabP.selectedTab == OrderStatus.prepared.index) {
        orderListP.removeOrdersFromList((data as List).map((e) {
          print(e);
          return e['_id'] as String;
        }).toList());
      } else if (selectedTabP.selectedTab == OrderStatus.delivering.index)
        orderListP
            .addOrders(data.map((d) => Order.fromBilingualJson(d)).toList());
    });
    socket.on("toAdminDeliveredOrder", (data) {
      if (selectedTabP.selectedTab == OrderStatus.delivering.index)
        orderListP.removeOrderFromList(data['_id']);
      else if (selectedTabP.selectedTab == OrderStatus.delivered.index)
        orderListP.addOrder(Order.fromBilingualJson(data));
    });
    socket.on("toAdminCancelledOrder", (data) {
      if (selectedTabP.selectedTab == OrderStatus.cancelled.index)
        orderListP.addOrder(Order.fromBilingualJson(data));
      else
        orderListP.removeOrderFromList(data['_id']);
    });
  }

  void disconnect() {
    if (socket != null && socket.connected) socket.disconnect();
  }
}
