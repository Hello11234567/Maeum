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
    print("서비스 진입");
    final token = await _authService.getToken();
    return {'Authorization': 'Bearer $token'};
  }

  Future<Statistics?> getWeeklyStats() async {
    print("서비스 진입");
    try {
      final response = await _dio.get(
        '${AppConstants.baseUrl}/statistics/weekly',
        options: Options(headers: await _getHeaders()),
      );
      return Statistics.fromJson(response.data);
    } catch (e) {
      print("에러타입: ${e.runtimeType}");
      print("에러내용: $e");

      if (e is DioException) {
        print("상태코드: ${e.response?.statusCode}");
        print("응답데이터: ${e.response?.data}");
        print("요청주소: ${e.requestOptions.uri}");
      }

      return null;
    }
  }

  Future<Statistics?> getMonthlyStats() async {
    print("서비스 진입");
    try {
      final response = await _dio.get(
        '${AppConstants.baseUrl}/statistics/monthly',
        options: Options(headers: await _getHeaders()),
      );
      return Statistics.fromJson(response.data);
    } catch (e) {
      print("에러타입: ${e.runtimeType}");
      print("에러내용: $e");

      if (e is DioException) {
        print("상태코드: ${e.response?.statusCode}");
        print("응답데이터: ${e.response?.data}");
        print("요청주소: ${e.requestOptions.uri}");
      }

      return null;
    }
  }

  Future<List<Statistics>?> getWeeklyComparison() async {
    print("서비스 진입");
    try {
      final response = await _dio.get(
        '${AppConstants.baseUrl}/statistics/weekly/compare',
        options: Options(headers: await _getHeaders()),
      );
      return (response.data as List)
          .map((e) => Statistics.fromJson(e))
          .toList();
    } catch (e) {
      print("에러타입: ${e.runtimeType}");
      print("에러내용: $e");

      if (e is DioException) {
        print("상태코드: ${e.response?.statusCode}");
        print("응답데이터: ${e.response?.data}");
        print("요청주소: ${e.requestOptions.uri}");
      }

      return null;
    }
  }

  Future<List<Statistics>?> getMonthlyComparison() async {
    print("서비스 진입");
    try {
      final response = await _dio.get(
        '${AppConstants.baseUrl}/statistics/monthly/compare',
        options: Options(headers: await _getHeaders()),
      );
      return (response.data as List)
          .map((e) => Statistics.fromJson(e))
          .toList();
    } catch (e) {
      print("에러타입: ${e.runtimeType}");
      print("에러내용: $e");

      if (e is DioException) {
        print("상태코드: ${e.response?.statusCode}");
        print("응답데이터: ${e.response?.data}");
        print("요청주소: ${e.requestOptions.uri}");
      }

      return null;
    }
  }
}
