// 프로필 수정 화면
// 닉네임 수정, 프로필 이미지 수정
// 백엔드 연결 시 실제 저장 구현

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';
import '../widgets/custom_button.dart';
import '../services/api_service.dart';
import 'dart:io';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _introController = TextEditingController();
  String? _profileImageUrl;
  String? _selectedAgeRange;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _introController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final response = await ApiService.dio.get('/users/me');
      if (response.statusCode == 200) {
        setState(() {
          _nicknameController.text = response.data['nickname'] ?? '';
          _introController.text = response.data['intro'] ?? '';
          _selectedAgeRange = response.data['ageRange'];
          _profileImageUrl = response.data['profileImage'];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('데이터를 불러오지 못했습니다. 다시 시도해주세요.')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _showWithdrawDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('회원탈퇴', style: AppTextStyle.heading3),
        content: Text(
          '정말 탈퇴하시겠어요?\n모든 감정 기록이 삭제됩니다.',
          style: AppTextStyle.body2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ApiService.dio.delete('/users/me');
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false, //모든 화면 스택 제거
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('탈퇴에 실패했습니다. 다시 시도해주세요.')),
                );
              }
            },
            child: Text('탈퇴하기', style: TextStyle(color: Colors.red[400])),
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
        title: Text('프로필 수정', style: AppTextStyle.heading3),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            //프로필 이미지
            Center(
              child: GestureDetector(
                onTap: () => _pickImage(),

                child: Stack(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: _selectedImage != null
                          ? ClipOval(
                              child: Image.file(
                                _selectedImage!,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            )
                          : _profileImageUrl != null
                          ? ClipOval(
                              child: Image.network(
                                _profileImageUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 44,
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            //닉네임
            _inputLabel('닉네임'),
            const SizedBox(height: 8),
            _textField(_nicknameController, '닉네임을 입력해주세요'),
            const SizedBox(height: 20),

            //나를 한 마디로
            _inputLabel('나를 한 마디로 표현하면?'),
            const SizedBox(height: 4),
            Text(
              'AI 감정 분석 시 반영돼요 :)',
              style: AppTextStyle.caption.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            _textField(_introController, '예) 취업 준비 중인 대학생', maxLength: 30),
            const SizedBox(height: 40),

            //나이대
            _inputLabel('나이대'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['10대', '20대', '30대', '40대', '50대 이상'].map((age) {
                final isSelected = _selectedAgeRange == age;
                return GestureDetector(
                  onTap: () => setState(() => _selectedAgeRange = age),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      age,
                      style: AppTextStyle.body2.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 25),

            //저장 버튼
            CustomButton(
              text: '저장하기',
              onPressed: () async {
                try {
                  await ApiService.dio.put(
                    '/users/me',
                    data: {
                      'nickname': _nicknameController.text,
                      'intro': _introController.text,
                      'ageRange': _selectedAgeRange,
                    },
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('저장에 실패했습니다. 다시 시도해주세요.')),
                  );
                }
              },
            ),
            const SizedBox(height: 16),

            //회원탈퇴
            Center(
              child: TextButton(
                onPressed: _showWithdrawDialog,
                child: Text(
                  '회원탈퇴',
                  style: AppTextStyle.body2.copyWith(color: Colors.red[300]),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _inputLabel(String label) {
    return Text(label, style: AppTextStyle.body2);
  }

  Widget _textField(
    TextEditingController controller,
    String hint, {
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      style: AppTextStyle.body1,
      keyboardType: keyboardType,
      maxLength: maxLength,
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
        hintText: hint,
        hintStyle: AppTextStyle.body2,
        counterStyle: AppTextStyle.caption,
      ),
    );
  }
}
