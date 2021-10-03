import 'package:admin_eshop/common/blocs/locale/locale_cubit.dart';
import 'package:admin_eshop/common/providers/socket_provider.dart';
import 'package:admin_eshop/constants/AppRoutes.dart';
import 'package:admin_eshop/modules/orders/providers/order_list_provider.dart';
import 'package:admin_eshop/modules/orders/providers/selected_order_tab_provider.dart';
import 'package:admin_eshop/utils/services/shared_preferences_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'Helper/Constant.dart';
import 'Helper/PushNotificationService.dart';
import 'config/themes/base_theme_colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
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
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
  final sharedPref = await SharedPreferences.getInstance();
  LocaleCubit.initial(SharedPreferenceService(sharedPref).instance);
  // status bar color
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: lightWhite));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SelectedOrderTabProvider>(
            create: (_) => SelectedOrderTabProvider(), lazy: false),
        ChangeNotifierProvider<OrderListProvider>(
            create: (context) => OrderListProvider(
                context.read<SelectedOrderTabProvider>().selectedTab),
            lazy: false),
        ChangeNotifierProvider<SocketProvider>(
          create: (context) => SocketProvider(context.read<OrderListProvider>(),
              context.read<SelectedOrderTabProvider>()),
          lazy: false,
        ),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) => MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', ''), // English, no country code
            Locale('ar', ''), // Spanish, no country code
          ],
          title: appName,
          theme: ThemeData(
              primarySwatch: primary_app,
              fontFamily: 'opensans',
              visualDensity: VisualDensity.adaptivePlatformDensity),
          debugShowCheckedModeBanner: false,
          routes: AppRoutes.routesMap,
        ),
      ),
    );
  }
}
