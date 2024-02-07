import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../Screens/Home_Screen/Home_Screen_main.dart';
import '../Authentication Section/Database_Authentication/Update User Database/Update_Unique_Device_Token.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Firebase notifications plugin initialization
Future<void> initLocalNotifications(
    BuildContext context, RemoteMessage message, String userid) async {
  // Firebase notifications
  var androidInitializationSettings =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  var InitalizationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );

  await _flutterLocalNotificationsPlugin.initialize(
    InitalizationSettings,
    onDidReceiveNotificationResponse: (payload) {
      handlemessage(context, message, userid);
    },
  );
}

// Request notifications from the flutter local notification
Future<void> requestNotification() async {
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {}
}

void firebaseNotificationInit(BuildContext context, String Userid) async {
  FirebaseMessaging.onMessage.listen(
    (message) {
      initLocalNotifications(context, message, Userid);
      ShowNotification(message);
    },
  );
}

Future<void> ShowNotification(RemoteMessage message) async {
  // Get the notification

  AndroidNotificationChannel channel = AndroidNotificationChannel(
    Random.secure().nextInt(10000).toString(),
    'Echofy New Notification',
    importance: Importance.max,
  );

  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    channel.id.toString(),
    channel.name.toString(),
    channelDescription: 'New Notification',
    importance: Importance.high,
    priority: Priority.high,
    ticker: 'ticker',
  );

  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  Future.delayed(
    Duration.zero,
    () {
      _flutterLocalNotificationsPlugin.show(
        1,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    },
  );
}

Future<String> GetDeviceToken() async {
  String? NotificationToken = await messaging.getToken();
  return NotificationToken!;
}

Future<void> IsTokenRefreshed(String Userid) async {
  messaging.onTokenRefresh.listen(
    (event) {
      UpdateToken(Userid);
    },
  );
}

Future<void> SetUpInteractMessage(BuildContext context, String Userid) async {
  RemoteMessage? InitialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  if (InitialMessage != null) {
    handlemessage(context, InitialMessage, Userid);
  }

  FirebaseMessaging.onMessageOpenedApp.listen(
    (event) {
      handlemessage(context, event, Userid);
    },
  );
}

void handlemessage(BuildContext context, RemoteMessage message, String Userid) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HomeScreen(
        UserId: Userid,
        index: 2,
      ),
    ),
  );
}
