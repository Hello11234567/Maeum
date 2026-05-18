// AI 분석 결과 화면
// 캐릭터 + 말풍선 (감정에 맞는 표정)
// 하루 요약 카드
// 감정 케어 추천 카드
// 당일 자정까지 유지 → 다음날 초기화
// 마지막 수정 시간 표시
// 백엔드 연결 시 실제 데이터로 교체

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';
import '../widgets/ai_card.dart';
import '../services/api_service.dart';

class AiResultScreen extends StatefulWidget {
  final double joy;
  final double anger;
  final double anxiety;
  final double peace;
  final double sadness;
  final String mode; //'new' or 'view'
  final DateTime? date; //지난 날짜 결과 보기 시 사용

  const AiResultScreen({
    super.key,
    required this.joy,
    required this.anger,
    required this.anxiety,
    required this.peace,
    required this.sadness,
    required this.mode,
    this.date,
  });

  @override
  State<AiResultScreen> createState() => _AiResultScreenState();
}

class _AiResultScreenState extends State<AiResultScreen> {
  String _summary = '';
  String _careList = '';
  String _speechText = '';
  String _lastModified = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalysisResult();
  }

  Future<void> _loadAnalysisResult() async {
    try {
      final date = widget.date ?? DateTime.now();
      final dateString = DateFormat('yyyy-MM-dd').format(date);

      final response = await ApiService.dio.get(
        '/ai-analysis',
        queryParameters: {'date': dateString},
      );

      if (response.statusCode == 200) {
        setState(() {
          _summary = response.data['summary'] ?? '';
          _careList = response.data['careList'] ?? '';
          _speechText = response.data['speechText'] ?? '';
          _lastModified = response.data['lastModified'] ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  //감정에 맞는 캐릭터 표정 반환
  String _getCharacterEmoji() {
    if (widget.joy >= 7) return '😊';
    if (widget.anger >= 7) return '😤';
    if (widget.anxiety >= 7) return '😰';
    if (widget.peace >= 7) return '😌';
    if (widget.sadness >= 7) return '😢';
    return '🙂';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('마음이의 감정 리포트', style: AppTextStyle.heading3),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          //마지막 수정 시간
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: Text(
                _lastModified.isNotEmpty ? '마지막 수정: $_lastModified' : '',
                style: AppTextStyle.caption,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  //캐릭터 + 말풍선
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //캐릭터
                      Container(
                        width: 70,
                        height: 70,
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
                          child: Text(
                            _getCharacterEmoji(),
                            style: const TextStyle(fontSize: 36),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      //말풍선 (서버에서 받아온 SpeechText)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            _speechText.isNotEmpty
                                ? _speechText
                                : '오늘 하루도 고생하셨어요 :)',
                            style: AppTextStyle.body2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  //하루 요약 카드 (서버에서 받아온 Summary)
                  AiCard(
                    title: '하루 요약',
                    dotColor: AppColors.primary,
                    content: Text(
                      _summary.isNotEmpty ? _summary : '요약을 불러오는 중...',
                      style: AppTextStyle.body2,
                    ),
                  ),

                  //감정 케어 추천 카드 (서버에서 받아온 careList)
                  AiCard(
                    title: '오늘의 감정 케어 추천',
                    dotColor: AppColors.primary,
                    content: Text(
                      _careList.isNotEmpty ? _careList : '케어 추천을 불러오는중...',
                      style: AppTextStyle.body2,
                    ),
                  ),
                  const SizedBox(height: 20),

                  //수치 저장하기 버튼 (mode가 new일 때만 표시)
                  if (widget.mode == 'new')
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          '수치 수정하기',
                          style: AppTextStyle.button.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}