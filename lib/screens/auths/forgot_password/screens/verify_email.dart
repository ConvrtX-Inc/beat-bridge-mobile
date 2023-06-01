import 'dart:convert';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/utils/helpers/form_helper.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import '../../../../models/verifyEmail.dart';

TextEditingController emailController = TextEditingController();


class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final GlobalKey<FormState> _key = GlobalKey();




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
        SizedBox(height: 41.h),
        IconButton(
          padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          icon: Icon(Icons.arrow_back_ios,color: AppColorConstants.roseWhite,),onPressed: (){
                Navigator.of(context).pop();
              }
            ),
        SizedBox(height: 36.h),
          Text(
            'Enter Your Email Address',
            style: TextStyle(
              fontFamily: 'Gilroy-Bold',
                fontWeight: FontWeight.w800,
                color: AppColorConstants.roseWhite,
                fontSize: 22),
          ),
       
        SizedBox(height: 50.h),
        Form(
          key: _key,
          child: FormHelper.inputFieldWidgetWithController(
              context, AppTextConstants.email, AppTextConstants.email,
              (onValidateValue) {
            if (onValidateValue.isEmpty) {
              return '${AppTextConstants.emailverify} cannot be empty';
            }
            return null;
          },
                (onSavedValue) {
            _email = onSavedValue.toString().trim();
          },
              separatorHeight: 15,
              controller: emailController,
              inputPlaceholder: AppTextConstants.enterEmail,),
        ),
             SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 11.w),
          child: Text(
            'Enter your email address and we\'\ll send an verification code to reset your password.',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColorConstants.roseWhite,
                fontSize: 14),
          ),
        ),
        SizedBox(
          height: 30.h,
        ),
        ButtonRoundedGradient(
          buttonText: 'Verify Account',
          buttonCallback: () {
            print('Verify Account');
            // Navigator.pushReplacementNamed(context, '/verification_code');
            if(_key.currentState!.validate())
              {
                verfyEmail();
              }

          },
        )
      ],
    );
  }

  /////////VERIFY EMAIL

 Future<verifyEmailModel?> verfyEmail() async{
    var headers = {
      'Content-Type': 'application/json'
    };
    ///////
    try{
      final response = await http.post(
        Uri.parse("https://beat.softwarealliancetest.tk/api/v1/auth/forgot/password"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'),
        body: {
          "email": emailController.text
        },
      );
      ////////////////////
      verifyEmailModel verifyemailmodel = verifyEmailModel.fromJson(jsonDecode(response.body));
      if(response.statusCode==200){
        if(verifyemailmodel.message == "Email Sent"){
          print('Email exist');
          Navigator.pushReplacementNamed(context, '/verification_code');
        }
      }
      else if(response.statusCode==500){
        final snackBar = SnackBar( content: Text('Internal server error'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      else if(response.statusCode==422){
        final snackBar = SnackBar( content: Text('User does not exists'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      else{
        final snackBar = SnackBar( content: Text('Socket exception'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    catch(e){
      print(e);
    }

  }
}
