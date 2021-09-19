import 'package:admin_eshop/Helper/Constant.dart';
import 'package:admin_eshop/Helper/Session.dart';
import 'package:admin_eshop/Login.dart';
import 'package:admin_eshop/config/themes/base_theme_colors.dart';
import 'package:flutter/material.dart';

class HomeScreenLogoutDialog extends StatelessWidget {
  final BuildContext parentContext;
  const HomeScreenLogoutDialog({Key? key, required this.parentContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setStater) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
        content: Text(
          LOGOUTTXT,
          style: Theme.of(this.parentContext).textTheme.subtitle1!.copyWith(color: fontColor),
        ),
        actions: <Widget>[
          new TextButton(
              child: Text(LOGOUTNO,
                  style: Theme.of(this.parentContext)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: lightBlack, fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.of(context).pop(false)),
          new TextButton(
              child: Text(LOGOUTYES,
                  style: Theme.of(this.parentContext)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: fontColor, fontWeight: FontWeight.bold)),
              onPressed: () {
                clearUserSession();
                Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
              })
        ],
      );
    });
  }
}
