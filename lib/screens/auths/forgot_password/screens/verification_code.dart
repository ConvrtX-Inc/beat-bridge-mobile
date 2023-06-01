// ignore_for_file: public_member_api_docs

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/models/verifyEmail.dart';
import 'package:beatbridge/screens/auths/forgot_password/screens/verify_email.dart';
import 'package:beatbridge/utils/hexColor.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../models/verifyOtp.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var code;
bool isLoading = false;


class VerificationCodeScreen extends StatefulWidget {
const VerificationCodeScreen({super.key});

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
        body: SingleChildScrollView(child:Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(child: _verificationCodeUI()),
        )),
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
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(Icons.arrow_back_ios,color: AppColorConstants.roseWhite,),onPressed: (){
                Navigator.of(context).pop();
              },
          ),
          SizedBox(height: 36.h),
           Text(
              AppTextConstants.verificationCodeTitle,
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColorConstants.roseWhite,
                  fontFamily: 'Gilroy-Bold',
                  fontSize: 22),
            ),

          SizedBox(
            height: 31.h,
          ),
          Padding(
                padding:
                    const EdgeInsets.only(top: 35),
                child: PinCodeTextField(
                  textStyle: TextStyle(color:AppColorConstants.roseWhite),
                  length: 4,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _verificationCodeController,
                  appContext: context,
                  autoFocus: true,

                  keyboardType: TextInputType.number,
                  animationType: AnimationType.slide,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    fieldHeight: 77,

                    fieldWidth: 78,
                    borderWidth: 1,
                    borderRadius:BorderRadius.circular(5),
                    selectedColor:AppColorConstants.artyClickPurple,
                    selectedFillColor: AppColorConstants.verificationFieldColor,
                    inactiveFillColor:AppColorConstants.verificationFieldColor,
                    inactiveColor:AppColorConstants.verificationFieldColor,
                    activeColor:AppColorConstants.verificationFieldColor,
                    activeFillColor:AppColorConstants.verificationFieldColor,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  onSaved: (value){
                    code = _verificationCodeController.value.text;
                  },
                  onChanged: (String val){
                    code = val;
                  },
                  beforeTextPaste: (text) => true,
                ),
              ),

          Text(
              AppTextConstants.verificationCodeEmail,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColorConstants.roseWhite,
                  fontSize: 16),
            ),
          SizedBox(
            height: 100.h,
          ),
              ButtonRoundedGradient(
            buttonCallback: () {
              print('ZAITOOOOOOM111');
              print('----------------');
              setState(() {
              _verificationCodeController.text.toString();

              });
              print(_verificationCodeController);
              if (_verificationCodeController.text.isEmpty) {
                                _showDialog();


              }
              else {
                print('ZAITOOOOOOM111');
                verfyOtp();


              }
            },
          ),
          SizedBox(
            height: 15.h,
          ),
          Center(
            child: Visibility(
              visible: isLoading,
              child: CircularProgressIndicator(color: Colors.white54),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Didn't receive code?",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 14),
              ),

                  GestureDetector(
                    onTap: (){
                      print('Your press resend button');
                      setState(() {
                        isLoading = true; // Set isLoading state to true
                      });
                      verfyEmail().then((_) {
                        // Once the verification is complete, set isLoading state to false
                        setState(() {
                          isLoading = false;
                        });
                      });
                    },
                    child: Text(
                      ' Resend',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xffAB47AD),
                          fontSize: 14),
                    ),
                  ),

            ],
          ),

        ]);
  }
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Align(
            alignment: Alignment.centerLeft,
              child: Text("Enter OTP",)),
          // content: new Text("Inter OTP"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
           
          ],
        );
      },
    );
  }

  /////////VERIFY OTP

  Future<verifyOtpModel?> verfyOtp() async{
    var headers = {
      'Content-Type': 'application/json'
    };
    ///////
    final response = await http.post(
      Uri.parse("https://beat.softwarealliancetest.tk/api/v1/auth/otp/verify"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
      body: {
        "hash": _verificationCodeController.value.text
      },
    );
    ////////////////////
    verifyOtpModel verifyeotpmodel = verifyOtpModel.fromJson(jsonDecode(response.body));
    if(response.statusCode==200){
      if(verifyeotpmodel.status == 200){
        print('OTP Verified');
        Navigator.pushReplacementNamed(context, '/new_password');
      }
    }
    else{
      print('Wrong OTP');
      final snackBar = SnackBar( content: Text('Wrong Otp'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }
  }
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
