// 통계 화면
// 주간/월간 탭
// AI 한 줄 요약 카드
// 감정 평균 막대 그래프
// 감정 추이 꺾은선 그래프
// 지난주/지난달 비교하기 버튼
// 백엔드 연결 시 실제 데이터로 교체

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';
import '../widgets/bar_chart.dart';
import '../widgets/line_chart.dart';
import 'statistics_compare_screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool _isWeekly = true; //true: 주간, false: 월간

  //백엔드 연결 시 실제 데이터로 교체
  //주간 임시 데이터
  final Map<String, double> _weeklyAvg = {
    'joy': 7.2,
    'anger': 3.0,
    'anxiety': 3.4,
    'peace': 6.8,
    'sadness': 2.1,
  };

  //월간 임시 데이터
  final Map<String, double> _monthlyAvg = {
    'joy': 6.5,
    'anger': 3.8,
    'anxiety': 4.2,
    'peace': 6.2,
    'sadness': 2.8,
  };

  //주간 꺾은선 임시 데이터(월~일)
  final List<List<double>> _weeklyLineData = [
    [7, 6, 8, 7, 9, 7, 8], // 기쁨
    [3, 4, 2, 3, 2, 3, 2], // 화남
    [4, 5, 6, 4, 3, 4, 3], // 불안
    [6, 7, 6, 8, 7, 6, 7], // 평안
    [2, 2, 3, 2, 1, 2, 2], // 슬픔
  ];

  // 월간 꺾은선 임시 데이터 (1~4주)
  final List<List<double>> _monthlyLineData = [
    [5, 6, 7, 8], // 기쁨
    [5, 4, 3, 3], // 화남
    [7, 5, 4, 3], // 불안
    [5, 6, 7, 7], // 평안
    [4, 3, 2, 2], // 슬픔
  ];

  Map<String, double> get _currentAvg => _isWeekly ? _weeklyAvg : _monthlyAvg;

  List<List<double>> get _currentLineData =>
      _isWeekly ? _weeklyLineData : _monthlyLineData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('감정 통계', style: AppTextStyle.heading3),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //주간/월간 탭
            Container(
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(3),
              child: Row(
                children: [_tabButton('주간', true), _tabButton('월간', false)],
              ),
            ),
            const SizedBox(height: 16),

            //날짜 네비게이션 추가
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: AppColors.textSecondary),
                  onPressed:() {
                    //잭엔드 연결 시 날짜 변경 구현
                    setState(() {
                      //이번 주/달로 이동
                    });
                  },
                ),
                Text(
                  _isWeekly ? '2026년 5월 2주차' : '2026년 5월',
                  style: AppTextStyle.body1.copyWith(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: AppColors.textSecondary),
                  onPressed: () {
                    //백엔드 연결 시 날짜 변경 구현
                    setState(() {
                      //다음 주/달로 이동
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            //AI 요약 카드
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
                          'AI 요약',
                          style: AppTextStyle.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isWeekly ? '이번 주 감정 리포트' : '이번 달 감정 리포트',
                        style: AppTextStyle.body2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  //백엔드 연결 시 실제 AI 요약으로 교체
                  Text(
                    _isWeekly
                        ? '이번 주는 기쁨과 평안이 높아 안정적인 한 주 였어요. 잘 버텨내셨어요 :)'
                        : '이번 달은 전반적으로 안정적이었어요. 한 달 동안 정말 잘 하셨어요 :)',
                    style: AppTextStyle.body2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            //감정 평균 막대 그래프
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isWeekly ? '이번 주 감정 평균' : '이번 달 감정 평균',
                    style: AppTextStyle.body2,
                  ),
                  const SizedBox(height: 12),
                  EmotionBarChart(
                    emotionName: '기쁨',
                    emoji: '😊',
                    value: _currentAvg['joy']!,
                    color: AppColors.joy,
                  ),
                  EmotionBarChart(
                    emotionName: '평안',
                    emoji: '😌',
                    value: _currentAvg['peace']!,
                    color: AppColors.peace,
                  ),
                  EmotionBarChart(
                    emotionName: '화남',
                    emoji: '😤',
                    value: _currentAvg['anger']!,
                    color: AppColors.anger,
                  ),
                  EmotionBarChart(
                    emotionName: '불안',
                    emoji: '😰',
                    value: _currentAvg['anxiety']!,
                    color: AppColors.anxiety,
                  ),
                  EmotionBarChart(
                    emotionName: '슬픔',
                    emoji: '😔',
                    value: _currentAvg['sadness']!,
                    color: AppColors.sadness,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            //감정 추이 꺾은선 그래프
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isWeekly ? '이번 주 감정 추이' : '이번 달 감정 추이 (주별)',
                    style: AppTextStyle.body2,
                  ),
                  const SizedBox(height: 12),
                  EmotionLineChart(
                    weeklyData: _currentLineData,
                    colors: [
                      AppColors.joy,
                      AppColors.anger,
                      AppColors.anxiety,
                      AppColors.peace,
                      AppColors.sadness,
                    ],
                    labels: _isWeekly
                        ? ['월', '화', '수', '목', '금', '토', '일']
                        : ['1주', '2주', '3주', '4주'],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            //비교하기 버튼
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          StatisticsCompareScreen(isWeekly: _isWeekly),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isWeekly ? '지난주와 비교하기 →' : '지난달과 비교하기 →',
                  style: AppTextStyle.button.copyWith(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String label, bool isWeekly) {
    final isSelected = _isWeekly == isWeekly;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isWeekly = isWeekly),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyle.body2.copyWith(
                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
