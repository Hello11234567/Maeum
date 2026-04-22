// 통계 화면에서 감정 평균을 보여주는 가로 막대 그래프 컴포넌트
// emotionName: 감정 이름
// emoji: 감정 이모지
// value: 평균 수치 (0.0 ~ 10.0)
// color: 막대 색상

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';

class EmotionBarChart extends StatelessWidget {
  final String emotionName;
  final String emoji;
  final double value;
  final Color color;

  const EmotionBarChart({
    super.key,
    required this.emotionName,
    required this.emoji,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          SizedBox(
            width: 28,
            child: Text(emotionName, style: AppTextStyle.body2),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value / 10,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 10,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 28,
            child: Text(
              value.toStringAsFixed(1),
              style: AppTextStyle.body2.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}