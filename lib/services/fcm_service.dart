import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await _messaging.requestPermission();

    final token = await _messaging.getToken();
    print("FCM Token: $token");

    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null && token != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).set(
        {
          'fcmToken': token,
          'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      final refreshedUid = FirebaseAuth.instance.currentUser?.uid;

      if (refreshedUid != null) {
        await FirebaseFirestore.instance.collection('users').doc(refreshedUid).set(
          {
            'fcmToken': newToken,
            'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message: ${message.notification?.title}");
      print("Message body: ${message.notification?.body}");
    });
  }
}