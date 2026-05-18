//API 서비스
//Dio 인터셉터 설정
//모든 API 요청에 JWT Access Token 자동 추가
//토큰 만료 시 자동 재발급

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/constants.dart';

class ApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      //연결 타임아웃: 서버 연결 시도할 때 기다리는 시간
      receiveTimeout: const Duration(seconds: 10),
      //응답 타임아웃: 서버 연결 응답 기다리는 시간
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static void init() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          //모든 요청에 Access Token 자동 추가
          final token = await _storage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          //401 에러 (토큰 만료) 시 자동 재발급
          if (error.response?.statusCode == 401) {
            final refreshToken = await _storage.read(key: 'refresh_token');
            if (refreshToken != null) {
              try {
                final response = await dio.post(
                  '/auth/refresh',
                  options: Options(headers: {'Refresh-Token': refreshToken}),
                );
                //새 Access Token 저장
                await _storage.write(
                  key: 'access_token',
                  value: response.data['accessToken'],
                );
                //원래 요청 재시도
                handler.next(error);
              } catch (e) {
                //Refresh Token도 만료 -> 로그인 화면으로
                await _storage.deleteAll();
                handler.reject(error);
              }
            }
          } else {
            handler.next(error);
          }
        },
      ),
    );
  }
}
