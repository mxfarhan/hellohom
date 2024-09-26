import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotification = FlutterLocalNotificationsPlugin();

  // Android Notification Channel
  final AndroidNotificationChannel _androidNotificationChannel = AndroidNotificationChannel(
    'hellohome',
    'Hellohome Notifications',
    description: 'This is a notification channel for hellohome bell',
    importance: Importance.high,
  );

  Future<void> initNotifications() async {
    // Request permission for iOS
    await _firebaseMessaging.requestPermission();

    // Get FCM token
    final fcmToken = await _firebaseMessaging.getToken();
    if (kDebugMode) {
      print("FCM Token: $fcmToken");
    }

    // Initialize push notifications and local notifications
    await initLocalNotification();
    await initPushNotifications();
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Background Message: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');
    // Add your background message handling logic here
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    // Handle the message (navigate or show dialog, etc.)
  }

  Future<void> initLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotification.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
          final message = RemoteMessage.fromMap(jsonDecode(response.payload!));
          handleMessage(message);
        });

    final platform = _localNotification.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await platform?.createNotificationChannel(_androidNotificationChannel);
  }

  Future<void> initPushNotifications() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      // Show local notification
      _localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidNotificationChannel.id,
            _androidNotificationChannel.name,
            channelDescription: _androidNotificationChannel.description,
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker',
            icon: 'app_icon',
          ),
          iOS: DarwinNotificationDetails(), // Updated for iOS
        ),
        payload: jsonEncode(message.toMap()),
      );
    });

    // Handle when the app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message);
    });

    // This handles messages when the app is in the background
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
