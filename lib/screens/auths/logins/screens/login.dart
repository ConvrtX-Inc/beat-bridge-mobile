import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/screens/walk_throughs/widgets/slider_tile.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Screen for login
class LoginScreen extends StatelessWidget {
  /// Constructor
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            bottom: 120.h,
            right: 23.w,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 58,
              child: ButtonAppRoundedButton(
                buttonText: AppTextConstants.createAccount,
                buttonCallback: () {
                  Navigator.of(context).pushNamed('/register');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
