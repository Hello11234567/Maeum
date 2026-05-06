// AI 분석에서 "작성하고 올래요" 눌렀을 때 나오는 일기 작성 화면
// 탭바 없음, 상단 뒤로가기
// 저장하면 AI 분석 화면으로 자동 이동
// 작성한 일기는 일기 리스트에도 표시
// 백엔드 연결 시 실제 저장 구현

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';
import '../widgets/custom_button.dart';

class DiaryWriteScreen extends StatefulWidget {
  const DiaryWriteScreen({super.key});

  @override
  State<DiaryWriteScreen> createState() => _DiaryWriteScreenState();
}

class _DiaryWriteScreenState extends State<DiaryWriteScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('오늘의 일기', style: AppTextStyle.heading3),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text('오늘 하루를 기록해요', style: AppTextStyle.body2),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: AppTextStyle.body1,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
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
                  hintText: '오늘 하루 어떠셨나요?\n마음껏 털어놓아도 괜찮아요 :)',
                  hintStyle: AppTextStyle.body2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: '저장하고 분석 받기',
              onPressed: () {
                // 백엔드 연결 시 실제 저장 구현
                // 저장 후 AI 분석 화면으로 이동
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}