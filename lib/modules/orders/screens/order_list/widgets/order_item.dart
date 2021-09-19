import 'package:admin_eshop/Helper/Session.dart';
import 'package:admin_eshop/config/themes/base_theme_colors.dart';
import 'package:admin_eshop/modules/orders/enums/order_status.dart';
import 'package:admin_eshop/modules/orders/models/order.dart';
import 'package:admin_eshop/modules/orders/providers/order_list_provider.dart';
import 'package:admin_eshop/modules/orders/screens/order_detail/OrderDetail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderListScreenOrder extends StatelessWidget {
  const OrderListScreenOrder({Key? key, required this.order}) : super(key: key);

  final Order order;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(5.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Order #" + order.displayId),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                          color: this._getBgColor(order.status),
                          borderRadius: new BorderRadius.all(const Radius.circular(4.0))),
                      child: Text(
                        capitalize(describeEnum(order.status)),
                        style: TextStyle(color: white),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 14),
                          Expanded(
                            child: Text(order.username, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                    if (order.userPhoneNumber != null)
                      InkWell(
                        child: Row(
                          children: [
                            Icon(Icons.call, size: 14, color: fontColor),
                            Text(
                              " " + order.userPhoneNumber!,
                              style: TextStyle(color: fontColor, decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                        onTap: () {
                          //  _launchCaller(index);
                        },
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.money, size: 14),
                        Text("Price: " + "JD" + " " + order.totalPrice.toString()),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(Icons.payment, size: 14),
                        Text(" " + order.paymentType),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    Icon(Icons.date_range, size: 14),
                    Text("Date: " + DateFormat('yyyy-MM-dd – hh:mm a').format(order.orderDate)),
                  ],
                ),
              )
            ])),
        onTap: () async {
          ///
          final prov = context.read<OrderListProvider>();
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider<OrderListProvider>.value(
                    value: prov, child: OrderDetailsScreen(order: order))),
          );
        },
      ),
    );
  }

  _getBgColor(OrderStatus orderStatus) {
    Color back;
    if ((orderStatus) == OrderStatus.delivered)
      back = Colors.green;
    else if (orderStatus == OrderStatus.delivering)
      back = Colors.orange;
    else if (orderStatus == OrderStatus.cancelled)
      back = Colors.red;
    else if (orderStatus == OrderStatus.prepared)
      back = Colors.indigo;
    else if (orderStatus == OrderStatus.pending)
      back = Colors.black;
    else
      back = Colors.cyan;

    return back;
  }
}
