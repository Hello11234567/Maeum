// 주간/월간 감정 통계 관련 API 통신 서비스
// getWeeklyStats: 이번 주 통계 조회
// getMonthlyStats: 이번 달 통계 조회
// getWeeklyComparison: 이번 주 vs 지난 주 비교
// getMonthlyComparison: 이번 달 vs 지난 달 비교

import 'package:dio/dio.dart';
import '../models/statistics.dart';
import '../utils/constants.dart';
import 'auth_service.dart';

class StatisticsService {
  final Dio _dio = Dio();
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {'Authorization': 'Bearer $token'};
  }

  Future<Statistics?> getWeeklyStats() async {
    try {
      final response = await _dio.get(
        '${AppConstants.baseUrl}/statistics/weekly',
        options: Options(headers: await _getHeaders()),
      );
      return Statistics.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<Statistics?> getMonthlyStats() async {
    try {
      final response = await _dio.get(
        '${AppConstants.baseUrl}.statistics/monthly',
        options: Options(headers: await _getHeaders()),
      );
      return Statistics.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<List<Statistics>?> getWeeklyComparison() async {
    try{
      final response = await _dio.get(
        '${AppConstants.baseUrl}/statistics/weekly/compare',
        options: Options(headers: await _getHeaders()),
      );
      return (response.data as List)
          .map((e) => Statistics.fromJson(e))
          .toList();
    } catch (e) {
      return null;
    }
  }

  Future<List<Statistics>?> getMonthlyComparison() async {
    try{
      final response = await _dio.get(
        '${AppConstants.baseUrl}/statistics/monthly/compare',
        options: Options(headers: await _getHeaders()),
      );
      return (response.data as List)
          .map((e) => Statistics.fromJson(e))
          .toList();
    } catch (e) {
      return null;
    }
  }
}