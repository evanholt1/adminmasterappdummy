import 'package:admin_eshop/common/providers/socket_provider.dart';
import 'package:admin_eshop/constants/AppRoutes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'Helper/Constant.dart';
import 'Helper/PushNotificationService.dart';
import 'config/themes/base_theme_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: true // optional: set false to disable printing logs to console
      );
  FirebaseMessaging.onBackgroundMessage(myForgroundMessageHandler);
  if (!kIsWeb) {
    final channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // status bar color
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: lightWhite));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => MaterialApp(
        title: appName,
        theme: ThemeData(
            primarySwatch: primary_app, fontFamily: 'opensans', visualDensity: VisualDensity.adaptivePlatformDensity),
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.routesMap,
      ),
    );
  }
}
