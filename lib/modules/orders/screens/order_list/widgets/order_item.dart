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
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("${AppLocalizations.of(context)!.order} #" +
                        order.displayId),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                          color: this._getBgColor(order.status),
                          borderRadius:
                              new BorderRadius.all(const Radius.circular(4.0))),
                      child: Text(
                        _getStatusText(context, order.status),
                        style: TextStyle(color: white),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 14),
                          Expanded(
                            child: Text(order.username,
                                maxLines: 1, overflow: TextOverflow.ellipsis),
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
                              style: TextStyle(
                                  color: fontColor,
                                  decoration: TextDecoration.underline),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.money, size: 14),
                        Text(AppLocalizations.of(context)!.price +
                            ": " +
                            AppLocalizations.of(context)!.currency_shorthand +
                            " " +
                            order.totalPrice.toStringAsFixed(2)),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    Icon(Icons.date_range, size: 14),
                    Text(AppLocalizations.of(context)!.date +
                        ": " +
                        DateFormat('yyyy-MM-dd – hh:mm a')
                            .format(order.orderDate)),
                  ],
                ),
              ),
              if (order.driver != null) ...[
                //SizedBox(height: 1.0.h),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: Row(
                    children: [
                      Icon(Icons.local_shipping, size: 14),
                      Text(AppLocalizations.of(context)!.driver +
                          ": " +
                          order.driver!.name),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
        onTap: () async {
          ///
          final prov = context.read<OrderListProvider>();
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChangeNotifierProvider<OrderListProvider>.value(
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

  _getStatusText(BuildContext context, OrderStatus orderStatus) {
    switch (orderStatus) {
      case OrderStatus.pending:
        return AppLocalizations.of(context)!.pending_orders;
      case OrderStatus.preparing:
        return AppLocalizations.of(context)!.preparing_orders;
      case OrderStatus.prepared:
        return AppLocalizations.of(context)!.prepared_orders;
      case OrderStatus.delivering:
        return AppLocalizations.of(context)!.delivering_orders;
      case OrderStatus.delivered:
        return AppLocalizations.of(context)!.delivered_orders;
      case OrderStatus.cancelled:
      default:
        return AppLocalizations.of(context)!.cancelled_orders;
    }
  }
}
