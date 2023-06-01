import 'dart:convert';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/screens/auths/forgot_password/screens/verification_code.dart';
import 'package:beatbridge/utils/helpers/form_helper.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/verifyOtp.dart';
import 'package:http/http.dart' as http;


class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({Key? key}) : super(key: key);

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();


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
    return Form(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 41.h,
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColorConstants.roseWhite,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          SizedBox(height: 36.h),
          Text(
            AppTextConstants.enterNewPasswordTitle,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColorConstants.roseWhite,
                fontSize: 22),
          ),
          SizedBox(
            height: 55.h,
          ),
          FormHelper.inputFieldWidgetWithController(
            context,
            AppTextConstants.newPasswordd,
            AppTextConstants.newPasswordd,
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
            AppTextConstants.reTypeNewPassword,
            AppTextConstants.reTypeNewPassword,
            (dynamic onValidateValue) {
              if (onValidateValue.isEmpty) {
                return '${AppTextConstants.repassword} ${AppTextConstants.cannotBeEmpty}';
              }
              if (onValidateValue.length < 6) {
                return '${AppTextConstants.repassword} ${AppTextConstants.mustBeAtLeast6Chars}';
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
          ButtonRoundedGradient(
            // buttonText: 'UPDATE',
            buttonCallback: () {
              if(_key.currentState!.validate()){
                newPassword();
              }
              print('zzzz');
            },
          )
        ],
      ),
    );
  }
  Future<NewPasswordModel?>  newPassword() async{
    var headers = {
      'Content-Type': 'application/json'
    };
    ///////
    final response = await http.post(
      Uri.parse("https://beat.softwarealliancetest.tk/api/v1/auth/reset/password"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
      body: {
        "password": _newPasswordController.value.text,
        "hash": code
      },
    );
    ////////////////////
    NewPasswordModel newpasswordmodel = NewPasswordModel.fromJson(jsonDecode(response.body));
    if(response.statusCode==200){
      if(newpasswordmodel.status == 200){
        print('Password Updated');
        final snackBar = SnackBar( content: Text('Password updated sucessfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
      }
    }
    else{
      print('not updated');
      final snackBar = SnackBar( content: Text('not updated'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }

  }
}
