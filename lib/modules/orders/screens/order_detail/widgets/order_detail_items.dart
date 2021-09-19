import 'package:admin_eshop/Helper/Constant.dart';
import 'package:admin_eshop/Helper/String.dart';
import 'package:admin_eshop/config/themes/base_theme_colors.dart';
import 'package:admin_eshop/modules/orders/models/order.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OrderDetailScreenOrderItems extends StatelessWidget {
  final List<OrderItem> orderItems;

  const OrderDetailScreenOrderItems({Key? key, required this.orderItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: orderItems.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        OrderItem orderItem = orderItems[i];
        return Card(
            elevation: 0,
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // ClipRRect(
                        //     borderRadius: BorderRadius.circular(10.0),
                        //     child: FadeInImage(
                        //       fadeInDuration: Duration(milliseconds: 150),
                        //       image: NetworkImage(orderItem.image!),
                        //       height: 90.0,
                        //       width: 90.0,
                        //       placeholder: placeHolder(90),
                        //     )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  orderItem.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(color: lightBlack, fontWeight: FontWeight.normal),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(children: [
                                  Text(
                                    QUANTITY_LBL + ":",
                                    style: Theme.of(context).textTheme.subtitle2!.copyWith(color: lightBlack2),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.0),
                                    child: Text(
                                      orderItem.quantity.toString(),
                                      style: Theme.of(context).textTheme.subtitle2!.copyWith(color: lightBlack),
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    CUR_CURRENCY + " " + orderItem.totalItemPrice.toString(),
                                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: fontColor),
                                  ),
                                ]),
                                SizedBox(height: 1.0.h),
                                if (orderItem.selectedAddonCats.length > 0)
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: orderItem.selectedAddonCats.length,
                                      itemBuilder: (context, index) {
                                        final addonCat = orderItem.selectedAddonCats[index];
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("  - ${addonCat.name}"),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: addonCat.selectedOptions.length,
                                                itemBuilder: (context, index) {
                                                  final addonOpt = addonCat.selectedOptions[index];
                                                  return Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text("    + ${addonOpt.name}"),
                                                      Text("${CUR_CURRENCY} ${addonOpt.price.toStringAsFixed(2)}"),
                                                    ],
                                                  );
                                                })
                                          ],
                                        );
                                      }),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                )));
      },
    );
  }
}
