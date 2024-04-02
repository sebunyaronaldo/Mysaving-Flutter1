import 'package:flutter/material.dart';
import 'package:mysavingapp/common/utils/mysaving_colors.dart';
import '../theme/theme_constants.dart';

class MySavingHeader extends StatelessWidget {
  const MySavingHeader({super.key, required this.informationHeader});
  final String informationHeader;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MySavingColors.defaultBackgroundPage,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: DarkModeSwitch.isDarkMode ? Colors.white : Colors.black,
                    )),
                //SizedBox(width: 50),
                Text(
                  informationHeader,
                  style: TextStyle(color: MySavingColors.defaultDarkText, fontSize: 19),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
