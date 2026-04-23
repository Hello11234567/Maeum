// 카카오 로그인/로그아웃 및 JWT 토큰 관리 서비스
// kakaoLogin: 카카오 SDK로 로그인 후 서버에 토큰 전달, JWT 발급받아 저장
// logout: 로컬 토큰 삭제 및 카카오 로그아웃
// getToken: 저장된 JWT 토큰 조회 (API 요청 시 사용)
// isLoggedIn: 로그인 상태 확인

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:dio/dio.dart';
import '../utils/constants.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Dio _dio = Dio();

  Future<bool> kakaoLogin() async {
    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      final response = await _dio.post(
        '${AppConstants.baseUrl}/auth/kakao',
        data: {'accessToken': token.accessToken},
      );

      if (response.statusCode == 200) {
        await _storage.write(
          key: 'jwt_token',
          value: response.data['token'],
        );
        return true;
      }
      return false;
    } catch (e) {
      print('카카오 로그인 에러: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await UserApi.instance.logout();
    await _storage.delete(key: 'jwt_token');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}