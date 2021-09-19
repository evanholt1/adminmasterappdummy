import 'package:admin_eshop/Helper/Constant.dart';
import 'package:admin_eshop/Helper/String.dart';
import 'package:admin_eshop/config/themes/base_theme_colors.dart';
import 'package:admin_eshop/modules/main/screens/home/widgets/Drawer/HomeScreenDrawerDivider.dart';
import 'package:admin_eshop/modules/main/screens/home/widgets/Drawer/HomeScreenDrawerHeader.dart';
import 'package:admin_eshop/modules/main/screens/home/widgets/Drawer/HomeScreenDrawerItem.dart';
import 'package:flutter/material.dart';

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          color: AppColors.white,
          child: ListView(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              HomeScreenDrawerHeader(),
              Divider(),
              HomeScreenDrawerItem(0, HOME_LBL, Icons.home_outlined),
              HomeScreenDrawerItem(7, ORDER, Icons.shopping_cart),
              HomeScreenDrawerItem(5, PRO_LBL, Icons.dashboard),
              HomeScreenDrawerItem(2, Del_LBL, Icons.directions_bike),
              HomeScreenDrawerItem(3, CUST_LBL, Icons.group),
              ticketRead ? HomeScreenDrawerItem(4, TICKET_LBL, Icons.support_agent) : Container(),
              HomeScreenDrawerDivider(),
              HomeScreenDrawerItem(8, PRIVACY, Icons.lock_outline),
              HomeScreenDrawerItem(9, TERM, Icons.speaker_notes_outlined),
              CUR_USERID == "" || CUR_USERID == null ? Container() : HomeScreenDrawerDivider(),
              CUR_USERID == "" || CUR_USERID == null ? Container() : HomeScreenDrawerItem(11, LOGOUT, Icons.input),
            ],
          ),
        ),
      ),
    );
  }
}
