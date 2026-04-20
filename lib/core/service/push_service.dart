import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

// 백그라운드 메시지 핸들러 (앱이 종료된 상태에서 푸시 수신 시 호출)
// Background message handler (called when push arrives while app is terminated)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[PushService] background message: ${message.messageId}');
}

// Firebase Cloud Messaging 푸시 알림 서비스
// Firebase Cloud Messaging push notification service
class PushService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // 푸시 서비스 초기화: 백그라운드 핸들러 등록 및 리스너 설정
  // Initialize push service: register background handler and set up listeners
  Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 포그라운드 알림 표시 옵션 설정
    // Configure foreground notification display options
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 앱이 포그라운드일 때 메시지 수신 리스너
    // Listener for messages received while app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('[PushService] onMessage: ${message.messageId}');
    });

    // 알림을 탭해서 앱을 열었을 때 리스너
    // Listener for when user taps notification to open app
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('[PushService] onMessageOpenedApp: ${message.messageId}');
    });

    // 앱이 종료된 상태에서 알림으로 열린 경우 초기 메시지 확인
    // Check initial message if app was opened from a terminated state via notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('[PushService] getInitialMessage: ${initialMessage.messageId}');
    }
  }

  // 푸시 알림 권한 요청
  // Request push notification permission from the user
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final granted = settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
    debugPrint('[PushService] permission: ${settings.authorizationStatus}');
    return granted;
  }

  // FCM 토큰 가져오기 (iOS는 APNs 토큰을 먼저 확인)
  // Get FCM token (on iOS, checks APNs token first)
  Future<String?> getToken() async {
    if (Platform.isIOS) {
      // iOS에서 APNs 토큰이 없으면 FCM 토큰도 사용할 수 없음
      // On iOS, FCM token is unavailable without an APNs token
      final apnsToken = await _messaging.getAPNSToken();
      if (apnsToken == null) {
        debugPrint('[PushService] APNs token not available');
        return null;
      }
    }
    final token = await _messaging.getToken();
    debugPrint('[PushService] FCM token: $token');
    return token;
  }

  // FCM 토큰 갱신 스트림
  // Stream that emits new FCM token whenever it refreshes
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;
}
