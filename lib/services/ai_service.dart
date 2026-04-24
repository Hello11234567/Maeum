// AI 감정 분석 관련 API 통신 서비스
// analyze: 감정 기록을 서버로 전송해 OpenAI API 분석 요청
// getAnalysis: 특정 날짜 AI 분석 결과 조회

import 'package:dio/dio.dart';
import '../models/ai_analysis.dart';
import '../utils/constants.dart';
import 'auth_service.dart';

class AiService {
  final Dio _dio = Dio();
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {'Authorization': 'Bearer $token'};
  }

  Future<AiAnalysis?> analyze(String date) async {
    try {
      final response = await _dio.post(
        '${AppConstants.baseUrl}/ai/analyze',
        data: {'date': date},
        options: Options(headers: await _getHeaders()),
      );
      return AiAnalysis.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<AiAnalysis?> getAnalysis(String date) async {
    try {
      final response = await _dio.get(
        '${AppConstants.baseUrl}/ai/analyze',
        queryParameters: {'date': date},
        options: Options(headers: await _getHeaders()),
      );
      return AiAnalysis.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}
