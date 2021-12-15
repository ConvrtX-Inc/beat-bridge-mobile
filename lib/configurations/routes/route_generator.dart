// ignore_for_file: avoid_classes_with_only_static_members
import 'package:beatbridge/screens/auths/logins/screens/login.dart';
import 'package:beatbridge/screens/auths/logins/screens/login_input.dart';
import 'package:beatbridge/screens/auths/registers/screens/register.dart';
import 'package:beatbridge/screens/main_navigations/links/screens/link_landing_page.dart';
import 'package:beatbridge/screens/main_navigations/links/screens/select_platform_to_link.dart';
import 'package:beatbridge/screens/main_navigations/links/screens/test_spot.dart';
import 'package:beatbridge/screens/main_navigations/make_queues/screens/make_queue_screen.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/queue_playing_screen.dart';
import 'package:beatbridge/screens/settings/profile_settings.dart';
import 'package:beatbridge/screens/splashes/screens/splash_screen.dart';
import 'package:flutter/material.dart';

/// Route generator configuration
class RouteGenerator {
  /// Generate route function
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final Object? args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute<dynamic>(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute<dynamic>(builder: (_) => const LoginScreen());
      case '/login_input':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const LoginInputScreen());
      case '/register':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const RegisterInputScreen());
      case '/link_landing_page':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const LinkLandingPageScreen());
      case '/queue_playing_screen':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const QueuePlayingScreen());
      case '/make_your_queue_screen':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const MakeYourQueueScreen());
      case '/select_platform':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const SelectPlatformToLink());
      case '/test_spotify':
        return MaterialPageRoute<dynamic>(builder: (_) => const TestSpot());
      case '/profile-settings':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const ProfileSettigs());
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
