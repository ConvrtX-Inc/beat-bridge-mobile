import 'package:beatbridge/constants/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Global Widget for app rounded button
class ButtonAppRoundedButton extends StatelessWidget {
  /// Constructor
  const ButtonAppRoundedButton(
      {Color firstBGColor = Colors.white,
      Color secondBGColor = Colors.white,
      double radius = 12,
      String buttonText = '',
      Color buttonColor = Colors.black,
      bool showIcon = false,
      IconData icon = Icons.mail,
      Color iconColor = Colors.black,
      double iconSize = 24,
      bool isLoading = false,
      Key? key,
      this.buttonCallback})
      : _firstBGColor = firstBGColor,
        _secondBGColor = secondBGColor,
        _radius = radius,
        _buttonText = buttonText,
        _buttonColor = buttonColor,
        _showIcon = showIcon,
        _icon = icon,
        _iconColor = iconColor,
        _iconSize = iconSize,
        _isLoading = isLoading,
        super(key: key);

  final Color _firstBGColor;
  final Color _secondBGColor;
  final double _radius;
  final String _buttonText;
  final Color _buttonColor;
  final bool _showIcon;
  final IconData _icon;
  final Color _iconColor;
  final double _iconSize;
  final bool _isLoading;

  /// function to call for navigation between screens
  final dynamic buttonCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const <double>[0, 1],
          colors: <Color>[_firstBGColor, _secondBGColor],
        ),
        color: Colors.deepPurple.shade300,
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius),
            ),
          ),
          // minimumSize: MaterialStateProperty.all(Size(width, 50)),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          // elevation: MaterialStateProperty.all(3),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: buttonCallback,
        child: _isLoading
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      color: _buttonColor,
                    ),
                    SizedBox(width: 24.w),
                    Text(
                      'Please wait...',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.w,
                        color: _buttonColor,
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 21.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (_showIcon)
                      Icon(
                        _icon,
                        color: _iconColor,
                        size: _iconSize,
                      ),
                    SizedBox(width: 10.w),
                    Text(
                      // AppTextConstants.continueWithEmail,
                      _buttonText.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        fontFamily: AppTextConstants.gilroyBold,
                        letterSpacing: 1.w,
                        color: _buttonColor,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}
