import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../../../../common/styles/mysaving_styles.dart';
import '../../../../../common/utils/mysaving_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileDialogContent extends StatelessWidget {
  const ProfileDialogContent(
      {super.key,
      required this.buttonMethod,
      required this.dialogTitle,
      required this.obscureText,
      this.controller,
      required this.icon,
      required this.hintText,
      required this.textInputType,
      required this.formatter});
  final Function buttonMethod;
  final String dialogTitle;
  final bool obscureText;
  final TextEditingController? controller;
  final IconData icon;
  final String hintText;
  final TextInputType textInputType;
  final List<TextInputFormatter> formatter;
  @override
  Widget build(BuildContext context) {
    var msstyles = MySavingStyles(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          color: MySavingColors.defaultBackgroundPage,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Text(
              dialogTitle,
              style: msstyles.mysavingDashboardSectionTitle,
            )),
            Gap(20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                inputFormatters: formatter,
                keyboardType: textInputType,
                style: TextStyle(color: MySavingColors.defaultDarkText),
                textAlignVertical: TextAlignVertical.bottom,
                obscureText: obscureText, // Hide or show password based on this flag
                controller: controller,

                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    icon,
                    color: MySavingColors.defaultBlueText,
                  ),
                  hintText: hintText,
                  hintStyle: msstyles.mysavingInputTextStyles,
                  focusedBorder: msstyles.mysavingInputBorderStyle,
                  enabledBorder: msstyles.mysavingInputBorderStyle,
                ),
              ),
            ),
            Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => buttonMethod(),
                  child: Text('${AppLocalizations.of(context)!.settingsPopupButtonSave}'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('${AppLocalizations.of(context)!.settingsPopupButtonCancel}'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
