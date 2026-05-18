// 통계 화면
// 주간/월간 탭
// AI 한 줄 요약 카드
// 감정 평균 막대 그래프
// 감정 추이 꺾은선 그래프
// 지난주/지난달 비교하기 버튼
// 백엔드 연결 시 실제 데이터로 교체

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';
import '../widgets/bar_chart.dart';
import '../widgets/line_chart.dart';
import 'statistics_compare_screen.dart';
import '../services/api_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool _isWeekly = true; //true: 주간, false: 월간

  DateTime _currentDate = DateTime.now();
  Map<String, double> _currentAvg = {
    'joy': 0,
    'anger': 0,
    'anxiety': 0,
    'peace': 0,
    'sadness': 0,
  };

  List<List<double>> _currentLineData = [[], [], [], [], []];

  String _aiSummary = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    try {
      final dateString = DateFormat('yyyy-MM-dd').format(_currentDate);
      final endpoint = _isWeekly ? '/statistics/weekly' : '/statistics/monthly';

      final response = await ApiService.dio.get(
        endpoint,
        queryParameters: {'date': dateString},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final avg = data['average'];
        final records = data['records'] as List;

        setState(() {
          _currentAvg = {
            'joy': avg['joy'].toDouble(),
            'anger': avg['anger'].toDouble(),
            'anxiety': avg['anxiety'].toDouble(),
            'peace': avg['peace'].toDouble(),
            'sadness': avg['sadness'].toDouble(),
          };
          _aiSummary = data['aiSummary'] ?? '';

          //꺾은선 그래프 데이터 변환
          _currentLineData = [
            records.map<double>((r) => r['joy'].toDouble()).toList(),
            records.map<double>((r) => r['anger'].toDouble()).toList(),
            records.map<double>((r) => r['anxiety'].toDouble()).toList(),
            records.map<double>((r) => r['peace'].toDouble()).toList(),
            records.map<double>((r) => r['sadness'].toDouble()).toList(),
          ];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  int _getWeekOfMonth() {
    final firstDayOfMonth = DateTime(_currentDate.year, _currentDate.month, 1);

    return ((_currentDate.day + firstDayOfMonth.weekday - 1) / 7).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('감정 통계', style: AppTextStyle.heading3),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                      children: [
                        _tabButton('주간', true),
                        _tabButton('월간', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  //날짜 네비게이션 추가
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.chevron_left,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _currentDate = _isWeekly
                                ? _currentDate.subtract(const Duration(days: 7))
                                : DateTime(
                                    _currentDate.year,
                                    _currentDate.month - 1,
                                  );
                            _isLoading = true;
                          });
                          _loadStatistics();
                        },
                      ),
                      Text(
                        _isWeekly
                            ? '${_currentDate.year}년 ${_currentDate.month}월 ${_getWeekOfMonth()}주차'
                            : '${_currentDate.year}년 ${_currentDate.month}월',
                        style: AppTextStyle.body1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.chevron_right,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _currentDate = _isWeekly
                                ? _currentDate.add(const Duration(days: 7))
                                : DateTime(
                                    _currentDate.year,
                                    _currentDate.month + 1,
                                  );
                            _isLoading = true;
                          });
                          _loadStatistics();
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
                                  colors: [
                                    AppColors.primary,
                                    AppColors.secondary,
                                  ],
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
                          _aiSummary.isNotEmpty
                              ? _aiSummary
                              : _isWeekly
                              ? '마음이가 정리중이에요 :)'
                              : '마음이가 정리중이에요 :)',
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
                        style: AppTextStyle.button.copyWith(
                          color: AppColors.primary,
                        ),
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
        onTap: () {
          setState(() {
            _isWeekly = isWeekly;
            _isLoading = true;
          });
          _loadStatistics();
        },
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
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
