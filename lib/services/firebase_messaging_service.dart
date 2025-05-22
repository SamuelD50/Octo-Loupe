import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/services/local_notifications_services.dart';

class FirebaseMessagingService {
  FirebaseMessagingService._internal();

  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();

  factory FirebaseMessagingService.instance() => _instance;

  LocalNotificationsService? _localNotificationsService;

  Future<void> init({
    required LocalNotificationsService localNotificationsService
  }) async {
    _localNotificationsService = localNotificationsService;

    await _handlePushNotificationsToken();

    debugPrint('Step 1 passed');

    await _requestPermission();

    debugPrint('Step 2 passed');

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }
  }

  //Function to fetch the token
  Future<void> _handlePushNotificationsToken() async {
    //Know the token
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('Push notifications token: $token');

    //And if the token is refreshed
    FirebaseMessaging.instance.onTokenRefresh
      .listen((fcmToken) {
        debugPrint('FCM token refreshed: $fcmToken');
      }).onError((error) {
        debugPrint('Error refreshing FCM token: $error');
      });
  }

  //Function to request permission
  Future<void> _requestPermission() async {
    final result = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted permission: ${result.authorizationStatus}');
  }

  void _onForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message received: ${message.data.toString()}');
    final notificationData = message.notification;
    if (notificationData != null) {
      _localNotificationsService?.showNotification(
        notificationData.title,
        notificationData.body,
        message.data.toString(),
      );
    }
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint('Notification caused the app to open: ${message.data.toString()}');
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.data.toString()}');
  await LocalNotificationsService.instance().showNotification(
    message.notification?.title,
    message.notification?.body,
    message.data.toString(),
  );
}