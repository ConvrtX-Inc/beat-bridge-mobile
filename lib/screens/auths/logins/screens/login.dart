import 'dart:io';
import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/screens/walk_throughs/widgets/slider_tile.dart';
import 'package:beatbridge/utils/logout_helper.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../main.dart';
import '../../../../widgets/buttons/white_button.dart';
import '../../../main_navigations/queues/screens/see_all_queues.dart';

/// Screen for login
class LoginScreen extends StatefulWidget {
  /// Constructor

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    ValueCheck();
    _asyncMethod();
    _deleteCacheDir();
    _deleteAppDir();
  }

  @override
  Widget build(BuildContext context) {
    print('login screen is here');

    return Scaffold(
      backgroundColor: AppColorConstants.midnightPurple,
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: SliderTile(
                  isLogin: true,
                  backgroundImagePath:
                      '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.walkThroughBackground1}',
                  logoImagePath:
                      '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.appLogoWhite}',
                  topHeaderText: AppTextConstants.hassleFree,
                  bottomHeaderText: AppTextConstants.oneDeviceMillionSongs,
                  headerImagePath:
                      '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.loginColoredText}',
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 150.h,
            right: 23.w,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 48,
              child: ButtonRoundedWhite(
                // buttonColor: AppColorConstants.roseWhite,
                // buttonColor: Colors.red,
                buttonTextColor: Colors.black,
                buttonText: AppTextConstants.createAccount,
                buttonCallback: () {
                  Navigator.of(context).pushNamed('/register');
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SeeAllQueues()));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  ValueCheck() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  _asyncMethod() async {
    final String? userAuthToken = await storage.read(key: 'userAuthToken');
    final String? spotifyAuthToken =
        await storage.read(key: 'spotifyAuthToken');
    String? userObj = await storage.read(key: 'userObj');
    userObj == null;
    setState(() {
      Global.imagetemppath = null;
      Global.username = null;
    });
  }

  Future<void> _deleteCacheDir() async {
    Directory tempDir = await getTemporaryDirectory();
    print('delete storage');

    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
      print('delete cache');
    }
  }

  Future<void> _deleteAppDir() async {
    print('delete storage');
    Directory appDocDir = await getApplicationDocumentsDirectory();

    if (appDocDir.existsSync()) {
      appDocDir.deleteSync(recursive: true);
    }
  }
}
