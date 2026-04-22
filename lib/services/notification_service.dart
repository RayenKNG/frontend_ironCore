import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  // ── Initialize ───────────────────────────────────────────
  Future<void> init() async {
    // Request permission (iOS + Android 13+)
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Local notification channel (Android)
    const androidChannel = AndroidNotificationChannel(
      'ironcore_channel',
      'IronCore Notifications',
      description: 'Notifikasi promo, pesanan, dan restock produk.',
      importance: Importance.high,
    );

    await _localNotif
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // Init local notifications
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _localNotif.initialize(initSettings);

    // Foreground message handler
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background / terminated tap handler
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Get token for backend registration
    final token = await _fcm.getToken();
    debugPrintToken(token);
  }

  // ── Handle foreground message ────────────────────────────
  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotif.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'ironcore_channel',
          'IronCore Notifications',
          channelDescription: 'Notifikasi IronCore Gym Store',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data['route'],
    );
  }

  // ── Handle notification tap ──────────────────────────────
  void _handleNotificationTap(RemoteMessage message) {
    // TODO: navigate based on message.data['route']
  }

  // ── Subscribe to topic ───────────────────────────────────
  Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(topic);
  }

  void debugPrintToken(String? token) {
    // ignore: avoid_print
    print('[FCM Token]: $token');
  }
}
