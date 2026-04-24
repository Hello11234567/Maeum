// 메인 캘린더에서 날짜 하나를 표시하는 셀 컴포넌트
// day: 날짜 숫자
// isToday: 오늘 날짜 여부 (true면 강조 표시)
// isCurrentMonth: 현재 달 날짜 여부 (false면 연하게 표시)
// myEmoji: 사용자가 직접 선택한 이모지
// aiEmoji: AI가 분석한 대표 이모지
// onTap: 날짜 셀 클릭 시 실행할 함수

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';

class CalendarCell extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isCurrentMonth;
  final String? myEmoji;
  final String? aiEmoji;
  final VoidCallback onTap;

  const CalendarCell({
    super.key,
    required this.day,
    required this.isToday,
    this.isCurrentMonth = true,
    this.myEmoji,
    this.aiEmoji,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            SizedBox(
              height: 20,
              child: Text(
                day.toString(),
                style: AppTextStyle.caption.copyWith(
                  color: isToday
                      ? AppColors.primary
                      : isCurrentMonth
                      ? AppColors.textPrimary
                      : AppColors.textSecondary.withValues(alpha: 0.4),
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                  fontSize: isToday ? 14 : null,
                ),
              ),
            ),
            //내 이모지
            if (myEmoji != null)
              Text(myEmoji!, style: const TextStyle(fontSize: 11)),
            //AI 이모지 (✨로 구분)
            if (aiEmoji != null)
              Text('✨${aiEmoji!}', style: const TextStyle(fontSize: 9)),
          ],
        )
      ),
    );
  }
}
