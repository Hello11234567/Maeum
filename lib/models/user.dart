//사용자 정보를 담는 데이터 모델
//카카오 로그인 후 서버에서 받아오는 유저 정보 저장
//fromJson: 서버 응답(JSON)을 User 객체로 변환
//toJson: User 객체를 JSON으로 변환 (서버 전송 시 사용)

class User {
  final int id;
  final String nickname;
  final String? ageRange;
  final String? profileImage;
  final String? intro; //나를 한 마디로 (AI 분석 반영)
  final bool notificationsEnabled;
  final String? notificationTime;
  final String createdAt; //마음이와 함께한 N일 계산용

  User({
    required this.id,
    required this.nickname,
    this.ageRange,
    this.profileImage,
    this.intro,
    required this.notificationsEnabled,
    this.notificationTime,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nickname: json['nickname'],
      profileImage: json['profileImage'],
      ageRange: json['ageRange'],
      intro: json['intro'],
      notificationsEnabled: json['notificationEnabled'],
      notificationTime: json['notificationTime'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'ageRange': ageRange,
      'profileImage': profileImage,
      'intro': intro,
      'notificationsEnabled': notificationsEnabled,
      'notificationTime': notificationTime,
    };
  }
}
