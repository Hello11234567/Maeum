// AI 분석 로딩 화면
// 분석하기 버튼 누르면 이 화면으로 이동
// 마음이 캐릭터 고민하는 애니메이션 (나중에 Lottie로 교체)
// 분석 완료 후 자동으로 결과 화면으로 이동
// 백엔드 연결 시 실제 OpenAI API 호출

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';
import 'ai_result_screen.dart';

class AiLoadingScreen extends StatefulWidget {
  final double joy;
  final double anger;
  final double anxiety;
  final double peace;
  final double sadness;

  const AiLoadingScreen({
    super.key,
    required this.joy,
    required this.anger,
    required this.anxiety,
    required this.peace,
    required this.sadness,
  });

  @override
  State<AiLoadingScreen> createState() => _AiLoadingScreenState();
}

class _AiLoadingScreenState extends State<AiLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  int _dotCount = 1;

  @override
  void initState() {
    super.initState();

    //캐릭터 통통 튀는 애니메이션
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(
      begin: 0,
      end: -12,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    //점점점 애니메이션
    Future.delayed(const Duration(milliseconds: 500), _animateDots);

    // 백엔드 연결 시 실제 API 호출 후 이동
    // 임시로 3초 후 결과 화면으로 이동
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AiResultScreen(
              joy: widget.joy,
              anger: widget.anger,
              anxiety: widget.anxiety,
              peace: widget.peace,
              sadness: widget.sadness,
            ),
          ),
        );
      }
    });
  }

  void _animateDots() {
    if (!mounted) return;
    setState(() {
      _dotCount = _dotCount % 3 + 1;
    });
    Future.delayed(const Duration(milliseconds: 500), _animateDots);
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //캐릭터 (나중에 Lottie로 교체)
            AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _bounceAnimation.value),
                  child: child,
                );
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.2),
                      AppColors.secondary.withValues(alpha: 0.2),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('🤔', style: const TextStyle(fontSize: 56)),
                ),
              ),
            ),
            const SizedBox(height: 32),

            //말풍선
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                '열심히 분석중이에요!!',
                style: AppTextStyle.body1.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),

            //분석 중 텍스트 + 점점점
            Text('분석중이에요${'.' * _dotCount}', style: AppTextStyle.heading3),
            const SizedBox(height: 8),
            Text(
              '오늘 하루 감정을\n꼼꼼히 살펴보고 있어요 :)',
              style: AppTextStyle.body2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
