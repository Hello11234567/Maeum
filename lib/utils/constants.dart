//앱 전체 공통으로 쓰이는 고정값들

class AppConstants {
  //API Base URL (나중에 Spring Boot 서버 주소로 변경)
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  //감정 이름
  static const List<String> emotionNames = [
    '기쁨', '화남', '불안', '평안', '슬픔'
  ];

  //앱 이름
  static const String appName = '마음이';
}