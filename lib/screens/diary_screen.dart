// 일기 화면
// 날짜별 일기 리스트 (날짜 리스트 형식)
// 플로팅 버튼으로 일기 작성
// 날짜 클릭 시 일기 상세/수정 바텀시트
// 백엔드 연결 시 실제 데이터로 교체

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';
import '../services/api_service.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  DateTime currentMonth = DateTime.now();

  Map<String, String> diaries = {};

  @override
  void initState() {
    super.initState();
    _loadDiaries();
  }

  //일기 목록 서버에서 불러오기
  Future<void> _loadDiaries() async {
    try {
      final response = await ApiService.dio.get('/diaries/list');

      if (response.statusCode == 200) {
        setState(() {
          diaries = {};
          for (var diary in response.data) {
            diaries[diary['date']] = diary['content'];
          }
        });
      }
    } catch (e) {
      //서버 연결 실패 시 빈 리스트 표시
    }
  }

  final List<String> _weekdays = ['일', '월', '화', '수', '목', '금', '토'];

  void _previousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    });
    _loadDiaries();
  }

  void _nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    });
    _loadDiaries();
  }

  List<MapEntry<String, String>> _getDiariesForCurrentMonth() {
    String monthKey = DateFormat('yyyy-MM').format(currentMonth);

    return diaries.entries
        .where((entry) => entry.key.startsWith(monthKey))
        .toList()
      ..sort((a, b) => b.key.compareTo(a.key));
  }

  bool _isToday(String dateString) {
    DateTime date = DateTime.parse(dateString);
    DateTime today = DateTime.now();

    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  @override
  Widget build(BuildContext context) {
    List<MapEntry<String, String>> monthDiaries = _getDiariesForCurrentMonth();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left, color: AppColors.textSecondary),
              onPressed: _previousMonth,
            ),
            Text(
              DateFormat('yyyy년 MM월').format(currentMonth),
              style: AppTextStyle.heading2,
            ),
            IconButton(
              icon: Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onPressed: _nextMonth,
            ),
          ],
        ),
      ),

      body: monthDiaries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_note_outlined,
                    size: 65,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '이번 달 작성한 일기가 없어요 :(',
                    style: AppTextStyle.body1.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: monthDiaries.length,
              itemBuilder: (context, index) {
                String dateString = monthDiaries[index].key;
                String content = monthDiaries[index].value;
                DateTime date = DateTime.parse(dateString);
                bool isToday = _isToday(dateString);

                return GestureDetector(
                  onTap: () => _showDiaryBottomSheet(
                    context,
                    dateString,
                    content,
                    isToday,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.border, width: 1),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //날짜
                        SizedBox(
                          width: 50,
                          child: Column(
                            children: [
                              Text(
                                date.day.toString(),
                                style: AppTextStyle.heading2.copyWith(
                                  color: isToday ? AppColors.primary : AppColors.textPrimary, //오늘이면 primary
                                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              Text(
                                _weekdays[date.weekday % 7],
                                style: AppTextStyle.heading3.copyWith(
                                  color: isToday ? AppColors.primary : AppColors.textSecondary,

                                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),

                        //내용
                        Expanded(
                          child: Text(
                            content.length > 50
                                ? '${content.substring(0, 50)}...'
                                : content,
                            style: AppTextStyle.body1.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showDiaryBottomSheet(context, null, null, true),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDiaryBottomSheet(
    BuildContext context,
    String? dateString,
    String? content,
    bool canEdit,
  ) {
    final controller = TextEditingController(text: content ?? '');
    DateTime date = dateString != null
        ? DateTime.parse(dateString)
        : DateTime.now();

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
                // 핸들바
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
                // 헤더
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${date.month}월 ${date.day}일',
                        style: AppTextStyle.heading2,
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
                        Text(
                          canEdit ? '오늘 하루를 기록해요' : '이날의 일기',
                          style: AppTextStyle.body1.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: controller,
                          maxLines: 10,
                          enabled: canEdit,
                          style: AppTextStyle.body2,
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
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            hintText: '오늘 하루 어떠셨나요?\n마음껏 털어놓아도 괜찮아요 :)',
                            hintStyle: AppTextStyle.body1.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        if (canEdit) ...[
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  await ApiService.dio.post(
                                    '/diaries',
                                    data: {
                                      'date': DateFormat('yyyy-MM-dd').format(date),
                                      'content': controller.text,
                                    },
                                  );
                                  setState(() {
                                    diaries[DateFormat('yyyy-MM-dd').format(date)] = controller.text;
                                  });
                                  if (!context.mounted) return;
                                  Navigator.pop(context);
                                } catch (e) {
                                  //저장 실패
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                content == null ? '저장하기' : '수정하기',
                                style: AppTextStyle.button,
                              ),
                            ),
                          ),
                        ],
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
