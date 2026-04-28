// 일기 화면
// 날짜별 일기 리스트 (날짜 리스트 형식)
// 플로팅 버튼으로 일기 작성
// 날짜 클릭 시 일기 상세/수정 바텀시트
// 백엔드 연결 시 실제 데이터로 교체

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  //백엔드 연결 시 실제 데이터로 교체
  final List<Map<String, dynamic>> _diaries = [
    {'date': DateTime(2026, 4, 24), 'content': '오늘 면접 결과가 좋았다. 오랜만에 기분 좋은 하루!'},
    {'date': DateTime(2026, 4, 23), 'content': '오늘은 좀 지친 하루이다 그래도 내일은 힘내야지!'},
    {'date': DateTime(2026, 4, 22), 'content': '내일 발표가 있는데 잘 할 수 있을까..?'},
  ];

  final List<String> _weekdays = ['일', '월', '화', '수', '목', '금', '토'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('일기', style: AppTextStyle.heading3),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _diaries.isEmpty
          ? _emptyView()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _diaries.length,
              itemBuilder: (context, index) {
                final diary = _diaries[index];
                final date = diary['date'] as DateTime;
                return _diaryItem(diary, date);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDiaryBottomSheet(context, null),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.edit_rounded, color: Colors.white),
      ),
    );
  }

  Widget _diaryItem(Map<String, dynamic> diary, DateTime date) {
    return GestureDetector(
      onTap: () => _showDiaryBottomSheet(context, diary),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //날짜
            SizedBox(
              width: 36,
              child: Column(
                children: [
                  Text(date.day.toString(), style: AppTextStyle.heading2),
                  Text(
                    _weekdays[date.weekday % 7],
                    style: AppTextStyle.caption,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            //내용
            Expanded(
              child: Text(
                diary['content'] ?? '',
                style: AppTextStyle.body2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📝', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text('아직 작성한 일기가 없어요', style: AppTextStyle.body1),
          const SizedBox(height: 8),
          Text('오늘 하루를 기록해보세요 :)', style: AppTextStyle.body2),
        ],
      ),
    );
  }

  void _showDiaryBottomSheet(
    BuildContext context,
    Map<String, dynamic>? diary,
  ) {
    final controller = TextEditingController(text: diary?['content'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.background,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF8F6F2),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                //핸들바
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                //헤더
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${diary != null ? "${(diary!['date'] as DateTime).month}월 ${(diary!['date'] as DateTime).day}일" : "오늘의 일기"}',
                        style: AppTextStyle.heading3,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('오늘 하루를 기록해요', style: AppTextStyle.body2),
                        const SizedBox(height: 8),
                        TextField(
                          controller: controller,
                          maxLines: 10,
                          style: AppTextStyle.body1,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              //활성화, 클릭 X
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              //클릭 O
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            hintText: '오늘 하루 어떠셨나요?\n마음껏 털어놓아도 괜찮아요 :)',
                            hintStyle: AppTextStyle.body2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              //백엔드 연결 시 실제 저장 구현
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              diary == null ? '저장하기' : '수정하기',
                              style: AppTextStyle.button,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
