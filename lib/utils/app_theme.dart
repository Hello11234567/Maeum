//앱 전체 테마 정의
//앱 전체에 색상, 텍스트, 버튼 스타일 일괄 적용

import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_style.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
      ),

      textTheme: TextTheme(
        displayLarge: AppTextStyle.heading1,
        displayMedium: AppTextStyle.heading2,
        displaySmall: AppTextStyle.heading3,
        bodyLarge: AppTextStyle.body1,
        bodyMedium: AppTextStyle.body2,
        bodySmall: AppTextStyle.caption,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: AppTextStyle.button,
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: AppTextStyle.heading3,
      ),

      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}