// AI 분석 결과 카드 컴포넌트
// title: 카드 제목 (분석 요약 / 케어 추천)
// content: 카드 내용
// dotColor: 카드 타이틀 앞 색상 점

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';

class AiCard extends StatelessWidget {
  final String title;
  final Widget content;
  final Color dotColor;

  const AiCard({
    super.key,
    required this.title,
    required this.content,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(title, style: AppTextStyle.caption),
            ],
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }
}