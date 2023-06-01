import 'package:beatbridge/constants/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Widget for gradient rounded button
class ButtonRoundedGradient extends StatelessWidget {
  /// Constructor
  const ButtonRoundedGradient(
      {Key? key,
      this.buttonText = 'submit',
      this.buttonCallback,
      this.isLoading = false,
      this.custom = false,
      this.fontFamily = '',
      this.fontSize = 0,
      this.fontWeight = FontWeight.normal,
      this.letterSpacing = 0,
      this.buttonTextColor = Colors.white,
      this.buttonColor = Colors.transparent,
      this.width = double.infinity})
      : super(key: key);

  /// Button text
  final String buttonText;

  /// Check if loading
  final bool isLoading;

  /// custom button properties
  final bool custom;
  final double fontSize;
  final FontWeight fontWeight;
  final String fontFamily;
  final double letterSpacing;
  final double width;

  /// Button text color
  final Color buttonTextColor;

  /// button background color
  final Color buttonColor;

  /// function to call for navigation between screens
  final VoidCallback? buttonCallback;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: buttonCallback,
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11.5.r))),
      child: Ink(
        decoration:
            // buttonColor ==

            // Colors.transparent ?
            BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-0.5, 0),
                  colors: <Color>[
                    AppColorConstants.artyClickPurple,
                    AppColorConstants.rubberDuckyYellow
                  ],
                ),
                borderRadius: BorderRadius.circular(11.5.r)),
        // BoxDecoration(
        //     color: buttonColor,
        //     borderRadius: BorderRadius.circular(11.5.r)),
        child: isLoading
            ? Container(
                width: width,
                height: 61,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      color: buttonTextColor,
                    ),
                    SizedBox(width: 24.w),
                    Text(
                      AppTextConstants.pleaseWait.toUpperCase(),
                      style: TextStyle(
                          color: buttonTextColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          fontFamily: AppTextConstants.gilroyBold),
                    ),
                  ],
                ),
              )
            : Container(
                width: width,
                height: 61,
                alignment: Alignment.center,
                child: Text(
                  custom ? buttonText : buttonText.toUpperCase(),
                  style: TextStyle(
                      color: buttonTextColor,
                      fontSize: custom ? fontSize : 16.sp,
                      fontWeight: custom ? fontWeight : FontWeight.w800,
                      letterSpacing: custom ? letterSpacing : 1,
                      fontFamily: custom ? fontFamily : 'Gilroy-bold'),
                ),
              ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('buttonText', buttonText));
    properties.add(DiagnosticsProperty('buttonCallback', buttonCallback));
    properties.add(ColorProperty('buttonTextColor', buttonTextColor));
    properties.add(DiagnosticsProperty<bool>('isLoading', isLoading));
  }
}
