import 'package:flutter/material.dart';

import '../utils/mysaving_colors.dart';

class MySavingContentTitle extends StatelessWidget {
  const MySavingContentTitle({super.key, required this.contentTitle});
  final String contentTitle;
  @override
  Widget build(BuildContext context) {
    return Text(
      contentTitle,
      style: TextStyle(color: MySavingColors.defaultGreyText),
    );
  }
}
