import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///App Outlined Button
class AppOutlinedButton extends StatelessWidget {
  ///Constructor
  const AppOutlinedButton(
      {Key? key,
      Color btnColor = const Color.fromRGBO(166, 70, 255, 0.29),
      Color btnTextColor = Colors.white,
      String btnText = '',
      double btnHeight = 36,
        bool isLoading = false,
      Color btnOutlineColor = const Color(0xFF8201FF),
      this.btnCallback})
      : _btnColor = btnColor,
        _btnOutlineColor = btnOutlineColor,
        _btnTextColor = btnTextColor,
        _btnText = btnText,
        _btnHeight = btnHeight,
        _isLoading = isLoading,
        super(
          key: key,
        );

  final Color _btnColor;
  final Color _btnOutlineColor;
  final Color _btnTextColor;
  final String _btnText;
  final double _btnHeight;
  final bool _isLoading;

  ///Callback for button
  final VoidCallback? btnCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 14, 0, 0),
        height: _btnHeight,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: btnCallback,
          autofocus: true,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(_btnColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: _btnOutlineColor, width: 1.5)),
              )),
          child: _isLoading ?
              Center( child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: _btnTextColor,
                  strokeWidth: 2,
                ),
              ))
                : Text(_btnText,
              style:
              TextStyle(color: _btnTextColor, fontWeight: FontWeight.bold)),
        ));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(ObjectFlagProperty<VoidCallback?>.has('btnCallback', btnCallback));
  }
}
