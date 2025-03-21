// import 'dart:math';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/screens/MarksAndResults/Parent_MarksandResults.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class FirebaseApi {
//   Future<void> initnotification() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;

//     final FlutterLocalNotificationsPlugin _flutternotificationplugin =
//         FlutterLocalNotificationsPlugin();

// //
//     void initlocalnotification(
//         BuildContext context, RemoteMessage message) async {
//       var androidInitializationsettings =
//           AndroidInitializationSettings('@mipmap-mdpi/ic_launcher.png');

//       var initializesetting =
//           InitializationSettings(android: androidInitializationsettings);

//       await _flutternotificationplugin.initialize(initializesetting,
//           onDidReceiveBackgroundNotificationResponse: (payload) {});
//     }
//     //

//     await messaging.requestPermission();

//     String? token = await messaging.getToken();
//     print("FCM Token: $token");

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       //
//       shownotification(message);

//       print('Received a message while in the foreground: ${message.messageId}');
//     });

//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }

//   //
//   Future<void> shownotification(RemoteMessage message) async {
//     // Future.delayed(Duration.zero, _flutternotificationplugin.show(message.notification!.title));

//     AndroidNotificationDetails androidNotificationDetails =AndroidNotificationDetails(channel.);
//   }

//   static Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     print('Handling a background message: ${message.messageId}');

//     print('Notifications title........${message.notification!.title}');
//   }
// }
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initnotification() async {
    // Request permission for push notifications
    await _messaging.requestPermission();

    // Get and print the FCM token
    String? token = await _messaging.getToken();
    print("FCM Token: $token");

    // Initialize local notifications
    await _initLocalNotifications();

    // Handle messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received: ${message.notification?.title}");
      if (message.notification != null) {
        _showNotification(message);
      }
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(initializationSettings);
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      Random().nextInt(1000), // Unique notification ID
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      notificationDetails,
    );
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling background message: ${message.messageId}");
  }
}
