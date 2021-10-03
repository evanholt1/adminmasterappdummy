import 'package:admin_eshop/Helper/confirmation_dialog.dart';
import 'package:admin_eshop/modules/orders/enums/order_status.dart';
import 'package:admin_eshop/modules/orders/providers/order_list_provider.dart';
import 'package:admin_eshop/modules/orders/repositories/order_repo.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderDetailScreenStatusButton extends StatelessWidget {
  const OrderDetailScreenStatusButton({
    Key? key,
    required this.currStatus,
    required this.orderId,
    this.cancelled,
  }) : super(key: key);

  final String orderId;
  final OrderStatus currStatus;
  final bool? cancelled;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0.w,
      height: 7.0.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: _getColor(cancelled)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () async {
          if (this.cancelled != null && this.cancelled == true) {
            showConfirmationDialog(
              context: context,
              onYes: () async {
                await OrdersRepository.changeOrderStatus(orderId,
                    isCancelled: true);
                context.read<OrderListProvider>().removeOrderFromList(orderId);
                Navigator.of(context).pop();
              },
              text: AppLocalizations.of(context)!.confirm_cancel_order,
            );
          } else {
            await OrdersRepository.changeOrderStatus(orderId,
                isCancelled: false);
            context.read<OrderListProvider>().removeOrderFromList(orderId);
            Navigator.of(context).pop();
          }
        },
        child: Text(
          _getText(context, currStatus, this.cancelled),
          style: TextStyle(
              fontSize: 13.0.sp,
              fontWeight: FontWeight.bold,
              color: _getColor(cancelled)),
          textAlign: TextAlign.center,
        ),
      ),
    );

    // return ElevatedButton(
    //   onPressed: () {},
    //   child: Text(_getText(this.currStatus, this.cancelled)),
    // );
  }

  _getText(BuildContext context, OrderStatus currStatus, [bool? isCancelled]) {
    if (isCancelled != null && isCancelled == true)
      return AppLocalizations.of(context)!.cancel_order;
    if (currStatus == OrderStatus.pending)
      return AppLocalizations.of(context)!.accept_order;
    if (currStatus == OrderStatus.preparing)
      return AppLocalizations.of(context)!.finish_preparation;
  }

  Color _getColor(bool? isCancelled) {
    if (isCancelled != null && isCancelled == true)
      return Colors.red;
    else
      return Colors.blue;
  }
}
