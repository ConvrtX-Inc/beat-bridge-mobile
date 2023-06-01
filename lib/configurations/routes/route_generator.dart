// ignore_for_file: avoid_classes_with_only_static_members, prefer_final_locals, cast_nullable_to_non_nullable
import 'dart:io';

import 'package:beatbridge/models/spotify/play_list.dart';
import 'package:beatbridge/models/spotify/play_list.dart';
import 'package:beatbridge/models/spotify/track.dart';
import 'package:beatbridge/models/users/new_queue_model.dart';
import 'package:beatbridge/models/users/queue_model.dart';
import 'package:beatbridge/models/subscription_model.dart';
import 'package:beatbridge/screens/FAQs/faq_screen.dart';
import 'package:beatbridge/screens/auths/forgot_password/screens/new_password.dart';
import 'package:beatbridge/screens/auths/forgot_password/screens/verification_code.dart';
import 'package:beatbridge/screens/auths/forgot_password/screens/verify_email.dart';
import 'package:beatbridge/screens/auths/forgot_password/screens/verify_number.dart';
import 'package:beatbridge/screens/auths/logins/screens/login.dart';
import 'package:beatbridge/screens/auths/logins/screens/login_input.dart';
import 'package:beatbridge/screens/auths/logins/screens/login_input_email.dart';
import 'package:beatbridge/screens/auths/logins/screens/login_method.dart';
import 'package:beatbridge/screens/auths/registers/screens/register.dart';
import 'package:beatbridge/screens/cards/card_input.dart';
import 'package:beatbridge/screens/contacts/contact_us.dart';
import 'package:beatbridge/screens/main_navigations/friends/screens/friend.dart';
import 'package:beatbridge/screens/main_navigations/friends/screens/near_you.dart';
import 'package:beatbridge/screens/main_navigations/friends/screens/friend_request.dart';
import 'package:beatbridge/screens/main_navigations/links/screens/link_landing_page.dart';
import 'package:beatbridge/screens/main_navigations/links/screens/select_platform_to_link.dart';
import 'package:beatbridge/screens/main_navigations/links/screens/test_spot.dart';
import 'package:beatbridge/screens/main_navigations/make_queues/screens/make_queue_screen.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/add_music.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/all_queue.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/queue_details.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/queue_playing_screen.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/recent_queue.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/test_spotify.dart';
import 'package:beatbridge/screens/play_list/play_list.dart';
import 'package:beatbridge/screens/play_list/play_list_details.dart';
import 'package:beatbridge/screens/play_music/play_music.dart';
import 'package:beatbridge/screens/settings/profile_details.dart';
import 'package:beatbridge/screens/settings/profile_settings.dart';
import 'package:beatbridge/screens/settings/system_setting.dart';
import 'package:beatbridge/screens/sources/bluetooth_source.dart';
import 'package:beatbridge/screens/sources/iosbluetoothsource.dart';
import 'package:beatbridge/screens/sources/music_source.dart';
import 'package:beatbridge/screens/splashes/screens/splash_screen.dart';
import 'package:beatbridge/screens/subscriptions/subscribe.dart';
import 'package:beatbridge/screens/supports/create_ticket.dart';
import 'package:beatbridge/screens/supports/support.dart';
import 'package:beatbridge/screens/supports/support_thread.dart';
import 'package:flutter/material.dart';
import '../../screens/auths/forgot_password/number_verfication_code.dart';
import '../../screens/spotify/spotify_test.dart';

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
            builder: (_) => VerificationCodeScreen());
      case '/number_verification_code':
        return MaterialPageRoute<dynamic>(
            builder: (_) => NumberVerificationCodeScreen());
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
        return MaterialPageRoute<dynamic>(builder: (_) {
          // BuildContext context = args as BuildContext;
          return AllQueueScreen();
        });
      case '/test_spotify':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const SpotifyTestScreen());
      case '/select_platform':
        return MaterialPageRoute<dynamic>(
            builder: (_) => SelectPlatformToLink());
      case '/friends':
        return MaterialPageRoute<dynamic>(builder: (_) => const FriendScreen());
      case '/near_you':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const NearYouScreen());
      case '/friend_request':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const FriendRequestScreen());
      case '/test_spotify_sdk':
        return MaterialPageRoute<dynamic>(builder: (_) => const TestSpot());
      case '/profile-settings':
        return MaterialPageRoute<dynamic>(builder: (_) => ProfileSettigs());
      case '/queue-details':
        return MaterialPageRoute<dynamic>(builder: (_) {
          NewQueueModel queue = args as NewQueueModel;
          return QueueDetails(queue);
        });
      case '/play-list':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const PlayListScreen());
      case '/play-list-details':
      // return MaterialPageRoute<dynamic>(builder: (_) {
      //   // PlayList playList = args as PlayList;
      //   // return PlayListDetailsScreen();
      // });
      case '/support':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const SupportScreen());
      case '/support-thread':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const SupportThreadScreen());
      case '/create-ticket':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const CreateTicketScreen());
      case '/subscribe':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const SubscribeScreen());
      case '/card_input':
        return MaterialPageRoute<dynamic>(
            builder: (_) => CardInputScreen(
                selectedSubscription: args! as SubscriptionModel));
      case '/music_source':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const MusicSourceScreen());
      case '/bluetooth_source':
        return MaterialPageRoute<dynamic>(
            builder: (_) => Platform.isIOS
                ? IOSBluetoothSourceScreen()
                : BluetoothSourceScreen());
      case '/contact_us':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const ContactUsScreen());
      case '/system_settings':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const SystemSettingScreen());
      case '/login_method':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const LoginMethodScreen());
      case '/login_input_email':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const LoginInputEmailScreen());
      case '/verify_number':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const VerifyNumberScreen());
      case 'add_music':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const addMusicScreen());
      case 'profile_details':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const ProfileDetails());
      case 'faq':
        return MaterialPageRoute<dynamic>(builder: (_) => const FAQ_Screen());

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
