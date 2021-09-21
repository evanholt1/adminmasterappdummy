import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketProvider extends ChangeNotifier {
  late Socket socket;

  SocketProvider() {
    print('here');

    /// 10.0.2.2 for emulator..
    socket = io(
        'http://10.0.2.2:3000',
        OptionBuilder()
            .setTransports(['websocket'])
            .setQuery({"role": "Admin", "id": 1})
            .disableForceNewConnection()
            .disableReconnection()
            .build());
    socket.onConnect((_) {
      print('connected');
      // Timer.periodic(Duration(seconds: 2), (timer) {
      //   final data = {"driverId": "611f97e5dd03850016e7ac58"};
      //   socket.emitWithAck('getDriverLocation', data, ack: (data) {
      //     print('driver Location $data');
      //   });
      // });
    });
    socket.onConnectError((data) => print(data));
    socket.onDisconnect((_) => print('disconnect'));

  }
}
