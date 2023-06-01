import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/utils/helpers/form_helper.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class VerifyNumberScreen extends StatefulWidget {
  const VerifyNumberScreen({Key? key}) : super(key: key);

  @override
  _VerifyNumberScreenState createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends State<VerifyNumberScreen> {
  TextEditingController _numberController = TextEditingController();

  String _number = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColorConstants.mirage,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(child: Form(child: _verifyNumberUI())),
        ),
      ),
    );
  }

  Widget _verifyNumberUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 41.h),
        IconButton(
          padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          icon: Icon(Icons.arrow_back_ios,color: AppColorConstants.roseWhite,),onPressed: (){
              Navigator.of(context).pop();
            },
        ),
        SizedBox(height: 36.h), 
        Text(
            'Enter Your Phone Number',
            style: TextStyle(
              fontFamily: 'Gilroy-Bold',
                fontWeight: FontWeight.w800,
                color: AppColorConstants.roseWhite,
                fontSize: 22),
          ),
        
        SizedBox(height: 50.h),
        // FormHelper.inputFieldWidgetWithController(
        //
        //     context, AppTextConstants.regPhone, AppTextConstants.regPhone,
        //
        //     (onValidateValue) {
        //   if (onValidateValue.isEmpty) {
        //     return '${AppTextConstants.username} cannot be empty';
        //   }
        //   return null;
        // }, (onSavedValue) {
        //   _number = onSavedValue.toString().trim();
        // },
        //     separatorHeight: 15,
        //     controller: _numberController,
        //     keyType: TextInputType.number,
        //     inputPlaceholder: '+923027859077'),
        IntlPhoneField(
          controller: _numberController,
          style: TextStyle(color: Colors.white, fontSize: 18.r),
          dropdownTextStyle: TextStyle(color: Colors.white, fontSize: 18.r),
          dropdownIcon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            counterStyle: const TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color: AppColorConstants.paleSky, width: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            filled: true,
            hintStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColorConstants.roseWhite.withOpacity(0.5)),
            fillColor: AppColorConstants.paleSky.withOpacity(0.12),
            contentPadding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 24.h),
          ),
          // countries: const <String>['PH'],
          initialCountryCode: 'PH',
          onChanged: (PhoneNumber phone) {
            setState(() {
              _number = phone.completeNumber;
            });
          },
        ),
            SizedBox(height: 10.h),
        Text(
           'Enter your phone number and we\'\ll send an verification code to reset your password.',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColorConstants.roseWhite,
                fontSize: 14),
          ),
        SizedBox(
          height: 80.h,
        ),
        ButtonRoundedGradient(
          buttonText: 'Verify Account',
          buttonCallback: () {
            Navigator.pushReplacementNamed(context, '/number_verification_code');
          },
        )
      ],
    );
  }
}
