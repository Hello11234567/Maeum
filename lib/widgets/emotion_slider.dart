// 감정 입력 화면에서 사용하는 슬라이더 컴포넌트
// emotionName: 감정 이름 (기쁨, 화남 등)
// emoji: 감정 이모지
// value: 현재 슬라이더 값 (0.0 ~ 10.0)
// color: 감정별 색상
// onChanged: 슬라이더 값 변경 시 실행할 함수

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';

class EmotionSlider extends StatelessWidget {
  final String emotionName;
  final String emoji;
  final double value;
  final Color color;
  final ValueChanged<double> onChanged;

  const EmotionSlider({
    super.key,
    required this.emotionName,
    required this.emoji,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          SizedBox(
            width: 28,
            child: Text(emotionName, style: AppTextStyle.body2),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: color,
                inactiveTrackColor: AppColors.border,
                thumbColor: color,
                trackHeight: 4,
              ),
              child: Slider(
                value: value,
                min: 0,
                max: 10,
                onChanged: onChanged,
              ),
            ),
          ),
          SizedBox(
            width: 24,
            child: Text(
              value.toInt().toString(),
              style: AppTextStyle.body2,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}