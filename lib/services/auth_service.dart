// 카카오 로그인/로그아웃 및 JWT 토큰 관리 서비스
// kakaoLogin: 카카오 SDK로 로그인 후 서버에 토큰 전달, JWT 발급받아 저장
// logout: 로컬 토큰 삭제 및 카카오 로그아웃
// getToken: 저장된 JWT 토큰 조회 (API 요청 시 사용)
// isLoggedIn: refresh token으로 로그인 상태 확인

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
        '${AppConstants.baseUrl}/auth/kakao/login',
        data: {'accessToken': token.accessToken},
      );

      if (response.statusCode == 200) {
        await _storage.write(
          key: 'access_token',
          value: response.data['accessToken'],
        );
        await _storage.write(
          key: 'refresh_token',
          value: response.data['refreshToken'],
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await UserApi.instance.logout();
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  Future<String?> getToken() async {
    //API 호출할 때마다 Access Token을 꺼내서 사용
    return await _storage.read(key: 'access_token');
  }

  Future<bool> isLoggedIn() async {
    //앱 켤 때 로그인 상태 확인
    final token = await _storage.read(key: 'refresh.token');

    return token != null;
  }
}
