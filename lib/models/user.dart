//사용자 정보를 담는 데이터 모델
//카카오 로그인 후 서버에서 받아오는 유저 정보 저장
//fromJson: 서버 응답(JSON)을 User 객체로 변환
//toJson: User 객체를 JSON으로 변환 (서버 전송 시 사용)

class User {
  final int id;
  final String email;
  final String nickname;
  final String? profileImage;
  final bool notificationsEnabled;
  final String? notificationTime;

  User({
    required this.id,
    required this.email,
    required this.nickname,
    this.profileImage,
    required this.notificationsEnabled,
    this.notificationTime,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['emial'],
      nickname: json['nickname'],
      profileImage: json['profileImage'],
      notificationsEnabled: json['notificationEnabled'],
      notificationTime: json['notificationTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'profileImage': profileImage,
      'notificationsEnabled': notificationsEnabled,
      'notificationTime': notificationTime,
    };
  }
}