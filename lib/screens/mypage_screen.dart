// 마이페이지 화면
// 프로필 카드, 감정 통계, 설정 메뉴
// 아이콘 출처/로그아웃은 다이얼로그로 처리
// 알림 설정은 별도 화면으로 이동 (나중에 연결)
// 백엔드 연결 시 실제 유저 정보로 교체

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';
import '../screens/profile_edit_screen.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  String _version = '';
  String? _profileImageUrl; //백엔드 연결 시 실제 이미지 URL로 교체

  //백엔드 연결 시 서버에서 불러오도록 수정
  int _totalDays = 0;
  int _thisMonthDays = 0;
  int _aiCount = 0;
  int _daysWithMaeum = 0; //백엔드 연결 시 가입일로부터 계산

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
    });
  }

  //아이콘 출처
  void _showIconCreditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('아이콘 출처', style: AppTextStyle.heading3),
        content: Text(
          '본 앱의 아이콘은 Flaticon에서 제공받았습니다.\nIcons made by Flaticon (www.flaticon.com)',
          style: AppTextStyle.body2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('확인', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  //로그아웃
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('로그아웃', style: AppTextStyle.heading3),
        content: Text('로그아웃 하시겠어요?', style: AppTextStyle.body2),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              //백엔드 연결 시 토큰 삭제 후 로그인 화면으로 이동
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text('로그아웃', style: TextStyle(color: Colors.red[400])),
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
        title: Text('마이페이지', style: AppTextStyle.heading3),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          //프로필 카드
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.15),
                  AppColors.secondary.withValues(alpha: 0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                        shape: BoxShape.circle,
                      ),
                      //백엔드 연결 시 실제 프로필 이미지로 교체
                      child: _profileImageUrl != null
                          ? ClipOval(
                              child: Image.network(
                                _profileImageUrl!,
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 26,
                            ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //백엔드 연결 시 실제 닉네임으로 교체
                        Text('사용자', style: AppTextStyle.heading3),
                        const SizedBox(height: 4),
                        Text(
                          '🌱 마음이와 함께한 ${_daysWithMaeum}일째',
                          style: AppTextStyle.body2.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                //감정 통계
                Row(
                  children: [
                    //백엔드 연결 시 실제 데이터로 교체
                    _statItem(_totalDays.toString(), '총 기록\n일수'),
                    _dividerVertical(),
                    _statItem(_thisMonthDays.toString(), '이번 달\n기록'),
                    _dividerVertical(),
                    _statItem(_aiCount.toString(), 'AI 분석\n횟수'),
                    _dividerVertical(),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          //메뉴 리스트
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _menuItem(context, '✏️', '프로필 수정', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileEditScreen()));
                }),
                _divider(),

                _menuItem(context, '🔔', '알림 설정', () {
                  //나중에 알림 설정 화면으로 이동
                }),
                _divider(),

                _menuItem(context, 'ℹ️', '앱 버전 $_version', null),
                _divider(),

                _menuItem(context, '📄', '아이콘 출처', () {
                  _showIconCreditDialog(context);
                }),
                _divider(),

                _menuItem(context, '🚪', '로그아웃', () {
                  _showLogoutDialog(context);
                }, isRed: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String number, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(number, style: AppTextStyle.heading2),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyle.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _dividerVertical() {
    return Container(width: 1, height: 36, color: AppColors.border);
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.border,
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _menuItem(
    BuildContext context,
    String emoji,
    String title,
    VoidCallback? onTap, {
    bool isRed = false,
  }) {
    return ListTile(
      leading: Text(emoji, style: const TextStyle(fontSize: 20)),
      title: Text(
        title,
        style: AppTextStyle.body1.copyWith(
          color: isRed ? Colors.red[400] : AppColors.textPrimary,
        ),
      ),
      trailing: onTap != null
          ? Icon(
              Icons.chevron_right_rounded,
              color: isRed ? Colors.red[300] : AppColors.textSecondary,
              size: 20,
            )
          : null,
      onTap: onTap,
    );
  }
}
