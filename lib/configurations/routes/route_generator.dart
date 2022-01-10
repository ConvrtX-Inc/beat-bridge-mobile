// ignore_for_file: avoid_classes_with_only_static_members
import 'package:beatbridge/models/users/queue_model.dart';
import 'package:beatbridge/screens/auths/forgot_password/screens/new_password.dart';
import 'package:beatbridge/screens/auths/forgot_password/screens/verification_code.dart';
import 'package:beatbridge/screens/auths/forgot_password/screens/verify_email.dart';
import 'package:beatbridge/screens/auths/logins/screens/login.dart';
import 'package:beatbridge/screens/auths/logins/screens/login_input.dart';
import 'package:beatbridge/screens/auths/registers/screens/register.dart';
import 'package:beatbridge/screens/main_navigations/links/screens/link_landing_page.dart';
import 'package:beatbridge/screens/main_navigations/links/screens/select_platform_to_link.dart';
import 'package:beatbridge/screens/main_navigations/links/screens/test_spot.dart';
import 'package:beatbridge/screens/main_navigations/make_queues/screens/make_queue_screen.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/all_queue.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/queue_details.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/queue_playing_screen.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/recent_queue.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/test_spotify.dart';
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
      case '/verify_email':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const VerifyEmailScreen());
      case '/new_password':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const NewPasswordScreen());
      case '/verification_code':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const VerificationCodeScreen());
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
      case '/recent_queues':
        return MaterialPageRoute<dynamic>(builder: (_) => const RecentQueues());
      case '/all_queues':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const AllQueueScreen());
      case '/test_spotify':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const TestSpotifyScreen());
      case '/select_platform':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const SelectPlatformToLink());
      case '/test_spotify_sdk':
        return MaterialPageRoute<dynamic>(builder: (_) => const TestSpot());
      case '/profile-settings':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const ProfileSettigs());
      case '/queue-details':
        return MaterialPageRoute<dynamic>(builder: (_) {
          QueueModel article = args as QueueModel;
          return QueueDetails(article);
        });
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
