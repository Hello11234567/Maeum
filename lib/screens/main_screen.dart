// 메인 캘린더 화면
// 로그인 후 가장 먼저 보이는 화면
// 월별 캘린더에 감정 이모지 표시
// 날짜 클릭 시 감정 입력 화면으로 이동
// 날짜 길게 클릭 시 AI 분석 결과 화면으로 이동

import 'package:flutter/material.dart';
import 'package:maeum/screens/ai_result_screen.dart';
import 'package:maeum/screens/emoji_select_screen.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';
import '../widgets/calendar_cell.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime _currentMonth = DateTime.now();

  //날짜별 내 이모지 저장(백엔드 연결 시 서버에서 불러오도록 수정)
  final Map<String, String> _myEmojis = {};

  //해당 월의 날짜 목록 생성
  List<DateTime?> _getDaysInMonth() {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstWeekday = firstDay.weekday % 7; //일요일 = 0

    List<DateTime?> days = [];

    //이전 달 날짜 채우기
    for (int i = firstWeekday - 1; i >= 0; i--) {
      days.add(DateTime(_currentMonth.year, _currentMonth.month, -i));
    }

    //이번 달 날짜
    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(_currentMonth.year, _currentMonth.month, i));
    }

    //다음 달 날짜 채우기 (7의 배수로 맞추기)
    int remaining = 7 - (days.length % 7);
    if (remaining < 7) {
      for (int i = 1; i <= remaining; i++) {
        days.add(DateTime(_currentMonth.year, _currentMonth.month + 1, i));
      }
    }

    return days;
  }

  void _previouseMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth();

    //화면 높이 가져오기
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            //헤더
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_currentMonth.year}년 ${_currentMonth.month}월',
                        style: AppTextStyle.heading2,
                      ),
                      Text('이번 달 감정 기록', style: AppTextStyle.body2),
                    ],
                  ),
                  //프로필 아바타 (나중에 실제 이미지로 교체)
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            //월 이동 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _previouseMonth,
                    icon: const Icon(Icons.chevron_left),
                    color: AppColors.textSecondary,
                  ),
                  IconButton(
                    onPressed: _nextMonth,
                    icon: const Icon(Icons.chevron_right),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),

            //요일 헤더
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: ['일', '월', '화', '수', '목', '금', '토']
                    .map(
                      (day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: AppTextStyle.caption.copyWith(
                              color: day == '일'
                                  ? Colors.red[300]
                                  : day == '토'
                                  ? Colors.blue[300]
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),

            //캘린더 그리드
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: (screenWidth / 7) / (screenHeight * 0.13),
                  ),
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    final date = days[index];
                    if (date == null) return const SizedBox();
                    return CalendarCell(
                      day: date.day,
                      isToday: _isToday(date),
                      isCurrentMonth: date.month == _currentMonth.month,
                      myEmoji:
                          _myEmojis[date.toIso8601String().substring(0, 10)],
                      onTap: () async {
                        final result = await showModalBottomSheet<String>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: AppColors.background,
                          builder: (context) =>
                              EmojiSelectScreen(selectedDate: date),
                        );
                        //백엔드 연결 시 서버에 저장하도록 수정
                        if (result != null) {
                          setState(() {
                            _myEmojis[date.toIso8601String().substring(0, 10)] =
                                result;
                          });
                        }
                      },
                      onLongPress: () {
                        //백엔드 연결 시 실제 데이터로 교체
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AiResultScreen(
                              mode: 'view',
                              date: date,
                              joy: 0,
                              anger: 0,
                              anxiety: 0,
                              peace: 0,
                              sadness: 0,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
