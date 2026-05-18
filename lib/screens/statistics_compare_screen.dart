// 통계 비교 화면
// 이번주 vs 지난주 또는 이번달 vs 지난달
// 감정별 막대 비교
// AI 변화 요약
// 백엔드 연결 시 실제 데이터로 교체

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';
import '../services/api_service.dart';

class StatisticsCompareScreen extends StatefulWidget {
  final bool isWeekly;

  const StatisticsCompareScreen({super.key, required this.isWeekly});

  @override
  State<StatisticsCompareScreen> createState() =>
      _StatisticsCompareScreenState();
}

class _StatisticsCompareScreenState extends State<StatisticsCompareScreen> {
  //서버에서 받아온 데이터
  Map<String, double> _currentData = {
    'joy': 0,
    'anger': 0,
    'anxiety': 0,
    'peace': 0,
    'sadness': 0,
  };
  Map<String, double> _previousData = {
    'joy': 0,
    'anger': 0,
    'anxiety': 0,
    'peace': 0,
    'sadness': 0,
  };

  String _aiSummary = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCompareData();
  }

  //서버에서 비교 데이터 불러오기
  Future<void> _loadCompareData() async {
    try {
      final endpoint = widget.isWeekly
          ? '/statistics/weekly/compare'
          : '/statistics/monthly/compare';

      final response = await ApiService.dio.get(endpoint);

      if (response.statusCode == 200) {
        final current = response.data['current'];
        final previous = response.data['previous'];
        setState(() {
          _currentData = {
            'joy': current['joy'].toDouble(),
            'anger': current['anger'].toDouble(),
            'anxiety': current['anxiety'].toDouble(),
            'peace': current['peace'].toDouble(),
            'sadness': current['sadness'].toDouble(),
          };
          _previousData = {
            'joy': previous['joy'].toDouble(),
            'anger': previous['anger'].toDouble(),
            'anxiety': previous['anxiety'].toDouble(),
            'peace': previous['peace'].toDouble(),
            'sadness': previous['sadness'].toDouble(),
          };
          _aiSummary = response.data['aiSummary'] ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.isWeekly ? '지난주와 비교' : '지난달과 비교',
          style: AppTextStyle.heading3,
        ),
        centerTitle: true,
      ),
      //로딩 중이면 스피너 표시
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                              '이번 ${widget.isWeekly ? '주' : '달'}',
                              AppColors.primary,
                            ),
                            const SizedBox(width: 16),
                            _legendItem(
                              '지난 ${widget.isWeekly ? '주' : '달'}',
                              AppColors.border,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        // 서버에서 받아온 데이터 사용
                        _compareRow(
                          '😊',
                          '기쁨',
                          _currentData['joy']!,
                          _previousData['joy']!,
                        ),
                        _compareRow(
                          '😌',
                          '평안',
                          _currentData['peace']!,
                          _previousData['peace']!,
                        ),
                        _compareRow(
                          '😤',
                          '화남',
                          _currentData['anger']!,
                          _previousData['anger']!,
                        ),
                        _compareRow(
                          '😰',
                          '불안',
                          _currentData['anxiety']!,
                          _previousData['anxiety']!,
                        ),
                        _compareRow(
                          '😔',
                          '슬픔',
                          _currentData['sadness']!,
                          _previousData['sadness']!,
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
                                  colors: [
                                    AppColors.primary,
                                    AppColors.secondary,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '마음이',
                                style: AppTextStyle.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 7),
                            Text(
                              '${widget.isWeekly ? '지난주' : '지난달'} 대비 변화',
                              style: AppTextStyle.body2,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        //서버에서 받아온 AI 요약 사용
                        Text(
                          _aiSummary.isNotEmpty ? _aiSummary : '마음이가 정리중이에요 :)',
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

    Color getEmotionColor(String name) {
      switch (name) {
        case '기쁨':
          return AppColors.joy;
        case '평안':
          return AppColors.peace;
        case '화남':
          return AppColors.anger;
        case '불안':
          return AppColors.anxiety;
        case '슬픔':
          return AppColors.sadness;
        default:
          return AppColors.primary;
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
                            getEmotionColor(name),
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
                            getEmotionColor(name).withValues(alpha: 0.35),
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
