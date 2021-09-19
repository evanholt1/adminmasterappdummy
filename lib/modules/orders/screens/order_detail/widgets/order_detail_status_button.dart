import 'package:admin_eshop/modules/orders/enums/order_status.dart';
import 'package:admin_eshop/modules/orders/repositories/order_repo.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
          final isCancelled = this.cancelled != null && this.cancelled == true ? true : false;
          await OrdersRepository.changeOrderStatus(orderId, isCancelled: isCancelled);
          //context.read<OrderListProvider>().removeOrderFromList(orderId);
          Navigator.of(context).pop();
        },
        child: Text(
          _getText(currStatus, this.cancelled),
          style: TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.bold, color: _getColor(cancelled)),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return ElevatedButton(
      onPressed: () {},
      child: Text(_getText(this.currStatus, this.cancelled)),
    );
  }

  _getText(OrderStatus currStatus, [bool? isCancelled]) {
    if (isCancelled != null && isCancelled == true) return "Cancel Order";
    if (currStatus == OrderStatus.pending) return "Accept Order";
    if (currStatus == OrderStatus.preparing) return "Finish Preparation";
  }

  Color _getColor(bool? isCancelled) {
    if (isCancelled != null && isCancelled == true)
      return Colors.red;
    else
      return Colors.blue;
  }
}
