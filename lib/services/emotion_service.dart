// 감정 기록 관련 API 통신 서비스
// saveEmotion: 감정 기록 저장 (POST)
// getEmotion: 특정 날짜 감정 기록 조회 (GET)
// updateEmotion: 감정 기록 수정 (PUT)
// deleteEmotion: 감정 기록 삭제 (DELETE)

import 'package:dio/dio.dart';
import '../models/emotion_record.dart';
import '../utils/constants.dart';
import 'auth_service.dart';

class EmotionService {
  final Dio _dio = Dio();
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {'Authorization': 'Bearer $token'};
  }

  Future <EmotionRecord?> saveEmotion(EmotionRecord record) async {
    try {
      final response = await _dio.post(
        '${AppConstants.baseUrl}/emotions',
        data: record.toJson(),
        options: Options(headers: await _getHeaders()),
      );
      return EmotionRecord.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<EmotionRecord?> getEmotion(String date) async {
    try {
      final response = await _dio.put(
        '${AppConstants.baseUrl}/emotions',
        queryParameters: {'date': date},
        options: Options(headers: await _getHeaders()),
      );
      return EmotionRecord.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<EmotionRecord?> updateEmotion(int id, EmotionRecord record) async {
    try {
      final response = await _dio.put(
        '${AppConstants.baseUrl}/emotions/$id',
        data: record.toJson(),
        options: Options(headers: await _getHeaders()),
      );
      return EmotionRecord.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteEmotion(int id) async {
    try {
      await _dio.delete(
        '${AppConstants.baseUrl}/emotions/$id',
        options: Options(headers: await _getHeaders()),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}