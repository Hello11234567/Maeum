// 하단 탭 네비게이션을 관리하는 메인 컨테이너 화면
// 홈(캘린더), 일기, AI분석, 통계, 마이페이지 5개 탭 관리
// 각 탭 클릭 시 해당 화면으로 전환

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'main_screen.dart';
import '../screens/mypage_screen.dart';
import '../screens/diary_screen.dart';
import '../screens/ai_analysis_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 2;

  final List<Widget> _screens = [
    const DiaryScreen(),
    const AiAnalysisScreen(),
    const MainScreen(),
    const Center(child: Text('통계')),
    const MyPageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 30,
        //아이콘 크기 키우기
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/diary.png')),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/ai.png')),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/home.png')),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/chart.png')),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/user.png')),
            label: '',
          ),
        ],
      ),
    );
  }
}
