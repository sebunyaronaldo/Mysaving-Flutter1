import 'package:flutter/material.dart';
import '../../../../../../common/utils/mysaving_colors.dart';
import '../../../../../../data/models/dashboard_model.dart';

class LastMonthBarChart extends StatelessWidget {
  final List<DashboardAnalitycsDay> data;

  LastMonthBarChart(this.data);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: VerticalBarChartPainter(data),
      size: Size.infinite,
    );
  }
}

class VerticalBarChartPainter extends CustomPainter {
  final List<DashboardAnalitycsDay> data;

  VerticalBarChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = 9.0;
    final barSpacing = 2.0;
    final maxExpenses = data.map((day) => day.expenses).reduce((a, b) => a > b ? a : b);
    final chartHeight = size.height;
    final chartWidth = (barWidth + barSpacing) * data.length - barSpacing;

    final paint = Paint()..style = PaintingStyle.fill;

    // Drawing intersecting lines and scales
    final maxScaleValue = 500;
    final scaleStep = 100;

    for (var i = 0; i <= maxScaleValue; i += scaleStep) {
      final x = i * (barWidth + barSpacing) + (size.width - chartWidth) / 2;

      // Drawing expense limit lines
      paint.color = Colors.grey; // Expense limit lines color
      paint.strokeWidth = 1.0;
      canvas.drawLine(
        Offset(x, chartHeight / 2.9),
        Offset(x + barWidth, chartHeight / 2.9),
        paint,
      );
      canvas.drawLine(
        Offset(x, chartHeight / 2),
        Offset(x + barWidth, chartHeight / 2),
        paint,
      );
      canvas.drawLine(
        Offset(x, chartHeight / 1.5),
        Offset(x + barWidth, chartHeight / 1.5),
        paint,
      );
      canvas.drawLine(
        Offset(x, chartHeight / 1.2),
        Offset(x + barWidth, chartHeight / 1.2),
        paint,
      );
      canvas.drawLine(
        Offset(x, chartHeight / 1.02),
        Offset(x + barWidth, chartHeight / 1.02),
        paint,
      );

      // Drawing scale
      final scaleValue = i;
      final textStyle = TextStyle(
        color: Colors.grey,
        fontSize: 12,
      );
      final textSpan = TextSpan(
        text: scaleValue.toString(),
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textOffset = Offset(
        (size.width - chartWidth) / 2 - 50,
        chartHeight - (scaleValue / maxScaleValue) * chartHeight / 1.6 - textPainter.height / 2,
      );
      textPainter.paint(canvas, textOffset);
    }

    // Drawing bars
    for (var i = 0; i < data.length; i++) {
      final x = i * (barWidth + barSpacing) + (size.width - chartWidth) / 2;

      // Drawing expense limit lines
      paint.color = MySavingColors.defaultExpensesText; // Expense limit lines color
      paint.strokeWidth = 1.0;
      canvas.drawLine(
        Offset(x, chartHeight / 2.9),
        Offset(x + barWidth, chartHeight / 2.9),
        paint,
      );
      // Drawing remaining expense limit lines

      canvas.drawLine(
        Offset(x, chartHeight / 1.02),
        Offset(x + barWidth, chartHeight / 1.02),
        paint,
      );

      // Drawing bars
      final y = chartHeight - (data[i].expenses / maxExpenses) * chartHeight / 1.4;
      if (data[i].expenses > 600) {
        paint.color = MySavingColors.defaultRed;
      }

      // Drawing bar
      final radius = Radius.circular(55);

      final barRect = RRect.fromLTRBR(
        x,
        y.isNaN ? chartHeight : y,
        x + barWidth,
        chartHeight,
        radius,
      );
      canvas.drawRRect(barRect, paint);

      // Drawing text below bars
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
