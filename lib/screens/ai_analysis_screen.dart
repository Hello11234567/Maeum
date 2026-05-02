// AI 분석 화면
// 첫 진입 시 환영 팝업 (닉네임, 나를 한 마디로)
// 당일 일기 없으면 일기 작성 유도 팝업
// 5가지 감정 슬라이더 입력
// 당일 이미 분석했으면 결과 화면으로 이동
// 백엔드 연결 시 실제 데이터 연동

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';
import '../widgets/emotion_slider.dart';
import '../widgets/custom_button.dart';
import 'ai_loading_screen.dart';

class AiAnalysisScreen extends StatefulWidget {
  const AiAnalysisScreen({super.key});

  @override
  State<AiAnalysisScreen> createState() => _AiAnalysisScreenState();
}

class _AiAnalysisScreenState extends State<AiAnalysisScreen> {
  //감정 슬라이더 값 (백엔드 연결 시 기존 값 불러오기) - 당일 분석을 이미 했을 때
  double _joy = 5;
  double _anger = 5;
  double _anxiety = 5;
  double _peace = 5;
  double _sadness = 5;

  //백엔드 연결 시 실제 값으로 교체
  bool _isFirstAnalysis = true; //첫 분석 여부
  bool _hasDiaryToday = false; //오늘 일기 작성 여부
  bool _hasAnalyzedToday = false; //오늘 이미 분석했는지

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowPopup();
    });
  }

  void _checkAndShowPopup() {
    if (_isFirstAnalysis) {
      _showWelcomePopup();
    } else if (!_hasDiaryToday) {
      _showDiaryPopup();
    }
  }

  //첫 분석 환영 팝업
  void _showWelcomePopup() {
    final nicknameController = TextEditingController();
    final introController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🌱', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 12),
              Text('처음 만나서 반가워요!', style: AppTextStyle.heading2),
              const SizedBox(height: 8),
              Text(
                '당신에 대해 간단히 알려주세요 :)\n나중에 프로필에서 수정할 수 있어요!',
                style: AppTextStyle.body2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              //닉네임
              TextField(
                controller: nicknameController,
                style: AppTextStyle.body1,
                decoration: InputDecoration(
                  labelText: '제가 어떻게 불러드릴까요?',
                  labelStyle: AppTextStyle.body2,
                  hintText: '닉네임 입력',
                  hintStyle: AppTextStyle.body2,
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              //나이대 선택
              Align(
                alignment: Alignment.centerLeft,
                child: Text('나이대가 어떻게 되세요?', style: AppTextStyle.body2),
              ),
              const SizedBox(height: 8),
              _AgeRangeSelector(),
              const SizedBox(height: 12),

              //나를 한 마디로
              TextField(
                controller: introController,
                style: AppTextStyle.body1,
                maxLength: 30,
                decoration: InputDecoration(
                  labelText: '나를 한 마디로 표현하면?',
                  labelStyle: AppTextStyle.body2,
                  hintText: '예) 취업 준비 중인 대학생',
                  hintStyle: AppTextStyle.body2,
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                //백엔드 연결 시 저장
                Navigator.pop(context);
                if (!_hasDiaryToday) _showDiaryPopup();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('시작하기', style: AppTextStyle.button),
            ),
          ),
        ],
      ),
    );
  }

  //일기 작성 유도 팝업
  void _showDiaryPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📝', style: TextStyle(fontSize: 36)),
            const SizedBox(height: 12),
            Text(
              '앗! 아직 오늘 일기를\n작성 안 하셨네요',
              style: AppTextStyle.heading3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '일기를 작성하시면 AI가\n좀 더 자세히 분석해드려요 :)',
              style: AppTextStyle.body2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    '괜찮아요',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    //일기 탭으로 이동
                    Navigator.pushReplacementNamed(context, '/diary');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('작성하고 올래요', style: AppTextStyle.button),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('오늘의 마음', style: AppTextStyle.heading3),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //안내 텍스트
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Text('💚', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '오늘 하루 감정을 수치로 표현해봐요\n0에 가까울수록 낮음, 10에 가까울수록 높음',
                      style: AppTextStyle.body2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            //감정 슬라이더
            Text('오늘의 감정', style: AppTextStyle.heading3),
            const SizedBox(height: 15),
            EmotionSlider(
              emotionName: '기쁨',
              emoji: '😊',
              value: _joy,
              color: AppColors.joy,
              onChanged: (v) => setState(() => _joy = v),
            ),
            EmotionSlider(
              emotionName: '화남',
              emoji: '😤',
              value: _anger,
              color: AppColors.anger,
              onChanged: (v) => setState(() => _anger = v),
            ),
            EmotionSlider(
              emotionName: '불안',
              emoji: '😰',
              value: _anxiety,
              color: AppColors.anxiety,
              onChanged: (v) => setState(() => _anxiety = v),
            ),
            EmotionSlider(
              emotionName: '편안',
              emoji: '😌',
              value: _peace,
              color: AppColors.peace,
              onChanged: (v) => setState(() => _peace = v),
            ),
            EmotionSlider(
              emotionName: '슬픔',
              emoji: '😢',
              value: _sadness,
              color: AppColors.sadness,
              onChanged: (v) => setState(() => _sadness = v),
            ),
            const SizedBox(height: 32),

            //분석하기 버튼
            CustomButton(
              text: '오늘의 마음 살피러 가기',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (contex) => AiLoadingScreen(
                      joy: _joy,
                      anger: _anger,
                      anxiety: _anxiety,
                      peace: _peace,
                      sadness: _sadness,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

//나이대 선택 위젯 (팝업 안에서 상태관리용)
class _AgeRangeSelector extends StatefulWidget {
  @override
  State<_AgeRangeSelector> createState() => _AgeRangeSelectorState();
}

class _AgeRangeSelectorState extends State<_AgeRangeSelector> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: ['10대', '20대', '30대', '40대', '50대 이상'].map((age) {
        final isSelected = _selected == age;
        return GestureDetector(
          onTap: () => setState(() => _selected = age),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Text(
              age,
              style: AppTextStyle.body2.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
