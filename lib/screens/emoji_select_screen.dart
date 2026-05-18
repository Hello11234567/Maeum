// 날짜 클릭 시 나오는 이모지 선택 화면
// 사용자가 오늘의 기분을 이모지로 선택
// 선택한 이모지는 캘린더에 표시됨
// 나중에 백엔드 연결 시 서버에 저장

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';
import '../services/api_service.dart';

class EmojiSelectScreen extends StatefulWidget {
  final DateTime selectedDate;

  const EmojiSelectScreen({super.key, required this.selectedDate});

  @override
  State<EmojiSelectScreen> createState() => _EmojiSelectScreenState();
}

class _EmojiSelectScreenState extends State<EmojiSelectScreen> {
  String? _selectedEmoji;

  final List<Map<String, String>> _emojis = [
    {'emoji': '😊', 'label': '기뻐요'},
    {'emoji': '😌', 'label': '평온해요'},
    {'emoji': '😐', 'label': '그냥 그래요'},
    {'emoji': '😔', 'label': '슬퍼요'},
    {'emoji': '😢', 'label': '많이 슬퍼요'},
    {'emoji': '😤', 'label': '화나요'},
    {'emoji': '😠', 'label': '많이 화나요'},
    {'emoji': '😰', 'label': '불안해요'},
    {'emoji': '😩', 'label': '지쳐요'},
    {'emoji': '🥰', 'label': '설레요'},
    {'emoji': '😴', 'label': '피곤해요'},
    {'emoji': '🤗', 'label': '따뜻해요'},
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF8F6F2),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //상단 핸들바
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12, bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                //날짜 + 닫기
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.selectedDate.month}월 ${widget.selectedDate.day}일',
                        style: AppTextStyle.heading3,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('오늘 기분은 어떠신가요?', style: AppTextStyle.heading2),
                      const SizedBox(height: 8),
                      Text('가장 잘 맞는 이모지를 선택해주세요 :)', style: AppTextStyle.body2),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                //이모지 그리드
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: GridView.builder(
                      controller: scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, //한줄에 4개
                            childAspectRatio: 1, //정사각형
                            crossAxisSpacing: 12, //셀 사이 가로 간격
                            mainAxisSpacing: 12, //셀 사이 세로 간격
                          ),
                      itemCount: _emojis.length,
                      itemBuilder: (context, index) {
                        final item = _emojis[index];
                        final isSelected = _selectedEmoji == item['emoji'];
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedEmoji = item['emoji']);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withValues(alpha: 0.15)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item['emoji']!,
                                  style: const TextStyle(fontSize: 28),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['label']!,
                                  style: AppTextStyle.caption,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                //저장 버튼
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedEmoji == null
                          ? null
                          : () async {
                              try {
                                await ApiService.dio.post(
                                  '/emotions/my-emoji',
                                  data: {
                                    'date': widget.selectedDate.toIso8601String().substring(0, 10),
                                    'myEmoji': _selectedEmoji,
                                  },
                                );
                                if (!context.mounted) return;
                                Navigator.pop(context, _selectedEmoji);
                              } catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('저장에 실패했습니다. 다시 시도해주세요.')),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('저장하기', style: AppTextStyle.button),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
