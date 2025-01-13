import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  Future<void> initnotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission();

    String? token = await messaging.getToken();
    print("FCM Token: $token");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message while in the foreground: ${message.messageId}');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');

    print('Notifications title........${message.notification!.title}');
  }
}
