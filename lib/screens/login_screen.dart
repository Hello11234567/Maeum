// 카카오 로그인 화면
// 앱 실행 시 가장 먼저 보이는 화면
// 카카오 로그인 버튼 클릭 시 AuthService.kakaoLogin() 호출
// 로그인 성공 시 메인 화면으로 이동

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _kakaoLogin() async {
    setState(() => _isLoading = true);
    final success = await _authService.kakaoLogin();
    setState(() => _isLoading = true);

    if (success && mounted) {
      // 로그인 성공 시 메인 화면으로 이동 (나중에 연결)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              //로고 영역
              Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                      ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
              ),
              const SizedBox(height: 20),
              Text('마음이', style: AppTextStyle.heading1),
              const SizedBox(height: 8),
              Text(
                '오늘은 마음이 어떠신가요?',
                style: AppTextStyle.body2,
              ),
              const Spacer(flex: 2),

              //카카오 로그인 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _kakaoLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEE500),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('💬 '),
                      Text(
                        '카카오로 시작하기',
                        style: AppTextStyle.button.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}