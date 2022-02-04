import 'dart:async';
import 'dart:convert';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/utils/helpers/form_helper.dart';
import 'package:beatbridge/utils/helpers/text_helper.dart';
import 'package:beatbridge/utils/helpers/validator_helper.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/text_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

/// Screen for register input
class RegisterInputScreen extends StatefulWidget {
  /// Constructor
  const RegisterInputScreen({Key? key}) : super(key: key);

  @override
  _RegisterInputScreenState createState() => _RegisterInputScreenState();
}

class _RegisterInputScreenState extends State<RegisterInputScreen> {
  static final GlobalKey<FormState> registerGlobalFormKey =
      GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final ValidatorHelper _globalValidator = ValidatorHelper();

  String _username = '';
  String _email = '';
  String _phonenumber = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isAPICallInProgress = false;
  List<String> errorMessages = <String>[];

  TextServices textServices = TextServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Form(
            key: registerGlobalFormKey,
            child: _registerUI(context),
          ),
        ),
      ),
    );
  }

  Widget _registerUI(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 41.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 15.w),
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
            (String onValidateValue) {
          if (onValidateValue.isEmpty) {
            return '${AppTextConstants.username} cannot be empty';
          }
          return null;
        }, (String onSavedValue) {
          _username = onSavedValue.toString().trim();
        },
            separatorHeight: 15,
            controller: _usernameController,
            // inputPlaceholder: AppTextConstants.pasteSongLinkHere,
            keyType: TextInputType.name),
        SizedBox(height: 36.h),
        FormHelper.inputFieldWidgetWithController(
            context, AppTextConstants.regEmail, AppTextConstants.regEmail,
            (String onValidateValue) {
          if (onValidateValue.isEmpty) {
            return '${AppTextConstants.regEmail} cannot be empty';
          }
          if (!_globalValidator.isValidEmail(onValidateValue)) {
            return AppTextConstants.invalidEmailFormat;
          }
          return null;
        }, (String onSavedValue) {
          _email = onSavedValue.toString().trim();
        },
            separatorHeight: 15,
            controller: _emailTextController,
            keyType: TextInputType.emailAddress),
        SizedBox(height: 36.h),
        // FormHelper.inputFieldWidgetWithController(
        //     context, AppTextConstants.regPhone, AppTextConstants.regPhone,
        //     (String onValidateValue) {
        //   if (onValidateValue.isEmpty) {
        //     return '${AppTextConstants.regPhone} cannot be empty';
        //   }
        //   return null;
        // }, (String onSavedValue) {
        //   _phonenumber = onSavedValue.toString().trim();
        // },
        //     separatorHeight: 15,
        //     controller: _phoneTextController,
        //     keyType: TextInputType.phone),
        IntlPhoneField(
          controller: _phoneTextController,
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
          countries: const <String>['PH'],
          initialCountryCode: 'PH',
          onChanged: (PhoneNumber phone) {
            setState(() {
              _phonenumber = phone.completeNumber;
            });
          },
        ),
        SizedBox(height: 36.h),
        FormHelper.inputFieldWidgetWithController(
            context, AppTextConstants.password, AppTextConstants.password,
            (String onValidateValue) {
          if (onValidateValue.isEmpty) {
            return '${AppTextConstants.password} ${AppTextConstants.cannotBeEmpty}';
          }
          if (onValidateValue.length < 6) {
            return '${AppTextConstants.password} ${AppTextConstants.mustBeAtLeast6Chars}';
          }
          if (_passwordController.text != _confirmPasswordController.text) {
            return AppTextConstants.passwordDoesNotMatch;
          }
          return null;
        }, (String onSavedValue) {
          _password = onSavedValue.toString().trim();
        },
            separatorHeight: 15,
            controller: _passwordController,
            obscureText: true,
            keyType: TextInputType.visiblePassword),
        SizedBox(height: 36.h),
        FormHelper.inputFieldWidgetWithController(
            context,
            AppTextConstants.confirmPassword,
            AppTextConstants.confirmPassword, (String onValidateValue) {
          if (onValidateValue.isEmpty) {
            return '${AppTextConstants.confirmPassword} cannot be empty';
          }
          if (_passwordController.text != _confirmPasswordController.text) {
            return AppTextConstants.passwordDoesNotMatch;
          }
          return null;
        }, (String onSavedValue) {
          _confirmPassword = onSavedValue.toString().trim();
        },
            separatorHeight: 15,
            controller: _confirmPasswordController,
            obscureText: true,
            keyType: TextInputType.visiblePassword),
        SizedBox(height: 43.h),
        ButtonRoundedGradient(
          buttonText: AppTextConstants.submit,
          isLoading: _isAPICallInProgress,
          buttonCallback: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            if (validateAndSave()) {
              setState(() {
                _isAPICallInProgress = true;
                errorMessages = <String>[];
              });
              print(_phonenumber);
              final UserModel userModelParams = UserModel(
                  username: _username,
                  email: _email,
                  password: _password,
                  phoneNumber: _phonenumber);

              final APIStandardReturnFormat result =
                  await APIServices().register(userModelParams);

              // ERROR HANDLING
              if (result.status == 'error') {
                final Map<String, dynamic> decoded =
                    jsonDecode(result.errorResponse);
                decoded['errors'].forEach((String k, dynamic v) => <dynamic>{
                      errorMessages..add(textServices.filterErrorMessage(v))
                    });
              } else {
                await Navigator.pushNamedAndRemoveUntil(context,
                    '/link_landing_page', (Route<dynamic> route) => false);
              }
            }

            setState(() {
              _isAPICallInProgress = false;
            });
          },
        ),
        SizedBox(height: 10.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (String item in errorMessages) TextHelper.errorTextDisplay(item)
          ],
        ),
        SizedBox(height: 41.h),
      ],
    );
  }

  bool validateAndSave() {
    final FormState? form = registerGlobalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>(
          'isAPICallInProgress', _isAPICallInProgress))
      ..add(IterableProperty<String>('errorMessages', errorMessages))
      ..add(DiagnosticsProperty<TextServices>('textServices', textServices));
  }
}
