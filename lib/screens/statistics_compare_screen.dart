// 통계 비교 화면
// 이번주 vs 지난주 또는 이번달 vs 지난달
// 감정별 막대 비교
// AI 변화 요약
// 백엔드 연결 시 실제 데이터로 교체

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';

class StatisticsCompareScreen extends StatelessWidget {
  final bool isWeekly;

  const StatisticsCompareScreen({super.key, required this.isWeekly});

  @override
  Widget build(BuildContext context) {
    //백엔드 연결 시 실제 데이터로 교체
    final currentData = {
      'joy': 7.2,
      'anger': 3.0,
      'anxiety': 3.4,
      'peace': 6.8,
      'sadness': 2.1,
    };

    final previousData = {
      'joy': 5.8,
      'anger': 4.5,
      'anxiety': 5.2,
      'peace': 6.0,
      'sadness': 2.1,
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isWeekly ? '지난주와 비교' : '지난달과 비교',
          style: AppTextStyle.heading3,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //범례
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  //범례
                  Row(
                    children: [
                      _legendItem(
                        '이번 ${isWeekly ? '주' : '달'}',
                        AppColors.primary,
                      ),
                      const SizedBox(width: 16),
                      _legendItem(
                        '지난 ${isWeekly ? '주' : '달'}',
                        AppColors.border,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // 감정별 비교
                  _compareRow(
                    '😊',
                    '기쁨',
                    currentData['joy']!,
                    previousData['joy']!,
                  ),
                  _compareRow(
                    '😌',
                    '평안',
                    currentData['peace']!,
                    previousData['peace']!,
                  ),
                  _compareRow(
                    '😤',
                    '화남',
                    currentData['anger']!,
                    previousData['anger']!,
                  ),
                  _compareRow(
                    '😰',
                    '불안',
                    currentData['anxiety']!,
                    previousData['anxiety']!,
                  ),
                  _compareRow(
                    '😔',
                    '슬픔',
                    currentData['sadness']!,
                    previousData['sadness']!,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            //AI 변화 요약
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.secondary.withValues(alpha: 0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'AI',
                          style: AppTextStyle.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        '${isWeekly ? '지난주' : '지난달'} 대비 변화',
                        style: AppTextStyle.body2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  //백엔드 연결 시 실제 AI 요약으로 교체
                  Text(
                    isWeekly
                        ? '지난주보다 기쁨·평안이 오르고 화남·불안이 줄었어요. 이 흐름 계속 이어가봐요 :)'
                        : '지난달보다 전반적으로 좋아졌어요! 불안과 화남이 크게 줄었네요 :)',
                    style: AppTextStyle.body2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyle.caption),
      ],
    );
  }

  Widget _compareRow(
    String emoji,
    String name,
    double current,
    double previous,
  ) {
    final diff = current - previous;
    final isUp = diff > 0;
    final isEq = diff == 0;

    // 기쁨, 평안은 올라가면 좋은 것 → 초록
    // 화남, 불안, 슬픔은 내려가면 좋은 것 → 초록
    final isPositive = (name == '기쁨' || name == '평안') ? isUp : !isUp;

    Color _getEmotionColor(String name) {
      switch (name) {
        case '기쁨': return AppColors.joy;
        case '평안': return AppColors.peace;
        case '화남': return AppColors.anger;
        case '불안': return AppColors.anxiety;
        case '슬픔': return AppColors.sadness;
        default: return AppColors.primary;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 17)),
          const SizedBox(width: 6),
          SizedBox(width: 28, child: Text(name, style: AppTextStyle.body2)),
          Expanded(
            child: Column(
              children: [
                //이번주/달
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: current / 10,
                          backgroundColor: AppColors.border,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getEmotionColor(name),
                          ),
                          minHeight: 7,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 24,
                      child: Text(
                        current.toStringAsFixed(1),
                        style: AppTextStyle.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                //지난주/달
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: previous / 10,
                          backgroundColor: AppColors.border,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getEmotionColor(name).withValues(alpha: 0.35),
                          ),
                          minHeight: 7,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 24,
                      child: Text(
                        previous.toStringAsFixed(1),
                        style: AppTextStyle.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),

          //증감 배지
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: isEq
                  ? AppColors.background
                  : isPositive
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isEq
                  ? '→ 0'
                  : '${isUp ? '↑' : '↓'} ${diff.abs().toStringAsFixed(1)}',
              style: AppTextStyle.caption.copyWith(
                color: isEq
                    ? AppColors.textSecondary
                    : isPositive
                    ? Colors.green[600]
                    : Colors.red[400],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
