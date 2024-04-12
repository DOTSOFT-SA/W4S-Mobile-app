import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/sizer_utils.dart';

class TextFields extends ChangeNotifier {
  TextFields(
      {required this.textColor,
      required this.textFieldFillColor,
      required this.labelStyleColor,
      required this.labelTextColor,
      required this.borderEnabledColor,
      required this.borderFocusColor,
      required this.borderErrorColor,
      required this.errorTextColor});

  String field = '';
  bool formatSpaces = false;
  bool obscureText = false;
  bool valueIsInvalid = false;
  TextEditingController controller = TextEditingController();
  Color labelTextColor;
  Color labelStyleColor;
  BorderRadius borderErrorRadius = BorderRadius.circular(16);
  BorderRadius borderFocusRadius = BorderRadius.circular(16);
  BorderRadius borderEnabledRadius = BorderRadius.circular(16);
  Color borderFocusColor;
  Color borderErrorColor;
  Color borderEnabledColor;
  Color textFieldFillColor;
  Color errorTextColor;
  Color textColor;
  bool hasVisibilityIcon = false;
  int maxLines = 1;
  int minLines = 1;
  FocusNode myFocusNode = FocusNode();
  int characterLimit = -1;
  bool onlyNumbers = false;

  Widget customTextField(screenWidth, title, errorMessage) {
    return SizedBox(
      width: screenWidth,
      child: TextFormField(
        minLines: minLines,
        maxLines: maxLines,
        style: TextStyle(
            height: screenHeight * 0.0015,
            color: textColor,
            fontSize: 5.sp,
            fontWeight: FontWeight.bold),
        controller: controller,
        inputFormatters: [
          LengthLimitingTextInputFormatter(characterLimit),
          formatSpaces
              ? FilteringTextInputFormatter.deny(RegExp('[ ]'))
              : FilteringTextInputFormatter.deny(RegExp('[]')),
          onlyNumbers
              ? FilteringTextInputFormatter.digitsOnly
              : FilteringTextInputFormatter.deny(RegExp('[]')),
        ],
        focusNode: myFocusNode,
        obscureText: obscureText,
        onChanged: (text) {
          field = text;
          controller.notifyListeners();
        },
        decoration: InputDecoration(
          suffixIcon: hasVisibilityIcon
              ? InkWell(
                  onTap: () {
                    obscureText = !obscureText;
                  },
                  child: Icon(
                    !obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
          isDense: true,
          errorStyle: TextStyle(
              color: errorTextColor,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              fontSize: 3.sp),
          errorText: valueIsInvalid ? errorMessage : null,
          errorBorder: OutlineInputBorder(
              borderRadius: borderErrorRadius,
              borderSide: BorderSide(width: 0.5.sp, color: borderErrorColor)),
          filled: true,
          fillColor: textFieldFillColor,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          enabledBorder: OutlineInputBorder(
              borderRadius: borderEnabledRadius,
              borderSide: BorderSide(width: 0.5.sp, color: borderEnabledColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: borderFocusRadius,
              borderSide: BorderSide(width: 0.5.sp, color: borderFocusColor)),
        ),
      ),
    );
  }
}
