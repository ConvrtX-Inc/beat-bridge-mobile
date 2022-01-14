import 'dart:async';
import 'dart:convert';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/utils/helpers/form_helper.dart';
import 'package:beatbridge/utils/helpers/text_helper.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/text_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///Login input screen
class LoginInputScreen extends StatefulWidget {
  ///Constructor
  const LoginInputScreen({Key? key}) : super(key: key);

  @override
  _LoginInputScreenState createState() => _LoginInputScreenState();
}

class _LoginInputScreenState extends State<LoginInputScreen> {
  String _username = '';
  String _password = '';
  bool _isAPICallInProgress = false;
  List<String> errorMessages = <String>[];

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> loginFormGlobalKey = GlobalKey<FormState>();
  TextServices textServices = TextServices();
  FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Form(
            key: loginFormGlobalKey,
            child: buildLoginInputUI(),
          ),
        ),
      ),
    );
  }

  Widget buildLoginInputUI() {
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
            AppTextConstants.logIn,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColorConstants.roseWhite,
                fontSize: 22),
          ),
        ),
        SizedBox(height: 63.h),
        FormHelper.inputFieldWidgetWithController(
          context,
          AppTextConstants.username,
          AppTextConstants.username,
          (String onValidateValue) {
            if (onValidateValue.isEmpty) {
              return '${AppTextConstants.username} cannot be empty';
            }
            return null;
          },
          (String onSavedValue) {
            _username = onSavedValue.toString().trim();
          },
          separatorHeight: 15,
          controller: _usernameController,
        ),
        SizedBox(height: 36.h),
        FormHelper.inputFieldWidgetWithController(
          context,
          AppTextConstants.password,
          AppTextConstants.password,
          (String onValidateValue) {
            if (onValidateValue.isEmpty) {
              return '${AppTextConstants.password} ${AppTextConstants.cannotBeEmpty}';
            }

            return null;
          },
          (String onSavedValue) {
            _password = onSavedValue.toString().trim();
          },
          separatorHeight: 15,
          controller: _passwordController,
          obscureText: true,
        ),
        SizedBox(height: 8.h),
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            child: Text('Forgot Password?',
                style: TextStyle(
                    color: AppColorConstants.roseWhite, letterSpacing: 1)),
            onPressed: () {
              Navigator.of(context).pushNamed('/verify_email');
            },
          ),
        ),
        ButtonRoundedGradient(
          buttonText: AppTextConstants.login,
          isLoading: _isAPICallInProgress,
          buttonCallback: () async {
            if (validateAndSave()) {
              setState(() {
                _isAPICallInProgress = true;
                errorMessages = <String>[];
              });
              await APIServices()
                  .login(_username, _password)
                  .then((APIStandardReturnFormat response) async {
                setState(() {
                  _isAPICallInProgress = false;
                });

                if (response.status == 'error') {
                  final Map<String, dynamic> decoded =
                      jsonDecode(response.errorResponse);
                  decoded['errors'].forEach((String k, dynamic v) => <dynamic>{
                        errorMessages..add(textServices.filterErrorMessage(v))
                      });
                } else {
                  final UserModel user =
                      UserModel.fromJson(json.decode(response.successResponse));
                  UserSingleton.instance.user = user;
                  
                  await Navigator.pushReplacementNamed(
                      context, '/recent_queues');
                }
              });
            }
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
    final FormState? form = loginFormGlobalKey.currentState;
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
      ..add(DiagnosticsProperty<GlobalKey<FormState>>(
          'loginFormGlobalKey', loginFormGlobalKey))
      ..add(IterableProperty<String>('errorMessages', errorMessages))
      ..add(DiagnosticsProperty<TextServices>('textServices', textServices))
      ..add(DiagnosticsProperty<FlutterSecureStorage>('storage', storage));
  }
}
