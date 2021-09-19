import 'package:admin_eshop/Login.dart';
import 'package:admin_eshop/modules/main/screens/home/HomeScreen.dart';
import 'package:admin_eshop/modules/main/screens/splash/SplashScreen.dart';
import 'package:flutter/widgets.dart';

class AppRoutes {
  static const slash = '/';
  static const home = '/home';
  static const login = '/login';

  static final Map<String, Widget Function(BuildContext)> routesMap = {
    slash: (_) => SplashScreen(),
    home: (_) => HomeScreen(),
    login: (_) => Login(),
  };
}

class AppRouteNames {}
