import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/utils/helpers/form_helper.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  TextEditingController _emailController = TextEditingController();

  String _email = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColorConstants.mirage,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(child: Form(child: _verifyEmailUI())),
        ),
      ),
    );
  }

  Widget _verifyEmailUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 50.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 11.w),
          child: Text(
            AppTextConstants.verifyEmail,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColorConstants.roseWhite,
                fontSize: 22),
          ),
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 11.w),
          child: Text(
            AppTextConstants.verifyEmailDescription,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColorConstants.roseWhite,
                fontSize: 14),
          ),
        ),
        SizedBox(height: 30.h),
        FormHelper.inputFieldWidgetWithController(
            context, AppTextConstants.email, AppTextConstants.email,
            (onValidateValue) {
          if (onValidateValue.isEmpty) {
            return '${AppTextConstants.username} cannot be empty';
          }
          return null;
        }, (onSavedValue) {
          _email = onSavedValue.toString().trim();
        },
            separatorHeight: 15,
            controller: _emailController,
            inputPlaceholder: AppTextConstants.enterEmail),
        SizedBox(
          height: 30.h,
        ),
        ButtonRoundedGradient(
          buttonText: 'Verify',
          buttonCallback: () {
            Navigator.pushReplacementNamed(context, '/verification_code');
          },
        )
      ],
    );
  }
}
