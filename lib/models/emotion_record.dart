//감정 기록 데이터 모델
//사용자가 슬라이더로 입력한 5가지 감정 수취와 한 줄 일기 저장
//fromJson: 서버 응답(JSON)을 EmotionRecord 객체로 변환
//toJson: EmotionRecord 객체를 JSON으로 변환 (서버 전송 시 사용)

class EmotionRecord {
  final int? id;
  final String recordDate;
  final double joy;
  final double anger;
  final double anxiety;
  final double peace;
  final double sadness;
  final String? diary;
  final String? myEmoji;
  final String? createdAt;

  EmotionRecord({
    this.id,
    required this.recordDate,
    required this.joy,
    required this.anger,
    required this.anxiety,
    required this.peace,
    required this.sadness,
    this.diary,
    this.myEmoji,
    required this.createdAt,
  });

  factory EmotionRecord.fromJson(Map<String, dynamic> json) {
    return EmotionRecord(
      id: json['id'],
      recordDate: json['recordDate'],
      joy: json['joy'].toDouble(),
      anger: json['anger'].toDouble(),
      anxiety: json['anxiety'].toDouble(),
      peace: json['peace'].toDouble(),
      sadness: json['sadness'].toDouble(),
      diary: json['diary'],
      myEmoji: json['myEmoji'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recordDate': recordDate,
      'joy': joy,
      'anger': anger,
      'anxiety': anxiety,
      'peace': peace,
      'sadness': sadness,
      'diary': diary,
      'myEmoji': myEmoji,
    };
  }
}
