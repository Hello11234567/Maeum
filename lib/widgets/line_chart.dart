// 통계 화면에서 감정 추이를 보여주는 꺾은선 그래프 컴포넌트
// weeklyData: 날짜별 감정 수치 데이터 목록
// colors: 감정별 색상 목록
// labels: x축 라벨 (월~일 또는 1~4주)

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';

class EmotionLineChart extends StatelessWidget {
  final List<List<double>> weeklyData;
  final List<Color> colors;
  final List<String> labels;

  const EmotionLineChart({
    super.key,
    required this.weeklyData,
    required this.colors,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 범례
        Wrap(
          spacing: 12,
          children: [
            _legendItem('기쁨', AppColors.joy),
            _legendItem('편안', AppColors.peace),
            _legendItem('불안', AppColors.anxiety),
            _legendItem('화남', AppColors.anger),
            _legendItem('슬픔', AppColors.sadness),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: CustomPaint(
            painter: LineChartPainter(
              data: weeklyData,
              colors: colors,
              labels: labels,
            ),
            size: Size.infinite,
          ),
        ),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyle.caption),
      ],
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<List<double>> data;
  final List<Color> colors;
  final List<String> labels;

  LineChartPainter({
    required this.data,
    required this.colors,
    required this.labels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double leftPadding = 30;
    final double bottomPadding = 20;
    final double chartWidth = size.width - leftPadding;
    final double chartHeight = size.height - bottomPadding;

    //격자 그리기
    final gridPaint = Paint()
      ..color = const Color(0xFFF0EDE8)
      ..strokeWidth = 0.5;

    for (int i = 0; i <= 2; i++) {
      final y = chartHeight * (1 - i / 2);
      canvas.drawLine(Offset(leftPadding, y), Offset(size.width, y), gridPaint);
    }

    //데이터 라인 그리기
    for (int i = 0; i < data.length; i++) {
      final points = data[i];
      if (points.isEmpty) continue;

      final paint = Paint()
        ..color = colors[i]
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final path = Path();
      for (int j = 0; j < points.length; j++) {
        final x = leftPadding + (j / (points.length - 1)) * chartWidth;
        final y = chartHeight * (1 - points[j] / 10);
        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
