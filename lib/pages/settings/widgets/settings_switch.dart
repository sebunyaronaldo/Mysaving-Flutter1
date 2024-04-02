import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../common/utils/mysaving_colors.dart';

class SettingsSwitch extends StatelessWidget {
  const SettingsSwitch(
      {super.key,
      required this.buttonText,
      required this.containerColor,
      required this.iconColor,
      required this.switchValue,
      this.switchFunction});
  final String buttonText;
  final Color containerColor;
  final Color iconColor;
  final bool switchValue;
  final Function(bool)? switchFunction;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
          // Twój wybrany kolor tła
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(
              width: 50,
              height: 50,
              decoration: ShapeDecoration(
                color: containerColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Icon(switchValue ? Icons.dark_mode_outlined : Icons.sunny,
                  color: iconColor), // Ikona wewnątrz kwadracika
            ),
            Gap(20),
            Text(
              buttonText,
              style: TextStyle(
                color: MySavingColors.defaultGreyText,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ]),
          Switch.adaptive(value: switchValue, onChanged: switchFunction)
        ],
      ),
    );
  }
}
