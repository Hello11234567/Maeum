// 앱 시작 시 가장 먼저 보이는 스플래시 화면
// 2초간 로고와 앱 이름 표시
// 로그인 여부 확인 후 로그인 화면 또는 메인 화면으로 이동

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
    _checkLoginAndNavigate();
  }

  Future<void> _checkLoginAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final isLoggedIn = await _authService.isLoggedIn();
    if (!mounted) return;

    if (isLoggedIn) {
      //Refresh Token으로 Access Token 자동 재발급
      try {
        final storage = const FlutterSecureStorage();
        final refreshToken = await storage.read(key: 'refresh_token');

        await ApiService.dio.post(
          '/auth/refresh',
          options: Options(headers: {'Refresh-Token': refreshToken}),
        );

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/main');
      } catch (e) {
        //재발급 실패 -> 로그인 화면
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //로고
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 24),
                Text('마음이', style: AppTextStyle.heading1),
                const SizedBox(height: 8),
                Text('오늘은 마음이 어떠신가요?', style: AppTextStyle.body2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
