import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/screens/walk_throughs/screens/walk_through.dart';
import 'package:beatbridge/widgets/images/static_image_background.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

/// Splash screen
class SplashScreen extends StatelessWidget {
  /// Constructor
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  nextScreen: const WalkThroughScreen(),
                  splashTransition: SplashTransition.fadeTransition,
                  pageTransitionType: PageTransitionType.rightToLeftWithFade,
                ),
              ),
            ],
          ),
        ));
  }
}
