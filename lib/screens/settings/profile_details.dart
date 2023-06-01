import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:beatbridge/constants/api_path.dart';
import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/helpers/basehelper.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/users/login_reg_model.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/utils/approutes.dart';
import 'package:beatbridge/utils/helpers/form_helper.dart';
import 'package:beatbridge/utils/helpers/text_helper.dart';
import 'package:beatbridge/utils/helpers/validator_helper.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/text_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/logout_helper.dart';
import 'package:http/http.dart' as http;

const FlutterSecureStorage storage = FlutterSecureStorage();

/// Screen for register input
class ProfileDetails extends StatefulWidget {
  /// Constructor
  const ProfileDetails({Key? key}) : super(key: key);

  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  static final GlobalKey<FormState> registerGlobalFormKey =
      GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _confirmPasswordController =
  //       TextEditingController();
  final ValidatorHelper _globalValidator = ValidatorHelper();

  String _username = '';
  String _email = '';
  // String _phoneNumber = '';
  // String _password = '';
  // String _confirmPassword = '';
  bool _isAPICallInProgress = false;
  List<String> errorMessages = <String>[];

  TextServices textServices = TextServices();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  String _newPassword = '';
  String _confirmPassword = '';
///////
  ///
  ///
  ///
  Future<dynamic> UpdatePassword() async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final String? userAuthToken = await storage.read(key: 'userAuthToken');
    final String? userIdd = await secureStorage.read(key: 'userID');

    print("token: $userAuthToken");

    log(userIdd.toString());

    var _body = <String, dynamic>{
      "username": "${Global.username.toString()}",
      "email": "${Global.usermail.toString()}",
      "phone_number": "${Global.password.toString()}",
      "password": "${_passwordController.text.toString()}"
    };
    print("make admin body: $_body");
    var body = jsonEncode(_body);
    print("make admin body: $body");
    var url = "${BaseHelper().baseUrl}/api/v1/users/${userIdd.toString()}";
    print("url of update profile admin: $url");
    final http.Response response = await http.patch(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',

        // 'content-type': 'application/json'
      },
      body: _body,
    );

    print("making admin: ${response.body}");
    var jsons = json.decode(response.body);
    print("updating profile: ${jsons}");
    setState(() {
      _isAPICallInProgress = false;
      errorMessages = <String>[];
    });
    if (response.statusCode == 200) {
      AppRoutes.pop(context);

      Fluttertoast.showToast(
          msg: "Succussfully updated",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.grey,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Something went wrong with api!",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.grey,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  // void UpdatePassword() async {
  //   var dio = Dio();
  //   final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  //   final String? userAuthToken = await storage.read(key: 'userAuthToken');
  //   final String? userIdd = await secureStorage.read(key: 'userID');
  //   try {
  //     a
  //     var body = ;
  //     var responce2 = await dio.patch(
  //       'https://beat.softwarealliancetest.tk/api/v1/users/$userIdd',
  //       data: body,
  //       // {'password': _confirmPasswordController.value.toJSON()},
  //       options: Options(
  //         // method: 'GET',

  //         headers: {
  //           HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
  //           'content-Type': 'application/json'
  //         },
  //       ),
  //     );
  //     print("Getting responce 2");
  //     print(responce2.data);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    regCheck();
    _asyncMethod();
  }

  void regCheck() {
    setState(() {});
  }

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
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 15.w),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

        SizedBox(height: 26.h),
        Text(
          AppTextConstants.newPassword,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColorConstants.roseWhite,
              fontSize: 22),
        ),

        SizedBox(height: 63.h),
        if(Global.username.toString() != null)
        FormHelper.inputFieldWidgetWithController(
            context, AppTextConstants.username, AppTextConstants.username,
            enabled:
                false, // it for enable or disabel changes in textform field
            inputPlaceholder: Global.username.toString(),
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
            keyType: TextInputType.name)
        else
          FormHelper.inputFieldWidgetWithController(
              context, AppTextConstants.username, AppTextConstants.username,
              enabled:
              false, // it for enable or disabel changes in textform field
              inputPlaceholder: '',
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
        if(mail.toString()!=null)
        FormHelper.inputFieldWidgetWithController(
            context, AppTextConstants.regEmail, AppTextConstants.regEmail,
            enabled:
                false, // it for enable or disabel changes in textform field
            inputPlaceholder: mail.toString(), (String onValidateValue) {
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
            keyType: TextInputType.emailAddress)
        else
          FormHelper.inputFieldWidgetWithController(
          context, AppTextConstants.regEmail, AppTextConstants.regEmail,
          enabled:
          false, // it for enable or disabel changes in textform field
          inputPlaceholder: '', (String onValidateValue) {
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


    // working area remaining

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
          _newPassword = onSavedValue.toString().trim();
        },
            separatorHeight: 15,
            controller: _passwordController,
            obscureText: true,
            keyType: TextInputType.visiblePassword),
        SizedBox(height: 36.h),
        FormHelper.inputFieldWidgetWithController(
            context,
            AppTextConstants.reTypeNewPassword,
            AppTextConstants.reTypeNewPassword, (String onValidateValue) {
          if (onValidateValue.isEmpty) {
            return '${AppTextConstants.reTypeNewPassword} cannot be empty';
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
          buttonText: 'update',
          isLoading: _isAPICallInProgress,
          buttonCallback: () async {
            if (_passwordController.text == _confirmPasswordController.text &&
                _passwordController.text.trim().isNotEmpty &&
                _confirmPasswordController.text.trim().isNotEmpty) {
              setState(() {
                _isAPICallInProgress = true;
                errorMessages = <String>[];
              });
              UpdatePassword();
            }

            FocusScope.of(context).requestFocus(FocusNode());
            if (validateAndSave()) {
              setState(() {
                _isAPICallInProgress = true;
                errorMessages = <String>[];
              });
              // print(_phonenumber);
              final UserModelTwo userModelParams = UserModelTwo(
                  username: _username,
                  email: _email,
                  password: _newPassword,
                  phoneNumber: _confirmPassword,
                  latitude: '0',
                  longitude: '0');
              // need to add lan and log

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
                final UserValidResponse user = UserValidResponse.fromJson(
                    json.decode(result.successResponse));

                await storage.write(
                    key: 'tempRegResponse',
                    value: result.successResponse.toString());
                log(user.token.toString());

                await storage.write(
                    key: 'userAuthToken', value: user.token.toString());
                await storage.write(
                    key: 'username', value: user.user!.username.toString());
                await storage.write(
                    key: 'email', value: user.user!.email.toString());
                await storage.write(
                    key: 'phone_no', value: user.user!.phoneNo.toString());
                await storage.write(
                    key: 'userID', value: user.user!.id.toString());

                await Navigator.pushNamedAndRemoveUntil(context,
                    '/link_landing_page', (Route<dynamic> route) => false);
              }
            }

            setState(() {
              _isAPICallInProgress = false;
            });
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (String item in errorMessages) TextHelper.errorTextDisplay(item)
          ],
        ),
// working area remaining

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

  String? mail;

  _asyncMethod() async {
    log("initState Called");
    final String? userAuthToken = await storage.read(key: 'userAuthToken');
    final String? spotifyAuthToken =
        await storage.read(key: 'spotifyAuthToken');
    Global.usermail = await storage.read(key: 'email');
    Global.username = await storage.read(key: 'username');
    Global.password = await storage.read(key: 'phone_no');
    setState(() {
      mail = Global.usermail;
    });
  }
}
