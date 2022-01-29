// ignore_for_file: avoid_classes_with_only_static_members

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Utility for form helper
class FormHelper {
  /// Widget for form input field with controller
  static Widget inputFieldWidgetWithController(BuildContext context,
      String keyName, String labelName, Function onValidate, Function onSaved,
      {required TextEditingController controller,
      String initialValue = '',
      bool obscureText = false,
      String inputPlaceholder = '',
      double separatorHeight = 16,
      dynamic minLines,
      dynamic maxLines = 1,
      TextInputType keyType = TextInputType.multiline}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          labelName,
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              fontFamily: AppTextConstants.gilroyBold,
              color: Colors.white),
        ),
        SizedBox(height: separatorHeight.h),
        TextFormField(
          controller: controller,
          keyboardType: keyType,
          minLines: minLines,
          maxLines: maxLines,
          key: Key(keyName),
          obscureText: obscureText,
          obscuringCharacter: AppTextConstants.asterisk,
          validator: (String? val) {
            return onValidate(val);
          },
          onSaved: (String? val) {
            return onSaved(val);
          },
          style: TextStyle(color: Colors.white, fontSize: 18.r),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColorConstants.paleSky, width: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              filled: true,
              hintStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColorConstants.roseWhite.withOpacity(0.5)),
              hintText: inputPlaceholder,
              fillColor: AppColorConstants.paleSky.withOpacity(0.12),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 24.h)),
        ),
      ],
    );
  }

  /// Widget for logins button form
  static Widget buttonWidget(
    String buttonText,
    Function onTap,
    bool isLoading,
  ) {
    return ButtonAppRoundedButton(
        isLoading: isLoading,
        buttonText: buttonText,
        buttonCallback: () {
          onTap();
        });
  }

  /// Widget for logins button form
  static Widget buttonWidgetGradient(
    String buttonText,
    Function onTap,
    bool isLoading,
  ) {
    return ButtonRoundedGradient(
      isLoading: isLoading,
      buttonText: buttonText,
      buttonCallback: () {
        onTap();
      },
    );
  }
}
