// 주간/월간 감정 통계 데이터 모델
// 기간별 5가지 감정의 평균값을 저장
// type: 'weekly' 또는 'monthly'로 주간/월간 구분
// fromJson: 서버 응답(JSON)을 Statistics 객체로 변환
// toJson: Statistics 객체를 JSON으로 변환

class Statistics {
  final int? id;
  final String type;
  final String startDate;
  final String endDate;
  final double avgJoy;
  final double avgAnger;
  final double avgAnxiety;
  final double avgPeace;
  final double avgSadness;
  final String? aiSummary;
  final String? createdAt;

  Statistics({
    this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.avgJoy,
    required this.avgAnger,
    required this.avgAnxiety,
    required this.avgPeace,
    required this.avgSadness,
    this.aiSummary,
    required this.createdAt,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      id: json['id'],
      type: json['type'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      avgJoy: json['avgJoy'].toDouble(),
      avgAnger: json['avgAnger'].toDouble(),
      avgAnxiety: json['avgAnxiety'].toDouble(),
      avgPeace: json['avgPeace'].toDouble(),
      avgSadness: json['avgSadness'].toDouble(),
      aiSummary: json['aiSummary'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'startDate': startDate,
      'endDate': endDate,
      'avgJoy': avgJoy,
      'avgAnger': avgAnger,
      'avgAnxiety': avgAnxiety,
      'avgPeace': avgPeace,
      'avgSadness': avgSadness,
      'aiSummary': aiSummary,
    };
  }
}
