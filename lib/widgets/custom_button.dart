// 앱 전체에서 공통으로 사용하는 버튼 컴포넌트
// text: 버튼 텍스트
// onPressed: 버튼 클릭 시 실행할 함수
// isLoading: true면 로딩 스피너 표시 (API 호출 중일 때 사용)
// width: 버튼 너비 (기본값: 전체 너비)

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
            ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                  strokeWidth: 2,
              ),
            )
            : Text(text, style: AppTextStyle.button),
      ),
    );
  }
}