import 'package:beatbridge/constants/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Widget for gradient rounded button
class ButtonRoundedGradient extends StatelessWidget {
  /// Constructor
  const ButtonRoundedGradient({Key? key, this.buttonText = 'submit'})
      : super(key: key);

  /// Button text
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print('Hi there');
      },
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r))),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: <Color>[
              AppColorConstants.artyClickPurple,
              AppColorConstants.rubberDuckyYellow
            ]),
            borderRadius: BorderRadius.circular(10.r)),
        child: Container(
          width: double.infinity,
          height: 60,
          alignment: Alignment.center,
          child: Text(
            buttonText.toUpperCase(),
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 1),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('buttonText', buttonText));
  }
}
