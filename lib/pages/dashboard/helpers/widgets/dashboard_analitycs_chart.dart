import 'package:flutter/material.dart';
import '../../../../common/utils/mysaving_colors.dart';
import '../../../../data/models/dashboard_model.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerticalBarChartPainter extends CustomPainter {
  final List<DashboardAnalitycsDay> data;
  final DateTime currentDate; // Dzisiejsza data
  final int maxExpensesPerDay;
  final BuildContext context; // Pass the context as a parameter

  VerticalBarChartPainter(this.data, this.currentDate, this.maxExpensesPerDay, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = 6.0;
    final barSpacing = 45.0;
    final maxExpenses = data.map((day) => day.expenses).reduce((a, b) => a > b ? a : b);
    final chartHeight = size.height;
    final chartWidth = (barWidth + barSpacing) * data.length - barSpacing;
    final paint = Paint()..style = PaintingStyle.fill;

    // Drawing intersecting lines
    for (var i = 0; i < data.length; i++) {
      final x = i * (barWidth + barSpacing) + (size.width - chartWidth) / 2;

      // Drawing expense limit lines
      paint.color = Colors.grey;
      paint.strokeWidth = 1.0;
      final y1 = chartHeight / 2.9;
      final y2 = chartHeight / 2;
      final y3 = chartHeight / 1.5;
      final y4 = chartHeight / 1.2;
      final y5 = chartHeight / 1.02;
      canvas.drawLine(Offset(x, y1), Offset(x + barWidth, y1), paint);
      canvas.drawLine(Offset(x, y2), Offset(x + barWidth, y2), paint);
      canvas.drawLine(Offset(x, y3), Offset(x + barWidth, y3), paint);
      canvas.drawLine(Offset(x, y4), Offset(x + barWidth, y4), paint);
      canvas.drawLine(Offset(x, y5), Offset(x + barWidth, y5), paint);
    }

    final maxHeight = chartHeight / 1.5;
    // Get the current date as a DateTime object

    for (var i = 0; i < data.length; i++) {
      final x = i * (barWidth + barSpacing) + (size.width - chartWidth) / 2;

      // Check if expenses are NaN or null, and if so, set them to 0
      final expenses = data[i].expenses.isNaN ? 0 : data[i].expenses;
      // Calculate the position for the value above the bar
      final valueX = x + barWidth / 2;
      final valueY = chartHeight - (expenses / maxExpenses) * maxHeight - 15 - 5 / 2;
      // Sprawdź, czy data z bazy jest dzisiejsza
      DateTime now = DateTime.now();
      // Przekształć datę z bazy danych na datę w twojej lokalnej strefie czasowej

      // Drawing bars
      final y = chartHeight - (expenses / maxExpenses) * maxHeight;
      String name = intl.DateFormat('EEEE').format(now);
      if (data[i].name == name) {
        if (expenses >= maxExpensesPerDay) {
          paint.color = MySavingColors.defaultRed;
        } else {
          paint.color = MySavingColors.defaultGreen;
        }
      } else if (expenses >= maxExpensesPerDay) {
        paint.color = MySavingColors.defaultRed;
      } else {
        paint.color = MySavingColors.defaultExpensesText;
      }

      final radius = Radius.circular(55);

      final barRect = RRect.fromLTRBR(
        x,
        y.isNaN ? chartHeight : y,
        x + barWidth,
        chartHeight,
        radius,
      );
      canvas.drawRRect(barRect, paint);
      Color textColor;
      if (getTranslatedDayName(data[i].name!) == getTranslatedDayName(name)) {
        // Jeśli data jest dzisiejsza
        if (data[i].expenses >= maxExpensesPerDay) {
          // Jeśli wydatki przekroczyły limit, koloruj na czerwono
          textColor = MySavingColors.defaultRed;
        } else {
          // W przeciwnym razie koloruj na zielono
          textColor = MySavingColors.defaultGreen;
        }
      } else {
        // Jeśli to nie jest dzisiejsza data
        textColor =
            data[i].expenses >= maxExpensesPerDay ? MySavingColors.defaultRed : MySavingColors.defaultExpensesText;
      }
      // Drawing text below bars
      final textStyle = TextStyle(
        color: textColor,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      );
      // Replace PaintContext with the actual class that provides the context.

      final textSpan = TextSpan(
        text: getTranslatedDayName(data[i].name!) == getTranslatedDayName(name)
            ? AppLocalizations.of(context)!.dashboardAnalitycsToday
            : getTranslatedDayName(data[i].name!),
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textX = x + (barWidth - textPainter.width) / 2;
      final textY = chartHeight + 5;
      final offset = Offset(textX, textY);
      textPainter.paint(canvas, offset);

      // Calculate the position for the value (kwota) above the bar
      final valueStyle = TextStyle(
        color: textColor,
        fontSize: 12,
      );
      final valueText = '${data[i].expenses}';
      final valueSpan = TextSpan(
        text: valueText,
        style: valueStyle,
      );
      final valuePainter = TextPainter(
        text: valueSpan,
        textDirection: TextDirection.ltr,
      );
      valuePainter.layout();

      final valuesX = valueX - valuePainter.width / 2;
      final valuesY = valueY.isNaN ? chartHeight : valueY; // Ensure Y is not NaN
      final valueOffset = Offset(valuesX, valuesY);
      valuePainter.paint(canvas, valueOffset);
    }
  }

  String getTranslatedDayName(String dayName) {
    final daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final translatedDaysOfWeek = [
      AppLocalizations.of(context)!.dashboardAnalitycsMonday,
      AppLocalizations.of(context)!.dashboardAnalitycsTuesday,
      AppLocalizations.of(context)!.dashboardAnalitycsWednesday,
      AppLocalizations.of(context)!.dashboardAnalitycsThursday,
      AppLocalizations.of(context)!.dashboardAnalitycsFriday,
      AppLocalizations.of(context)!.dashboardAnalitycsSaturday,
      AppLocalizations.of(context)!.dashboardAnalitycsSunday,
    ];

    final index = daysOfWeek.indexOf(dayName);
    if (index != -1) {
      return translatedDaysOfWeek[index];
    }
    return dayName;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
