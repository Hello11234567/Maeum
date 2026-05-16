//FCM 서비스
//FCM 토큰 발급 및 서버 전송
//푸시 알림 수신 처리

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  //FCM 초기화 및 토큰 발급
  Future<String?> initialize() async {
    //알림 권한 요청
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //FCM 토큰 발급
      String? token = await _messaging.getToken();

      return token;
    }
    return null;
  }

  //포그라운드 알림 처리
  void onForegroundMessage(Function(RemoteMessage) handler) {
    FirebaseMessaging.onMessage.listen(handler);
  }

  //백그라운드 알림 클릭 처리
  void onMessageOpenedApp(Function(RemoteMessage) handler) {
    FirebaseMessaging.onMessageOpenedApp.listen(handler);
  }
}
