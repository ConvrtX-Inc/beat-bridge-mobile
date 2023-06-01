import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/users/login_reg_model.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/utils/helpers/form_helper.dart';
import 'package:beatbridge/utils/helpers/text_helper.dart';
import 'package:beatbridge/utils/helpers/validator_helper.dart';
import 'package:beatbridge/utils/logout_helper.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/shared_preferences_service.dart';
import 'package:beatbridge/utils/services/text_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

const FlutterSecureStorage storage = FlutterSecureStorage();

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
  final TextEditingController queueNameTxtController = TextEditingController();

  final ValidatorHelper _globalValidator = ValidatorHelper();
  String PrefUser = '';
  String _username = '';
  String _email = '';
  String _phoneNumber = '';
  String _password = '';
  String _confirmPassword = '';
  String? UserImage = '';
  bool _isAPICallInProgress = false;
  List<String> errorMessages = <String>[];

  TextServices textServices = TextServices();

  /// Variables
  // ImagePicker picker = ImagePicker();
  // XFile? image;
  // File? f = null;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    queueNameTxtController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    regCheck();
    checkGps();
    getpermission();
    // encoder();

    setValue(_username);
  }

  void regCheck() {
    setState(() {});
  }

  getpermission() async {
    var permission = await Permission.location.request();
    if (permission.isDenied) {
      getpermission();
    }
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
          AppTextConstants.createAccount,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColorConstants.roseWhite,
              fontSize: 22),
        ),
        SizedBox(height: 63.h),

        InkWell(
          onTap: encoder,
          child: Center(
            child: Stack(children: [
              Container(
                height: 200,
                width: 200,
                child: Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(120))),
                    elevation: 0.0,
                    color: const Color.fromARGB(136, 34, 34, 34),
                    child: Global.imagetemppath != null
                        ? ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(120)),
                            child: Image.file(
                              Global.imagetemppath!,
                              fit: BoxFit.cover,
                              height: 150,
                              width: 150,
                            ))
                        : Image.asset("assets/images/Union.png")),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(130, 150, 0, 0),
                child: IconButton(
                    onPressed: encoder,
                    icon: Image.asset("assets/images/camera.png")),
              )
            ]),
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
        Text(
          'Phone Number',
          style: TextStyle(
            color: AppColorConstants.roseWhite,
            // fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'GilroyBold',
          ),
        ),
        SizedBox(height: 20.h),

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
          // countries: const <String>['PH'],
          initialCountryCode: 'PH',
          onChanged: (PhoneNumber phone) {
            setState(() {
              _phoneNumber = phone.completeNumber;
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
            AppTextConstants.ConfirmPassword,
            AppTextConstants.ConfirmPassword, (String onValidateValue) {
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
          buttonText: AppTextConstants.submit,
          isLoading: _isAPICallInProgress,
          buttonCallback: () async {
            Global.username = _usernameController.text;
            setValue(AppTextConstants.username.toString());
            FocusScope.of(context).requestFocus(FocusNode());
            if (validateAndSave()) {
              setState(() {
                _isAPICallInProgress = true;
                errorMessages = <String>[];
              });
              // print(_phonenumber);
              if (_imageBase64 == null) {
                _imageBase64 = "";
                log('""""  $_imageBase64 """"""');

                final UserModelTwo userModelParams = UserModelTwo(
                    username: _username,
                    email: _email,
                    image: _imageBase64,
                    password: _password,
                    phoneNumber: _phoneNumber,
                    latitude: '$lat',
                    longitude: '$long');
                print(
                    "registration model: ${userModelParams.latitude} : ${userModelParams.longitude}");
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
                  final UserModelTwo user = UserModelTwo.fromJson(
                      json.decode(result.successResponse));
                  UserSingleton.instance.user = user;

                  await storage.write(
                      key: 'tempRegResponse',
                      value: result.successResponse.toString());
                  log(user.token.toString());

                  await storage.write(
                      key: 'userAuthToken', value: user.token.toString());
                  await storage.write(
                      key: 'username', value: user!.username.toString());
                  await storage.write(
                      key: 'email', value: user!.email.toString());
                  await storage.write(
                      key: 'phone_no', value: user!.phoneNo.toString());
                  await storage.write(
                      key: 'userID', value: user!.id.toString());
                  await storage.write(
                      key: 'password', value: user!.password.toString());
                  await storage.write(
                      key: 'profileimage', value: user!.image.toString());

                  await Navigator.pushNamedAndRemoveUntil(context,
                      '/link_landing_page', (Route<dynamic> route) => false);
                }
              } else {
                print('""""  image 64 not null""""""');
                final UserModelTwo userModelParams = UserModelTwo(
                    username: _username,
                    email: _email,
                    image: _imageBase64,
                    password: _password,
                    phoneNumber: _phoneNumber,
                    latitude: lat,
                    longitude: long);
                print(
                    "registration model: ${userModelParams.latitude} : ${userModelParams.longitude}");

                final APIStandardReturnFormat result =
                    await APIServices().register(userModelParams);
                print("register response: $result");

                // ERROR HANDLING
                if (result.status == 'error') {
                  final Map<String, dynamic> decoded =
                      jsonDecode(result.errorResponse);
                  decoded['errors'].forEach((String k, dynamic v) => <dynamic>{
                        errorMessages..add(textServices.filterErrorMessage(v))
                      });
                } else {
                  // final UserValidResponse user = UserValidResponse.fromJson(
                  //     json.decode(result.successResponse));
                  final UserModelTwo user = UserModelTwo.fromJson(
                      json.decode(result.successResponse));
                  UserSingleton.instance.user = user;

                  await storage.write(
                      key: 'tempRegResponse',
                      value: result.successResponse.toString());
                  log(user.token.toString());

                  await storage.write(
                      key: 'userAuthToken', value: user.token.toString());
                  await storage.write(
                      key: 'username', value: user!.username.toString());
                  await storage.write(
                      key: 'email', value: user!.email.toString());
                  await storage.write(
                      key: 'phone_no', value: user!.phoneNo.toString());
                  await storage.write(
                      key: 'userID', value: user!.id.toString());
                  await storage.write(
                      key: 'password', value: user!.password.toString());
                  await storage.write(
                      key: 'profileimage', value: user!.image.toString());
                  // setState(() {
                  //                     UserSingleton.instance.user = user;
                  // });

                  await Navigator.pushNamedAndRemoveUntil(context,
                      '/link_landing_page', (Route<dynamic> route) => false);
                }
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

  Future<void> setValue(value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('username', PrefUser);
  }

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {
      //refresh UI
      long = position.longitude.toString();
      lat = position.latitude.toString();
    });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      setState(() {
        //refresh UI on update
      });
    });
  }

  Future<void> encoder() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    Uint8List imageByte = await image.readAsBytes();
    String base64 = base64Encode(imageByte);

    setState(() {
      _imageBase64 = base64;
      Global.imagetemppath = File(image.path);
      ImagePicked = ImageFile;
      this.ImageFile = Global.imagetemppath;
      Utility.saveImage(
          Utility.base64String(Global.imagetemppath.readAsBytesSync()));
    });
    print("==============================]]]]]");
    print(_imageBase64);
    // Global.imagetemppath =  File(image.path);
  }

  File? ImageFile;
  File? ImagePicked;
  var _imageBase64;
}
