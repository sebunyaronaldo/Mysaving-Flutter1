import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../common/utils/mysaving_colors.dart';

class CustomPieChart extends StatelessWidget {
  final List<int> expenses;

  CustomPieChart(this.expenses);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PieChartPainter(expenses),
      size: Size.infinite,
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<int> expenses;
  final assetImagesFolder = 'assets/images/chart/';
  final padding = 5.0;

  PieChartPainter(this.expenses);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = (size.width < size.height ? size.width : size.height) / 2;

    final totalExpenses = expenses.reduce((a, b) => a + b);
    double startAngle = 0;

    for (var i = 0; i < expenses.length; i++) {
      final expensePercentage = expenses[i] / totalExpenses;
      final sweepAngle = expensePercentage * 360;

      // Drawing background ring
      final color = _getBackgroundColor(i);
      final outerRadius = radius - padding;
      final innerRadius = radius - padding - 30; // Adjust the inner radius as needed

      final outerRect = Rect.fromCircle(center: Offset(centerX, centerY), radius: outerRadius);
      final innerRect = Rect.fromCircle(center: Offset(centerX, centerY), radius: innerRadius);

      final startAngleRadians = _degreesToRadians(startAngle);
      final sweepAngleRadians = _degreesToRadians(sweepAngle);

      canvas.drawArc(outerRect, startAngleRadians, sweepAngleRadians, true, Paint()..color = color);
      canvas.drawArc(
        innerRect,
        startAngleRadians,
        sweepAngleRadians,
        true,
        Paint()..color = MySavingColors.defaultBackgroundPage,
      );

      startAngle += sweepAngle;
    }
  }

  Color _getBackgroundColor(int index) {
    final colors = [
      MySavingColors.defaultBlueText,
      MySavingColors.defaultGreen,
      MySavingColors.defaultRed,
      MySavingColors.defaultPurple,
      MySavingColors.defaultOrange,
    ];

    // Sprawdzamy, czy wydatek ma wartość 0
    if (expenses[index] == 0) {
      return Colors.grey; // Ustawiamy kolor szary dla wydatków o wartości 0
    } else {
      return colors[index % colors.length];
    }
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
