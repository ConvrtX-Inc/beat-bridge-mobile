import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/utils/helpers/form_helper.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({Key? key}) : super(key: key);

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  String _newPassword = '';
  String _confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColorConstants.mirage,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(child: Form(child: _newPasswordUI())),
        ),
      ),
    );
  }

  Widget _newPasswordUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 41.h,
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: IconButton(icon: Icon(Icons.arrow_back_ios,color: AppColorConstants.roseWhite,),onPressed: (){
              Navigator.of(context).pop();
            },)
        ),
        SizedBox(height: 36.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 11.w),
          child: Text(
            AppTextConstants.enterNewPasswordTitle,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColorConstants.roseWhite,
                fontSize: 22),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        FormHelper.inputFieldWidgetWithController(
          context,
          AppTextConstants.newPassword,
          AppTextConstants.newPassword,
          (dynamic onValidateValue) {
            if (onValidateValue.isEmpty) {
              return '${AppTextConstants.password} ${AppTextConstants.cannotBeEmpty}';
            }
            if (onValidateValue.length < 6) {
              return '${AppTextConstants.password} ${AppTextConstants.mustBeAtLeast6Chars}';
            }
            if (_newPasswordController.text !=
                _confirmPasswordController.text) {
              return AppTextConstants.passwordDoesNotMatch;
            }
            return null;
          },
          (String onSavedValue) {
            _newPassword = onSavedValue.toString().trim();
          },
          separatorHeight: 15,
          controller: _newPasswordController,
          obscureText: true,
        ),
        SizedBox(
          height: 20.h,
        ),
        FormHelper.inputFieldWidgetWithController(
          context,
          AppTextConstants.confirmPassword,
          AppTextConstants.confirmPassword,
          (dynamic onValidateValue) {
            if (onValidateValue.isEmpty) {
              return '${AppTextConstants.password} ${AppTextConstants.cannotBeEmpty}';
            }
            if (onValidateValue.length < 6) {
              return '${AppTextConstants.password} ${AppTextConstants.mustBeAtLeast6Chars}';
            }
            if (_newPasswordController.text !=
                _confirmPasswordController.text) {
              return AppTextConstants.passwordDoesNotMatch;
            }
            return null;
          },
          (String onSavedValue) {
            _newPassword = onSavedValue.toString().trim();
          },
          separatorHeight: 15,
          controller: _confirmPasswordController,
          obscureText: true,
        ),
        SizedBox(
          height: 30.h,
        ),
         ButtonRoundedGradient(buttonCallback: (){
           Navigator.of(context).pop();

        },)
      ],
    );
  }
}
