import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/utils/hexColor.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({Key? key}) : super(key: key);

  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final TextEditingController _verificationCodeController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColorConstants.mirage,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(child: _verificationCodeUI()),
        ),
      ),
    );
  }

  Widget _verificationCodeUI() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 41.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.w),
            child: Text(
              AppTextConstants.verificationCodeTitle,
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColorConstants.roseWhite,
                  fontSize: 22),
            ),
          ),
          SizedBox(
            height: 21.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.w),
            child: Text(
              AppTextConstants.verificationCodeDescription,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColorConstants.roseWhite,
                  fontSize: 16),
            ),
          ),
          SizedBox(
            height: 31.h,
          ),
          PinCodeTextField(
            appContext: context,
            length: 4,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            textStyle: const TextStyle(color: Colors.white),
            onChanged: (String val) {},
            cursorHeight: 10.w,
            animationType: AnimationType.none,
            controller: _verificationCodeController,
            cursorColor: HexColor('#8200FF'),
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.underline,
                activeColor: HexColor('#8200FF'),
                selectedFillColor: HexColor('#A53DB7'),
                inactiveColor: HexColor('#F6C615'),
                selectedColor: HexColor('#CD8166'),
                borderRadius: BorderRadius.circular(16)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 21.h),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${AppTextConstants.resendCode} 120s',
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColorConstants.roseWhite,
                    fontSize: 14),
              ),
            ),
          ),
          ButtonRoundedGradient(
            buttonCallback: () {
              Navigator.pushReplacementNamed(context, '/new_password');
            },
          )
        ]);
  }
}
