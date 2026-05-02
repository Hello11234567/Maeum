// AI 분석 결과 화면
// 캐릭터 + 말풍선 (감정에 맞는 표정)
// 하루 요약 카드
// 감정 케어 추천 카드
// 당일 자정까지 유지 → 다음날 초기화
// 마지막 수정 시간 표시
// 백엔드 연결 시 실제 데이터로 교체

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';
import '../widgets/ai_card.dart';

class AiResultScreen extends StatelessWidget {
  final double joy;
  final double anger;
  final double anxiety;
  final double peace;
  final double sadness;

  const AiResultScreen({
    super.key,
    required this.joy,
    required this.anger,
    required this.anxiety,
    required this.peace,
    required this.sadness,
  });

  //감정에 맞는 캐릭터 감정 표정 반환
  String _getCharacterEmoji() {
    if (joy >= 7) return '😊';
    if (sadness >= 7) return '😔';
    if (anger >= 7) return '😤';
    if (anxiety >= 7) return '😰';
    if (peace >= 7) return '😌';
    return '🙂';
  }

  // 감정에 맞는 말풍선 텍스트 반환
  String _getSpeechText() {
    if (joy >= 7) return '오늘 기쁨이 높았어요!\n정말 좋은 하루였네요 😊';
    if (sadness >= 7) return '많이 힘드셨죠?\n그래도 잘 버텨내셨어요 🫂';
    if (anger >= 7) return '화가 많이 나셨군요.\n충분히 그럴 수 있어요 💙';
    if (anxiety >= 7) return '불안한 마음이 크셨네요.\n괜찮아요, 여기 있을게요 🌿';
    if (peace >= 7) return '평온한 하루를 보내셨네요!\n정말 다행이에요 🍃';
    return '오늘 하루도 수고하셨어요 :)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('AI 분석 결과', style: AppTextStyle.heading3),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          //마지막 수정 시간(백엔드 연결 시 실제 시간으로 교체)
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: Text('마지막 수정: 21:00', style: AppTextStyle.caption),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //캐릭터 + 말풍선
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //캐릭터 (나중에 Lottie로 교체)
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

                //말풍선
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
                    child: Text(_getSpeechText(), style: AppTextStyle.body2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            //하루 요약 카드
            //백엔드 연결 시 실제 AI 요약으로 교체
            AiCard(
              title: '하루 요약',
              dotColor: AppColors.primary,
              content: Text(
                '오늘은 기쁨과 평안이 높았어요. 전반적으로 긍정적인 에너지가 가득한 하루였네요 :)',
                style: AppTextStyle.body2,
              ),
            ),

            // 감정 케어 추천 카드
            // 백엔드 연결 시 실제 AI 추천으로 교체
            AiCard(
              title: '오늘의 감정 케어 추천',
              dotColor: AppColors.primary,
              content: Column(
                children: [
                  _careItem('1', '작은 일에 감사하기 — 좋은 감정을 더 오래 유지해요'),
                  _careItem('2', '마음에 드는 음악 듣기 — 평안을 더욱 높여줄 수 있어요'),
                  _careItem('3', '하루 일기 쓰기 — 감정을 정리하고 내일을 준비해요'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            //수정하기 버튼
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
                  style: AppTextStyle.button.copyWith(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _careItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Center(
              child: Text(
                number,
                style: AppTextStyle.caption.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppTextStyle.body2)),
        ],
      ),
    );
  }
}
