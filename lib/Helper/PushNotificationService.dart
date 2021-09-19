import 'dart:convert';
import 'dart:io';

import 'package:admin_eshop/modules/orders/screens/order_list/OrderList.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../Chat.dart';
import '../main.dart';
import 'Constant.dart';
import 'Session.dart';
import 'String.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
FirebaseMessaging messaging = FirebaseMessaging.instance;

class PushNotificationService {
  final BuildContext context;

  // final Function updateHome;

  PushNotificationService({required this.context});

  Future initialise() async {
    iOSPermission();
    messaging.getToken().then((token) async {
      CUR_USERID = (await getPrefrence(ID)) ?? "";
      if (CUR_USERID != null && CUR_USERID != "") _registerToken(token!);
    });

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notifcation_icon');
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
    final MacOSInitializationSettings initializationSettingsMacOS = MacOSInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: initializationSettingsMacOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      var data = message.notification;
      var title = data!.title.toString();
      var body = data.body.toString();
      var image = message.data['image'] ?? '';

      var type = message.data['type'] ?? '';
      var id = '';
      id = message.data['type_id'] ?? '';

      if (type == "ticket_message") {
        if (CUR_TICK_ID == id) {
          if (chatstreamdata != null) {
            var parsedJson = json.decode(message.data['chat']);
            parsedJson = parsedJson[0];

            Map<String, dynamic> sendata = {
              "id": parsedJson[ID],
              "title": parsedJson[TITLE],
              "message": parsedJson[MESSAGE],
              "user_id": parsedJson[USER_ID],
              "name": parsedJson[NAME],
              "date_created": parsedJson[DATE_CREATED],
              "attachments": parsedJson["attachments"]
            };
            var chat = {};

            chat["data"] = sendata;
            if (parsedJson[USER_ID] != CUR_USERID) chatstreamdata.sink.add(jsonEncode(chat));
          }
        } else {
          if (image != null && image != 'null' && image != '') {
            generateImageNotication(title, body, image, type, id);
          } else {
            generateSimpleNotication(title, body, type, id);
          }
        }
      } else if (image != null && image != 'null' && image != '') {
        generateImageNotication(title, body, image, type, id);
      } else {
        generateSimpleNotication(title, body, type, id);
      }
    });

    messaging.getInitialMessage().then((RemoteMessage? message) async {
      bool back = await getPrefrenceBool(ISFROMBACK);

      if (message != null && back) {
        var type = message.data['type'] ?? '';
        var id = '';
        id = message.data['type_id'] ?? '';

        getStatics(type, id);

        setPrefrenceBool(ISFROMBACK, false);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      //  bool back = await getPrefrenceBool(ISFROMBACK, "open");

      if (message != null) {
        var type = message.data['type'] ?? '';
        var id = '';

        id = message.data['type_id'] ?? '';

        if (type == "ticket_message") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      id: id,
                      status: "",
                    )),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderList()),
          );
        }

        setPrefrenceBool(ISFROMBACK, false);
      }
    });
  }

  Future<Null> getStatics(String type, String id) async {
    CUR_USERID = (await getPrefrence(ID))!;

    var parameter = {USER_ID: CUR_USERID};

    Response response =
        await post(getStaticsApi, body: parameter, headers: headers).timeout(Duration(seconds: timeOut));

    if (response.statusCode == 200) {
      var getdata = json.decode(response.body);
      bool error = getdata["error"];
      String msg = getdata["message"];
      if (!error) {
        CUR_CURRENCY = getdata["currency_symbol"];

        readOrder = getdata["permissions"]["orders"]["read"] == "on" ? true : false;
        editOrder = getdata["permissions"]["orders"]["update"] == "on" ? true : false;
        deleteOrder = getdata["permissions"]["orders"]["delete"] == "on" ? true : false;

        readProduct = getdata["permissions"]["product"]["read"] == "on" ? true : false;
        editProduct = getdata["permissions"]["product"]["update"] == "on" ? true : false;
        deletProduct = getdata["permissions"]["product"]["delete"] == "on" ? true : false;

        ticketRead = getdata["permissions"]["support_tickets"]["read"] == "on" ? true : false;

        ticketWrite = getdata["permissions"]["support_tickets"]["update"] == "on" ? true : false;

        readCust = getdata["permissions"]["customers"]["read"] == "on" ? true : false;
        readDel = getdata["permissions"]["delivery_boy"]["read"] == "on" ? true : false;

        if (type == "ticket_message") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      id: id,
                      status: "",
                    )),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderList()),
          );
        }
      }
    }
  }

  void iOSPermission() async {
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _registerToken(String token) async {
    var parameter = {USER_ID: CUR_USERID, FCM_ID: token};

    Response response = await post(updateFcmApi, body: parameter, headers: headers).timeout(Duration(seconds: timeOut));

    var getdata = json.decode(response.body);
  }

  Future<void> onSelectNotification(String? payload) async {
    if (payload != null) {
      List<String> pay = payload.split(",");

      if (pay[0] == "ticket_message")
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Chat(
                    id: pay[1],
                    status: "",
                  )),
        );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    }
  }
}

Future<dynamic> myForgroundMessageHandler(RemoteMessage message) async {
  await setPrefrenceBool(ISFROMBACK, true);
  bool back = await getPrefrenceBool(ISFROMBACK);
  return Future<void>.value();
}

Future<String> _downloadAndSaveImage(String url, String fileName) async {
  var directory = await getApplicationDocumentsDirectory();
  var filePath = '${directory.path}/$fileName';
  var response = await http.get(Uri.parse(url));

  var file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

Future<void> generateImageNotication(String title, String msg, String image, String type, String id) async {
  var largeIconPath = await _downloadAndSaveImage(image, 'largeIcon');
  var bigPicturePath = await _downloadAndSaveImage(image, 'bigPicture');
  var bigPictureStyleInformation = BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
      summaryText: msg,
      htmlFormatSummaryText: true);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'big text channel id', 'big text channel name', 'big text channel description',
      largeIcon: FilePathAndroidBitmap(largeIconPath), styleInformation: bigPictureStyleInformation);
  var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, title, msg, platformChannelSpecifics, payload: type + "," + id);
}

Future<void> generateSimpleNotication(String title, String msg, String type, String id) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.max, priority: Priority.high, ticker: 'ticker');
  var iosDetail = IOSNotificationDetails();

  var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosDetail);
  await flutterLocalNotificationsPlugin.show(0, title, msg, platformChannelSpecifics, payload: type + "," + id);
}
