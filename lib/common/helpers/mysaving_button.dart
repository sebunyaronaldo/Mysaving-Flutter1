import 'package:flutter/material.dart';

import '../styles/mysaving_styles.dart';

class MySavingButton extends StatelessWidget {
  const MySavingButton({super.key, required this.onPressed, required this.buttonTitle});
  final Function onPressed;
  final String buttonTitle;
  @override
  Widget build(BuildContext context) {
    var msstyles = MySavingStyles(context);

    return Container(
      height: 44,
      width: 250,
      decoration: msstyles.mysavingButtonContainerStyles,
      child:
          ElevatedButton(style: msstyles.mysavingButtonStyles, onPressed: () => onPressed(), child: Text(buttonTitle)),
    );
  }
}
