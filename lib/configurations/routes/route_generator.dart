// ignore_for_file: avoid_classes_with_only_static_members
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/screens/main_navigations/Queue/screens/queue_playing_screen.dart';
import 'package:flutter/material.dart';

/// Route generator configuration
class RouteGenerator {
  /// Generate route function
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final Object? args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute<dynamic>(
            builder: (_) => AnimatedSplashScreen(
                  splash:
                      '${AssetsPath.assetsPNGPath}/app_logo_colored_slogan.png',
                  splashIconSize: 220,
                  duration: 5000,
                  splashTransition: SplashTransition.slideTransition,
                  // pageTransitionType: PageTransitionType.scale,
                  backgroundColor: AppColorConstants.stratos,
                  nextScreen: const QueuePlayingScreen(),
                ));
      case '/queue_playing_screen':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const QueuePlayingScreen());
      default:
        return _errorRoute();
    }
  }

  /// Route for erroneous navigation
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute<dynamic>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
