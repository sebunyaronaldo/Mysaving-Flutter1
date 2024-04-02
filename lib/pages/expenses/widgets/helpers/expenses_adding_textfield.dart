import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../common/styles/mysaving_styles.dart';
import '../../../../common/utils/mysaving_colors.dart';

class ExpensesAddingTextField extends StatelessWidget {
  const ExpensesAddingTextField(
      {super.key,
      required this.hintText,
      required this.textFieldController,
      required this.formatter,
      required this.textInputType,
      this.validator});
  final String hintText;
  final TextEditingController textFieldController;
  final List<TextInputFormatter> formatter;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    var msstyles = MySavingStyles(context);

    return SizedBox(
      width: 250,
      child: Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 5.0,
        shadowColor: MySavingColors.defaultBlueButton,
        child: TextFormField(
          style: TextStyle(color: MySavingColors.defaultDarkText),
          inputFormatters: formatter,
          controller: textFieldController,
          keyboardType: textInputType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: msstyles.mysavingInputTextStyles,
            filled: true,
            fillColor: MySavingColors.defaultCategories,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            border: msstyles.mysavingExpensesAddingFormInputBorder,
          ),
          validator: validator,
        ),
      ),
    );
  }
}
