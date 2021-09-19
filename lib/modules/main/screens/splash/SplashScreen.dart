import 'dart:async';

import 'package:admin_eshop/Helper/Session.dart';
import 'package:admin_eshop/Helper/String.dart';
import 'package:admin_eshop/constants/AppAssets.dart';
import 'package:admin_eshop/constants/AppRoutes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    /// todo: remove
    deviceHeight = MediaQuery.of(context).size.height; // set common vars. old un-sizer bad code
    deviceWidth = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: back(),
            child: Center(child: Image.asset(AppAssets.splashImage)),
          ),
          Image.asset(AppAssets.doodle, fit: BoxFit.fill, width: double.infinity, height: double.infinity),
        ],
      ),
    );
  }

  startTimer() async => Timer(Duration(seconds: 2), chooseNextScreen);

  Future<void> chooseNextScreen() async {
    bool isFirstTime = await getPrefrenceBool(isLogin);

    /// note this might have to be flipped
    Navigator.of(context).pushReplacementNamed(isFirstTime ? AppRoutes.login : AppRoutes.home);
  }

  // setSnackbar(String msg) {
  //   ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
  //     content: new Text(
  //       msg,
  //       textAlign: TextAlign.center,
  //       style: TextStyle(color: black),
  //     ),
  //     backgroundColor: white,
  //     elevation: 1.0,
  //   ));
  // }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }
}
