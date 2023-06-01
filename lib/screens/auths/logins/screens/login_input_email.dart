import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/users/login_reg_model.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/screens/auths/logins/screens/login_input.dart';
import 'package:beatbridge/utils/helpers/form_helper.dart';
import 'package:beatbridge/utils/helpers/text_helper.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/text_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';

import '../../../main_navigations/queues/screens/recent_queue.dart';
import 'login_method.dart';

const FlutterSecureStorage storage = FlutterSecureStorage();

///Login input screen
class LoginInputEmailScreen extends StatefulWidget {
  ///Constructor
  const LoginInputEmailScreen({Key? key}) : super(key: key);

  @override
  _LoginInputEmailScreenState createState() => _LoginInputEmailScreenState();
}

class _LoginInputEmailScreenState extends State<LoginInputEmailScreen> {
  // String _username = '';
  String _email = '';
  String _password = '';
  bool _isAPICallInProgress = false;
  List<String> errorMessages = <String>[];

  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> loginFormGlobalKey = GlobalKey<FormState>();
  TextServices textServices = TextServices();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkGps();
  }

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
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 15.w),
          onPressed: () {
            Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginMethodScreen(),
                ));
          },
        ),
        SizedBox(height: 26.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          child: Text(
            AppTextConstants.logIn,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColorConstants.roseWhite,
                fontFamily: 'Gilroy-Bold',
                fontSize: 22),
          ),
        ),
        SizedBox(height: 63.h),
        FormHelper.inputFieldWidgetWithController(
          context,
          AppTextConstants.regEmail,
          AppTextConstants.regEmail,
          (String onValidateValue) {
            if (onValidateValue.isEmpty) {
              return '${AppTextConstants.regEmail} cannot be empty';
            }
            return null;
          },
          (String onSavedValue) {
            _email = onSavedValue.toString().trim();
          },
          separatorHeight: 15,
          controller: _emailController,
          keyType: TextInputType.emailAddress,
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
          keyType: TextInputType.name,
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
        SizedBox(height: 130.h),
        // InkWell(
        //   onTap: () => Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => LoginInputScreen(),
        //       )),
        //   child: Center(
        //     child: Text(
        //       'Use Phone Number Instead',
        //       textAlign: TextAlign.center,
        //       style: TextStyle(
        //           color: AppColorConstants.roseWhite,
        //           fontSize: 14,
        //           fontFamily: 'Gilroy-Regular'),
        //     ),
        //   ),
        // ),
        SizedBox(height: 30.h),
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
                  .loginWithEmail(_email, _password, lat, long)
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
                  print("login response: ${response.successResponse}");
                  final UserModelTwo user = UserModelTwo.fromJson(
                      json.decode(response.successResponse));
                  UserSingleton.instance.user = user;

                  // final UserValidResponse user = UserValidResponse.fromJson(
                  //     json.decode(response.successResponse));

                  await storage.write(
                      key: 'userAuthToken', value: user.token.toString());
                  await storage.write(key: 'username', value: user.username);
                  await storage.write(key: 'email', value: user.email);
                  await storage.write(key: 'phone_no', value: user.phoneNo);
                  await storage.write(key: 'userID', value: user.id);
                  await storage.write(key: 'profileimage', value: user.image);

                  await storage.write(
                      key: 'userObj',
                      value: json.encode(response.successResponse));

                  final String? userObj = await storage.read(key: 'userObj');
                  log('loggedin');
                  log(user.username.toString());
                  log(userObj.toString());
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecentQueues(),
                    ),
                  );
                  // await Navigator.pushReplacementNamed(
                  //     context, '/recent_queues');
                }
              });
            }
          },
        ),
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
