import 'package:admin_eshop/Helper/confirmation_dialog.dart';
import 'package:admin_eshop/modules/orders/providers/order_list_provider.dart';
import 'package:admin_eshop/modules/orders/providers/selected_order_tab_provider.dart';
import 'package:admin_eshop/modules/orders/repositories/order_repo.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class OrdersListScreenDialog extends StatelessWidget {
  const OrdersListScreenDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.orders_settings),
      content: Container(
        width: 75.0.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton(
              onPressed: () async {
                await showConfirmationDialog(
                    context: context,
                    onYes: () async {
                      await OrdersRepository.startNewDay();
                      context.read<OrderListProvider>().clearList();
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    text: AppLocalizations.of(context)!.confirm_new_day);
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.start_new_day,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 2.0.h),
            OutlinedButton(
              onPressed: () {
                context.read<OrderListProvider>().getAllOrders();
                context.read<SelectedOrderTabProvider>().selectedTab = 6;
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.get_all_orders,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
