import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:foodly/main.dart';
import 'package:foodly/services/activity_service.dart';
import 'package:foodly/services/user_services.dart';
import 'package:intl/intl.dart';
import 'package:foodly/config/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodly/model/activity.dart';
import 'package:foodly/services/main_model.dart';
import 'package:foodly/config/text_style.dart';
import 'package:foodly/view/chats/chat_page.dart';
import 'package:scoped_model/scoped_model.dart';

import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../model/chat.dart';
import '../config/constant.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

mixin SocketService on Model, UserService {
  // static StreamController<Chat>? _socketResponse;

  List<Chat> _chatList = [];
  List<Chat> get chatList => _chatList;

  static StreamController<Chat>? _socketBellResponse;
  static StreamController<List<String>>? _userResponse;
  static io.Socket? _socket;
  static io.Socket? _socketBell;
  static String _userName = '';

  static String? get userId => _socket!.id;

  // static Stream<Chat> get getResponse =>
  //     _socketResponse!.stream.asBroadcastStream();
  static Stream<Chat> get getResponseBell =>
      _socketBellResponse!.stream.asBroadcastStream();

  static Stream<List<String>> get userResponse =>
      _userResponse!.stream.asBroadcastStream();

  static void setUserName(String name) {
    _userName = name;
  }

  static void sendMessage(String message, MainModel model, Activity activity) {
    _socket!.emit(
        'send_message',
        Chat(
            userId: model.user.id.toString(),
            message: message,
            room: activity.roomId,
            date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            time: DateFormat.Hms().format(DateTime.now())));
  }

  static void sendFeedbackBell(var data) {
    _socketBell!.emit('feedback_bell', {
      "id_staff": data['id_staff'],
      "message": data['message'],
      "idRoomBell": data['idRoomBell'],
      "datetime": DateFormat('EEEE / dd/MM/yyyy HH:mm').format(DateTime.now()),
      "name": data['name'],
      "idRoomForChat": data['idRoomForChat']
    });
  }

  // void connectAndListen(MainModel model) {
  //   // _socketResponse = StreamController<Chat>();
  //   _userResponse = StreamController<List<String>>();
  //   _socket = io.io(
  //       Constant.serverUrl,
  //       io.OptionBuilder()
  //           .setTransports(['websocket', 'polling']) // for Flutter or Dart VM
  //           .disableAutoConnect()
  //           // .setQuery({'userName': _userName})
  //           .build());

  //   _socket!.connect();

  //   // debugPrint(_socketResponse!.isClosed);
  //   debugPrint("connecting...");

  //   // // When an event recieved from server, data is added to the stream
  //   _socket!.emit('room_listen_chat', model.uid);

  //   //When an event recieved from server, data is added to the stream
  //   _socket!.on('listen_chat', (data) async {
  //     debugdebugPrint("listen_chat: $data");
  //     // _chatList.add(Chat.fromRawJson(data));
  //     // notifyListeners();

  //     //
  //     await model.fetchActivities();
  //   });

  //   // _socket!.onDisconnect((_) => debugPrint('disconnect'));
  // }

  void connectAndListenChat(MainModel model, Activity activity) {
    // _socketResponse = StreamController<Chat>();
    _userResponse = StreamController<List<String>>();
    _socket = io.io(
        Constant.serverUrl,
        io.OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .enableForceNew() // for Flutter or Dart VM
            .disableAutoConnect()
            // .setQuery({'userName': _userName})
            .build());

    _socket!.connect();

    // debugPrint(_socketResponse!.isClosed);
    print("connecting...");

    // // When an event recieved from server, data is added to the stream
    _socket!.emit('join_room', activity.roomId);
    debugPrint("${_socket!.id}");

    //When an event recieved from server, data is added to the stream
    _socket!.on('receive_message', (data) async {
      debugPrint("receive_message: $data");
      if (!_chatList.any((chat) => chat == Chat.fromRawJson(data))) {
        _chatList.add(Chat.fromRawJson(data));
        notifyListeners();
      }
      //
      // await model.fetchActivities();
    });
    //When an event recieved from server, data is added to the stream
    _socket!.on('mydata', (data) {
      debugPrint("mydata: $data");
      // _socketResponse!.sink.add(Chat.fromRawJson(data));
      _chatList.add(Chat.fromRawJson(data));
      notifyListeners();
    });

    _socket!.onDisconnect((_) => print('disconnect'));
  }

  static void connectAndListenBell(
      BuildContext context, int uid, MainModel model) {
    _socketBellResponse = StreamController<Chat>();
    _socketBell = io.io(
        Constant.serverUrl,
        io.OptionBuilder()
            // .enableReconnection()
            // .enableForceNewConnection()
            .enableAutoConnect()
            .setTransports(['websocket', 'polling']) // for Flutter or Dart VM
            // .disableAutoConnect()
            // .setQuery({'userName': _userName})
            .build());

    print(_socketBellResponse!.isClosed);
    // // When an event recieved from server, data is added to the stream
    _socketBell!.emit('room_bell', uid);
    debugPrint("user ID: $uid");

    //When an event recieved from server, data is added to the stream
    _socketBell!.on('bellrings', (data) async {
      // await scheduleNotificationRealisasi(data);
      debugPrint("bellrings: $data");

      _showModalBottomSheet(context, data, model);
      //
      await model.fetchActivities();
    });
    //When an event recieved from server, data is added to the stream
    _socketBell!.on('receiveTest', (data) async {
      debugPrint("receiveTest: $data");
    });
// Replace 'onConnect' with any of the above events.
    _socketBell!.onConnect((_) {
      print('connect');
    });
    // _socketBell!.disconnect()..connect();
    _socketBell?.onDisconnect((_) => print('disconnect'));
  }

  static void _showModalBottomSheet(context, dynamic data, MainModel model) {
    showModalBottomSheet(
        backgroundColor: ConstColors.whiteFontColor,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        builder: (BuildContext bc) {
          return FractionallySizedBox(
            heightFactor: model.user.roles == "STAFF" ||
                    model.user.roles == "USER" ||
                    model.user.roles == "OWNER" &&
                        model.user.jumlahHariExpired! == 0
                ? 0.68
                : 0.78,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: new Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 7,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)))),
                          SizedBox(height: 20),
                          Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                // color: ConstColors.primaryColor,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red,
                                    Colors.red.withOpacity(0.7),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  // begin:
                                  //     Alignment.topLeft, //begin of the gradient color
                                  // end: Alignment
                                  //     .bottomRight, //end of the gradient color
                                  // stops: [0, 0.2, 0.5, 0.8]
                                ),
                                borderRadius: BorderRadius.circular(100)),
                            child: SvgPicture.asset(
                              'assets/icons/Web and Technology/alarm.svg',

                              // height: 10,
                              color: ConstColors.whiteFontColor,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text('NEW',
                                  style: pRegular14.copyWith(
                                      fontSize: 11,
                                      color: ConstColors.whiteFontColor))),
                          SizedBox(height: 15),
                          Container(
                              // padding: EdgeInsets.symmetric(
                              //     horizontal: 10, vertical: 4),
                              // decoration: BoxDecoration(
                              // color: Colors.grey[300],
                              // borderRadius: BorderRadius.circular(5)),
                              child: Text("Quelqu'un SONNE",
                                  style: pSemiBold18.copyWith(
                                      fontSize: 14,
                                      color: ConstColors.textColor))),
                        ]),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          var body = {
                            'id_staff': data['databell']['id_staff'],
                            'message': "J'ARRIVE",
                            'idRoomBell': data['databell']['idRoomBell'],
                            'name': model.nama,
                            'idRoomForChat': data['databell']['idRoomForChat']
                          };
                          Navigator.of(context).pop();
                          sendFeedbackBell(body);
                        },
                        child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                                // border:
                                //     Border.all(color: ConstColors.primaryColor),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xffA6FF96),
                                    Color(0xffA6FF96).withOpacity(0.7),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  // begin:
                                  //     Alignment.topLeft, //begin of the gradient color
                                  // end: Alignment
                                  //     .bottomRight, //end of the gradient color
                                  // stops: [0, 0.2, 0.5, 0.8]
                                ),
                                color: ConstColors.whiteFontColor,
                                borderRadius: BorderRadius.circular(10)),
                            // padding: EdgeInsets.only(
                            //     left: 20, right: 10, top: 12, bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/Communication/bi-cycle.svg',
                                  // height: 10,
                                  color: ConstColors.whiteFontColor,
                                ),
                                Text(
                                  "J'ARRIVE",
                                  style: pRegular14.copyWith(
                                      fontSize: 14,
                                      color: ConstColors.whiteFontColor),
                                ),
                              ],
                            )),
                      )),
                      SizedBox(width: 20),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          var body = {
                            'id_staff': data['databell']['id_staff'],
                            'message': "JE NE SUIS PAS LA",
                            'idRoomBell': data['databell']['idRoomBell'],
                            'name': model.nama,
                            'idRoomForChat': data['databell']['idRoomForChat']
                          };
                          Navigator.of(context).pop();
                          sendFeedbackBell(body);
                        },
                        child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                                // border:
                                //     Border.all(color: ConstColors.primaryColor),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xffE25E3E),
                                    Color(0xffE25E3E).withOpacity(0.7),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  // begin:
                                  //     Alignment.topLeft, //begin of the gradient color
                                  // end: Alignment
                                  //     .bottomRight, //end of the gradient color
                                  // stops: [0, 0.2, 0.5, 0.8]
                                ),
                                color: ConstColors.whiteFontColor,
                                borderRadius: BorderRadius.circular(10)),
                            // padding: EdgeInsets.only(
                            //     left: 20, right: 10, top: 12, bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/Weather/night.svg',
                                  // height: 10,
                                  color: ConstColors.whiteFontColor,
                                ),
                                Text(
                                  "JE NE SUIS PAS LA",
                                  style: pRegular14.copyWith(
                                      fontSize: 14,
                                      color: ConstColors.whiteFontColor),
                                ),
                              ],
                            )),
                      )),
                    ],
                  ),
                  SizedBox(
                      height: model.user.roles == "STAFF" ||
                              model.user.roles == "USER" ||
                              model.user.roles == "OWNER" &&
                                  model.user.jumlahHariExpired! == 0
                          ? 20
                          : 40),
                  model.user.roles == "STAFF" ||
                          model.user.roles == "USER" ||
                          model.user.roles == "OWNER" &&
                              model.user.jumlahHariExpired! == 0
                      ? SizedBox()
                      : InkWell(
                          onTap: () async {
                            //

                            // if (_socket == null) {
                            //   SocketService.setUserName(model.user.name!);
                            //   model.connectAndListenChat(
                            //       model,
                            //       Activity(
                            //           usersId: data['databell']['id_staff'],
                            //           roomId: data['databell']['idRoomForChat'],
                            //           idRoomForChat: data['databell']['idRoomBell']));
                            //   //

                            // }

                            var body = {
                              'id_staff': data['databell']['id_staff'],
                              'message': "CHAT",
                              'idRoomBell': data['databell']['idRoomBell'],
                              'name': model.nama,
                              'idRoomForChat': data['databell']['idRoomForChat']
                            };
                            Navigator.of(context).pop();
                            sendFeedbackBell(body);
                            //
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => ChatPage(
                                        model,
                                        Activity(
                                            usersId: data['databell']
                                                ['id_staff'],
                                            roomId: data['databell']
                                                ['idRoomForChat'],
                                            idRoomForChat: data['databell']
                                                ['idRoomBell']))));
                          },
                          child: Container(
                            height: 48,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: ConstColors.primaryColor),
                              color: ConstColors.whiteFontColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/Communication/popup.svg',
                                  height: 30,
                                  // color: Colors.white54,
                                  color: ConstColors.primaryColor,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "ECRIRE AU VISITEUR",
                                  style: pSemiBold18.copyWith(
                                    fontSize: 16,
                                    color: ConstColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        });
  }

  static Future _configureSelectNotificationSubject(String? payload) async {
    print('notification payload2: $payload');
    await MyApp.navigatorKey.currentState?.pushNamed("/home");
  }

  static void dispose() {
    _socket!.dispose();
    //_socket!.destroy();
    // _socket!.close();
    // _socket!.disconnect();
    // _socketResponse!.close();
    _userResponse!.close();
  }

  void clearChat() {
    _chatList.clear();
    notifyListeners();
  }
}

class NotificationSetUp {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initializeNotification() async {
    AwesomeNotifications().initialize('resource://drawable/icon', [
      NotificationChannel(
        channelKey: 'high_importance_channel',
        channelName: 'Chat notifications',
        importance: NotificationImportance.Max,
        vibrationPattern: highVibrationPattern,
        soundSource: 'resource://raw/bell',
        channelShowBadge: true,
        defaultRingtoneType: DefaultRingtoneType.Notification,
        playSound: true,
        criticalAlerts: true,
        channelDescription: 'Chat notifications.',
        defaultPrivacy: NotificationPrivacy.Public,
  defaultColor: Colors.deepPurple,
  ledColor: Colors.deepPurple,

      ),
    ]);
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications(
          channelKey: 'high_importance_channel',
          permissions: [
            NotificationPermission.Alert, NotificationPermission.Sound, NotificationPermission.Badge, NotificationPermission.CriticalAlert, NotificationPermission.Vibration
          ]
        );
      }
    });
  }

  void configurePushNotifications(BuildContext context) async {
    initializeNotification();

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,

    );

    if (Platform.isIOS) getIOSPermission();

    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("================");
      print("=========${message.notification!.body}=======");
      print("================");
      if (message.notification != null) {
        print("data notif: ${message.data}");
        createOrderNotifications(
            title: message.notification!.title,
            body: message.notification!.body,
            payload: message.data
                .map((key, value) => MapEntry(key, value.toString())));
      }
    });
  }

  Future<void> createOrderNotifications(
      {String? title, String? body, Map<String, String>? payload}) async {
    // print(payload);
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 0,
            channelKey: 'high_importance_channel',
            title: title,
            body: body,
            criticalAlert: true,
            customSound: 'resource://raw/bell',
            payload: payload));
  }

  void eventListenerCallback(BuildContext context) {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );
  }

  void getIOSPermission() {
    _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
      provisional: false
    );
  }
}

@pragma("vm:entry-point")
Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
    if (kDebugMode) {
      print("body: ${receivedNotification.body}");
    }
    if (kDebugMode) {
      print("title: ${receivedNotification.title}");
    }
    if (kDebugMode) {
      print("data: ${receivedNotification.toMap()}");
    }
    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/home',
      (route) => (route.settings.name != '/notification-page') || route.isFirst,
    );

    ActivityService.getActivities();
   // SocketService._showModalBottomSheet(
    //    MyApp.navigatorKey.currentContext,
      //  receivedNotification.toMap(),
      //  MainModel());
     //_showModalBottomSheet(context, data, model);
  }
}
