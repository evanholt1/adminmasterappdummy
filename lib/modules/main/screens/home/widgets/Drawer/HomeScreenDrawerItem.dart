import 'package:admin_eshop/Customer_Support.dart';
import 'package:admin_eshop/DeliveryBoy.dart';
import 'package:admin_eshop/Helper/Constant.dart';
import 'package:admin_eshop/Privacy_Policy.dart';
import 'package:admin_eshop/config/themes/base_theme_colors.dart';
import 'package:admin_eshop/modules/main/blocs/selected_drawer/selected_drawer_cubit.dart';
import 'package:admin_eshop/modules/main/screens/home/widgets/LogoutDialog/HomeScreenLogoutDialog.dart';
import 'package:admin_eshop/modules/orders/screens/order_list/OrderList.dart';
import 'package:admin_eshop/modules/product/screens/product_list/ProductList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreenDrawerItem extends StatefulWidget {
  final int index;
  final String title;
  final IconData icn;

  const HomeScreenDrawerItem(this.index, this.title, this.icn);

  @override
  _HomeScreenDrawerItemState createState() => _HomeScreenDrawerItemState();
}

class _HomeScreenDrawerItemState extends State<HomeScreenDrawerItem> {
  @override
  Widget build(BuildContext context) {
    final currentSelectedDrawer = context.watch<SelectedDrawerCubit>().state;
    return Container(
      margin: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
          gradient: currentSelectedDrawer == widget.index
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [AppColors.secondary.withOpacity(0.2), AppColors.primary.withOpacity(0.2)],
                  stops: [0, 1])
              : null,
          borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50))),
      child: ListTile(
        dense: true,
        leading: Icon(
          widget.icn,
          color: currentSelectedDrawer == widget.index ? primary : lightBlack2,
        ),
        title: Text(
          widget.title,
          style: TextStyle(color: currentSelectedDrawer == widget.index ? primary : lightBlack2, fontSize: 15),
        ),
        onTap: () {
          Navigator.of(context).pop();
          if (widget.title == HOME_LBL) {
            context.read<SelectedDrawerCubit>().selectDrawer(widget.index);
            // setState(() {
            //   //currentSelectedDrawer = widget.index;
            // });
            Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
          } else if (widget.title == NOTIFICATION) {
            context.read<SelectedDrawerCubit>().selectDrawer(widget.index);
            // setState(() {
            //   currentSelectedDrawer = widget.index;
            // });

            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => NotificationList(),
            //     ));
          } else if (widget.title == LOGOUT) {
            _showLogoutDialog();
          } else if (widget.title == TICKET_LBL) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerSupport()));
          } else if (widget.title == PRIVACY) {
            context.read<SelectedDrawerCubit>().selectDrawer(widget.index);
            // setState(() {
            //   currentSelectedDrawer = widget.index;
            // });
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivacyPolicy(
                    title: PRIVACY,
                  ),
                ));
          } else if (widget.title == TERM) {
            context.read<SelectedDrawerCubit>().selectDrawer(widget.index);
            // setState(() {
            //   currentSelectedDrawer = widget.index;
            // });
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivacyPolicy(
                    title: TERM,
                  ),
                ));
          } else if (widget.title == Del_LBL) {
            context.read<SelectedDrawerCubit>().selectDrawer(widget.index);
            // setState(() {
            //   currentSelectedDrawer = widget.index;
            // });
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeliveryBoy(
                    isDelBoy: true,
                  ),
                ));
          } else if (widget.title == CUST_LBL) {
            context.read<SelectedDrawerCubit>().selectDrawer(widget.index);
            // setState(() {
            //   currentSelectedDrawer = widget.index;
            // });
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeliveryBoy(
                    isDelBoy: false,
                  ),
                ));
          } else if (widget.title == PRO_LBL) {
            context.read<SelectedDrawerCubit>().selectDrawer(widget.index);
            // setState(() {
            //   currentSelectedDrawer = widget.index;
            // });
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductList(
                    flag: '',
                  ),
                ));
          } else if (widget.title == ORDER) {
            context.read<SelectedDrawerCubit>().selectDrawer(widget.index);
            // setState(() {
            //   currentSelectedDrawer = widget.index;
            // });
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderListScreen(),
                ));
          }
        },
      ),
    );
  }

  _showLogoutDialog() async {
    showDialog(
        context: context, builder: (BuildContext context) => HomeScreenLogoutDialog(parentContext: this.context));
  }
}
