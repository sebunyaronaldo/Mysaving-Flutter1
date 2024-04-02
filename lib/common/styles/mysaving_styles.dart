import 'package:flutter/material.dart';
import 'package:mysavingapp/common/utils/mysaving_colors.dart';

class MySavingStyles {
  late MySavingColors mySavingColors;
  MySavingStyles(BuildContext context) {}
  void init(BuildContext context) {}
  BoxDecoration get mysavingButtonContainerStyles =>
      BoxDecoration(borderRadius: BorderRadius.circular(20), color: MySavingColors.defaultBlueButton);
  ButtonStyle get mysavingButtonStyles =>
      ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent);
  TextStyle get mysavingInputTextStyles => TextStyle(color: MySavingColors.defaultGreyText, fontSize: 15);
  OutlineInputBorder get mysavingInputBorderStyle => OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        width: 0.5,
        color: MySavingColors.defaultInputStroke,
      ));
  TextStyle get mysavingAuthTitleStyle =>
      TextStyle(color: MySavingColors.defaultDarkText, fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w800);
  TextStyle get mysavingNavNameStyle =>
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MySavingColors.defaultDarkText);
  TextStyle get mysavingDashboardSummaryTitleStyle => TextStyle(
        color: Color(0xFF969696),
        fontSize: 13,
      );
  BoxDecoration get mysavingDashboardButtonsContainerStyle =>
      BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.transparent);
  ButtonStyle get mysavingDashboardButtonsButtonStyle => ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 3, color: MySavingColors.defaultExpensesText),
          borderRadius: BorderRadius.circular(25)),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent);
  TextStyle get mysavingDashboardSectionTitle =>
      TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: MySavingColors.defaultDarkText);
  OutlineInputBorder get mysavingExpensesAddingFormInputBorder => OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(14),
      );
}
