import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mysavingapp/common/utils/mysaving_colors.dart';

class SettingsButton extends StatelessWidget {
  SettingsButton(
      {super.key,
      required this.buttonText,
      required this.buttonMethod,
      required this.iconColor,
      required this.containerColor,
      required this.icon});
  final String buttonText;
  final void Function()? buttonMethod;
  final Color containerColor;
  final Color iconColor;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
          // Twój wybrany kolor tła
          ),
      child: InkWell(
        onTap: buttonMethod,
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
                child: Icon(icon, color: iconColor), // Ikona wewnątrz kwadracika
              ),
              Gap(20),
              SizedBox(
                width: 150,
                child: AutoSizeText(
                  buttonText,
                  style: TextStyle(
                    color: MySavingColors.defaultGreyText,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ]),
            Icon(
              Icons.arrow_forward_ios,
              color: MySavingColors.defaultGreyText,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }
}
