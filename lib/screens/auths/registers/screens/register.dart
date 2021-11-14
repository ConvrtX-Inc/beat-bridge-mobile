import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/utils/helpers/form_helper.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Screen for register input
class RegisterInputScreen extends StatefulWidget {
  /// Constructor
  const RegisterInputScreen({Key? key}) : super(key: key);

  @override
  _RegisterInputScreenState createState() => _RegisterInputScreenState();
}

class _RegisterInputScreenState extends State<RegisterInputScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailOrPhoneNumberController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _username = '';
  String _emailOrPhoneNumber = '';
  String _password = '';
  String _confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 41.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(Icons.arrow_back_ios,
                      color: Colors.white, size: 15.w),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              SizedBox(height: 26.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 11.w),
                child: Text(
                  AppTextConstants.createAccount,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColorConstants.roseWhite,
                      fontSize: 22),
                ),
              ),
              SizedBox(height: 63.h),
              FormHelper.inputFieldWidgetWithController(
                  context, AppTextConstants.username, AppTextConstants.username,
                  (onValidateValue) {
                if (onValidateValue.isEmpty) {
                  return '${AppTextConstants.username} cannot be empty';
                }
                return null;
              }, (onSavedValue) {
                _username = onSavedValue.toString().trim();
              },
                  separatorHeight: 15,
                  controller: _usernameController,
                  inputPlaceholder: AppTextConstants.pasteSongLinkHere),
              SizedBox(height: 36.h),
              FormHelper.inputFieldWidgetWithController(
                context,
                AppTextConstants.emailOrPhoneNumber,
                AppTextConstants.emailOrPhoneNumber,
                (onValidateValue) {
                  if (onValidateValue.isEmpty) {
                    return '${AppTextConstants.emailOrPhoneNumber} cannot be empty';
                  }
                  return null;
                },
                (onSavedValue) {
                  _emailOrPhoneNumber = onSavedValue.toString().trim();
                },
                separatorHeight: 15,
                controller: _emailOrPhoneNumberController,
              ),
              SizedBox(height: 36.h),
              FormHelper.inputFieldWidgetWithController(
                context,
                AppTextConstants.password,
                AppTextConstants.password,
                (onValidateValue) {
                  if (onValidateValue.isEmpty) {
                    return '${AppTextConstants.password} cannot be empty';
                  }
                  return null;
                },
                (onSavedValue) {
                  _password = onSavedValue.toString().trim();
                },
                separatorHeight: 15,
                controller: _passwordController,
                obscureText: true,
              ),
              SizedBox(height: 36.h),
              FormHelper.inputFieldWidgetWithController(
                context,
                AppTextConstants.confirmPassword,
                AppTextConstants.confirmPassword,
                (onValidateValue) {
                  if (onValidateValue.isEmpty) {
                    return '${AppTextConstants.confirmPassword} cannot be empty';
                  }
                  return null;
                },
                (onSavedValue) {
                  _confirmPassword = onSavedValue.toString().trim();
                },
                separatorHeight: 15,
                controller: _confirmPasswordController,
                obscureText: true,
              ),
              SizedBox(height: 43.h),
              ButtonRoundedGradient(buttonText: AppTextConstants.submit),
              SizedBox(height: 41.h),
            ],
          ),
        ),
      ),
    );
  }
}
