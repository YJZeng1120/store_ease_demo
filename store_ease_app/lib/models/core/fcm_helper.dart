import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHelper {
  static late FirebaseMessaging fcm;

  static Future<void> init() async {
    fcm = FirebaseMessaging.instance;
  }

  // Get FCM Token
  static Future<String?> getFcmToken() async {
    await fcm.requestPermission();
    final token = await fcm.getToken();
    return token;
  }

  // Delete FCM Token
  static Future deleteFcmToken() async {
    await fcm.deleteToken();
  }
}
