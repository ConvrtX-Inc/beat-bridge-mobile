import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/users/login_reg_model.dart';
import 'package:beatbridge/screens/main_navigations/links/screens/test_spot.dart';
import 'package:beatbridge/screens/main_navigations/make_queues/screens/make_queue_screen.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/queue_playing_screen.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/recent_queue.dart';
import 'package:beatbridge/screens/spotify/spotify_test.dart';
import 'package:beatbridge/screens/walk_throughs/screens/walk_through.dart';
import 'package:beatbridge/widgets/images/static_image_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../../../utils/logout_helper.dart';

const FlutterSecureStorage storage = FlutterSecureStorage();
bool nextScreen = false;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenScreenState createState() => _SplashScreenScreenState();
}

/// Splash screen
class _SplashScreenScreenState extends State<SplashScreen> {
  /// Constructor
  // const SplashScreen({Key? key}) : super(key: key);

  // //final String? userObj = await storage.read(key: 'userObj');
  // Future init() async {
  //   final String? userObj = await storage.read(key: 'userObj');
  //   if (userObj != null) {
  //     log('splash');
  //     log(userObj.toString());
  //   }
  // }

  bool isLogin = false;
  @override
  String? valueCheck;

  initState() {
    super.initState();
    // valueChecker();
    getpermission();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _asyncMethod();
      subcriptionStatus();
    });
  }

  getpermission() async {
    var permission = await Permission.location.request();
    if (permission.isDenied) {
      // await Fluttertoast.showToast(
      //   msg: 'Please turn on your location Thank you!',
      //   gravity: ToastGravity.CENTER,
      //   backgroundColor: Colors.blu
      // );
      getpermission();
    }
  }

  subcriptionStatus() async {
    var status = await SpotifySdk.subscribeUserStatus();
    // print("subscription status: ${status.}");
  }

  final timer = Timer(
    const Duration(seconds: 3),
    () {
      // Navigate to your favorite place
    },
  );

  _asyncMethod() async {
    log("initState Called");
    final String? userAuthToken = await storage.read(key: 'userAuthToken');
    final String? userID = await storage.read(key: 'userID');
    final String? spotifyAuthToken =
        await storage.read(key: 'spotifyAuthToken');
    Global.userObj = await storage.read(key: 'userObj');

    if (Global.userObj != null) {
      setState(() {
        isLogin = true;
      });
    } else {
      return null;
    }

    // if (userAuthToken != null) {
    //   log(userAuthToken);
    // }

    // if (userID != null) {
    //   log(userID);
    // }

    //       Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => RecentQueues(),
    //       ));

    //   log(isLogin.toString());
    //   log(userAuthToken.toString());
    //   log(spotifyAuthToken.toString());
  }

  @override
  Widget build(BuildContext context) {
    //init(); //calling to init object
    return ImageStaticBackground(
        imagePath:
            '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.splashScreenBackground}',
        childWidget: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              Expanded(
                child: AnimatedSplashScreen(
                  backgroundColor: Colors.transparent,
                  splash: Image.asset(
                      '${AssetsPathConstants.assetsPNGPath}/app_logo_colored_slogan.png'),
                  splashIconSize: 220,
                  nextScreen:
                      isLogin == true ? RecentQueues() : WalkThroughScreen(),
                  // isLogin==true ?   WalkThroughScreen() : RecentQueues(),
                  //nextScreen: MakeYourQueueScreen(),
                  // splashTransition: SplashTransition.fadeTransition,
                  pageTransitionType: PageTransitionType.rightToLeftWithFade,
                ),
              ),
            ],
          ),
        ));
  }

  void valueChecker() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    valueCheck = pref.getString('username');
    if (valueCheck != null) {
      final timer = Timer(
        const Duration(seconds: 2),
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const RecentQueues(),
            ),
          );
        },
      );
    } else {
      final timer = Timer(
        const Duration(seconds: 3),
        () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const WalkThroughScreen(),
              ));
        },
      );
    }
  }
}
