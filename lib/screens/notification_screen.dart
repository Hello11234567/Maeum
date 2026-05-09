// 알림 설정 화면
// 전체 알림 ON/OFF (users.notifications_enabled)
// 감정 기록 알림 (notification_settings.record_notification)
// 주간 마감 알림 (notification_settings.weekly_notification)
// 월간 마감 알림 (notification_settings.monthly_notification)
// 전체 알림 OFF시 세부 설정 비활성화
// 백엔드 연결 시 실제 저장 구현

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';
import '../widgets/custom_button.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  //백엔드 연결 시 실제 값으로 교체
  bool _notificationsEnabled = false; //전체 알림 ON/OFF (users 테이블)
  bool _recordNotification = false; //감정 기록 알림
  TimeOfDay _notificationTime = const TimeOfDay(hour: 21, minute: 0);
  bool _weeklyNotification = true; //주간 마감 알림
  bool _monthlyNotification = true; //월간 마감 알림

  Future<void> _selectTime(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 280,
        decoration: const BoxDecoration(
          color: Colors.white,
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
            // 확인 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      '취소',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      '확인',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // iOS 스타일 타임피커
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime(
                  2026,
                  1,
                  1,
                  _notificationTime.hour,
                  _notificationTime.minute,
                ),
                use24hFormat: false,
                onDateTimeChanged: (DateTime newTime) {
                  setState(() {
                    _notificationTime = TimeOfDay(
                      hour: newTime.hour,
                      minute: newTime.minute,
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('알림 설정', style: AppTextStyle.heading3),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          //전체 알림 ON/OFF
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: SwitchListTile(
              title: Text('전체 알림', style: AppTextStyle.body1),
              subtitle: Text(
                '알림을 끄면 모든 알림이 비활성화 돼요',
                style: AppTextStyle.caption,
              ),
              value: _notificationsEnabled,
              thumbColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primary;
                }
                return null;
              }),
              trackColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primary.withValues(alpha: 0.5);
                }
                return null;
              }),
              onChanged: (value) {
                setState(() => _notificationsEnabled = value);
              },
            ),
          ),
          const SizedBox(height: 16),

          Opacity(
            opacity: _notificationsEnabled ? 1.0 : 0.4,
            child: IgnorePointer(
              ignoring: !_notificationsEnabled,
              child: Column(
                children: [
                  //감정 기록 알림
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: Text('감정 기록 알림', style: AppTextStyle.body1),
                          subtitle: Text(
                            '매일 설정한 시간에 알림을 보내드려요 :)',
                            style: AppTextStyle.caption,
                          ),
                          value: _recordNotification,
                          thumbColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.primary;
                            }
                            return null;
                          }),
                          trackColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.primary.withValues(alpha: 0.5);
                            }
                            return null;
                          }),
                          onChanged: (value) {
                            setState(() => _recordNotification = value);
                          },
                        ),
                        if (_recordNotification) ...[
                          Divider(height: 1, color: AppColors.border),
                          ListTile(
                            leading: Text(
                              '🕐',
                              style: const TextStyle(fontSize: 20),
                            ),
                            title: Text('알림 시간', style: AppTextStyle.body1),
                            trailing: Text(
                              _notificationTime.format(context),
                              style: AppTextStyle.body1.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onTap: () => _selectTime(context),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  //주간 마감 알림
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: SwitchListTile(
                      title: Text('주간 마감 알림', style: AppTextStyle.body1),
                      subtitle: Text(
                        '매주 일요일에 주간 감정 통계와 함께\n"이번 주도 고생하셨습니다 :)" 알림을 보내드려요!',
                        style: AppTextStyle.caption,
                      ),
                      value: _weeklyNotification,
                      thumbColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.primary;
                        }
                        return null;
                      }),
                      trackColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.primary.withValues(alpha: 0.5);
                        }
                        return null;
                      }),
                      onChanged: (value) {
                        setState(() => _weeklyNotification = value);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  //월간 마감 알림
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: SwitchListTile(
                      title: Text('월 마감 알림', style: AppTextStyle.body1),
                      subtitle: Text(
                        '매월 말일에 주간 감정 통계와 함께\n"지난 한 달도 고생하셨습니다 :)" 알림을 보내드려요!',
                        style: AppTextStyle.caption,
                      ),
                      value: _monthlyNotification,
                      thumbColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.primary;
                        }
                        return null;
                      }),
                      trackColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.primary.withValues(alpha: 0.5);
                        }
                        return null;
                      }),
                      onChanged: (value) {
                        setState(() => _monthlyNotification = value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),

          //저장 버튼
          CustomButton(
            text: '저장하기',
            onPressed: () {
              //백엔드 연결 시 실제 저장 구현
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
