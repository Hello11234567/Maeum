//AI 분석 결과 데이터 모델
//OpenAI API가 반환한 감정 분석 결과를 저장
//summary: AI가 분석한 하루 감정 요약
//careList: AI가 추천한 감정 케어 목록
//representativeEmoji: 캘린더에 표시될 AI 대표 이모지
//fromJson: 서버 응답(JSON)을 AiAnalysis 객체로 변환
//toJson: AiAnalysis 객체를 JSON으로 변환

class AiAnalysis {
  final int? id;
  final String analysisDate;
  final String summary;
  final List<String> careList;
  final String representativeEmoji;
  final String createdAt;

  AiAnalysis({
    this.id,
    required this.analysisDate,
    required this.summary,
    required this.careList,
    required this.representativeEmoji,
    required this.createdAt,
  });

  factory AiAnalysis.fromJson(Map<String, dynamic> json) {
    return AiAnalysis(
      id: json['id'],
      analysisDate: json['analysisDate'],
      summary: json['summary'],
      careList: List<String>.from(json['careList']),
      representativeEmoji: json['representativeEmoji'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'analysisDate': analysisDate,
      'summary': summary,
      'careList': careList,
      'representativeEmoji': representativeEmoji,
    };
  }
}
