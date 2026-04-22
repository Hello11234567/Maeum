// 앱의 시작점
// KakaoSdk 초기화 및 앱 테마 적용
// AppConstants.kakaoNativeAppKey: 카카오 개발자 콘솔에서 발급받은 네이티브 앱 키
// AppTheme.lightTheme: utils/app_theme.dart에서 정의한 전체 테마 적용

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'utils/app_theme.dart';
import 'utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: AppConstants.kakaoNativeAppKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '마음이',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const Scaffold(
        body: Center(
          child: Text('마음이'),
        ),
      ),
    );
  }
}