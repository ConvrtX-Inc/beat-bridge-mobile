/*
  This is where all our application constants will be present and this is different for each application.
 */

import 'dart:ui';

/// Class for app custom colors
class AppColorConstants {
  /// Constructor
  const AppColorConstants();

  /// Returns blue berry color
  static const Color _darkNavy = Color(0xFF020738);

  /// get blue berry color
  static Color get darkNavy => _darkNavy;

  /// Returns dodger blue color
  static const Color _dodgerBlue = Color(0xFF358AFD);

  /// get blue berry color
  static Color get dodgerBlue => _dodgerBlue;

  /// Returns midnight purpose color
  static const Color _midnightPurple = Color(0xFF1D0235);

  /// get blue berry color
  static Color get midnightPurple => _midnightPurple;

  /// Returns mirage color
  static const Color _mirage = Color(0xFF181720);

  /// get blue berry color
  static Color get mirage => _mirage;

  /// Returns cinder color
  static const Color _cinder = Color(0xFF15151B);

  /// get blue berry color
  static Color get cinder => _cinder;

  /// Returns rose white color
  static const Color _roseWhite = Color(0xFFFFF6F6);

  /// get blue berry color
  static Color get roseWhite => _roseWhite;

  /// Returns pale sky color
  static const Color _paleSky = Color(0xFF767680);

  /// get pale sky color
  static Color get paleSky => _paleSky;

  /// Returns arty click purple color
  static const Color _artyClickPurple = Color(0xFF8201FF);

  /// get arty click purple color
  static Color get artyClickPurple => _artyClickPurple;

  /// Returns rubber ducky yellow color
  static const Color _rubberDuckyYellow = Color(0xFFFFD601);

  /// get arty rubber ducky yellow color
  static Color get rubberDuckyYellow => _rubberDuckyYellow;

  /// Returns lemon color
  static const Color _lemon= Color(0xFFFFED8D);

  /// get arty lemon color
  static Color get lemon => _lemon;



}

/// Class for app text constants
class AppTextConstants {
  /// Constructor
  AppTextConstants();

  /// Returns one device and million songs sharing text
  static String getStarted = 'Get Started';

  /// Returns hassle free text
  static String hassleFree = 'hassle free';

  /// Returns one device and million songs sharing text
  static String oneDeviceMillionSongs =
      'One device & millions \nof songs sharing';

  /// Returns your text
  static String your = 'Your';

  /// Returns next text
  static String next = 'Next';

  /// Returns create account text
  static String createAccount = 'Create Account';

  /// Returns already a member text
  static String alreadyAMember = 'Already a member?';

  /// Returns Verify your Email
  static String verifyEmail = 'Verify Email';

  /// Returns Email
  static String email = 'Email';

  /// Returns Please verify your email address here.
  static String verifyEmailDescription =
      'Please verify your email address here.';

  /// Returns Please enter email here.
  static String enterEmail = 'Enter your email here...';

  /// Returns Enter new Password.
  static String enterNewPasswordTitle = 'Enter new password';

  /// Returns New Password.
  static String newPassword = 'New Password';

  /// Returns login text
  static String login = 'Login';

  /// Returns log in text
  static String logIn = 'Log in';

  /// Returns asterisk
  static String asterisk = '*';

  /// Returns username text
  static String username = 'Username';

  /// Returns password text
  static String password = 'Password';

  /// Returns confirm password text
  static String confirmPassword = 'Confirm Password';

  /// Returns paste song link here text
  static String pasteSongLinkHere = 'Paste Song Link here';

  /// Returns email or phone number text
  static String emailOrPhoneNumber = 'Email or Phone Number';

  /// Returns submit text
  static String submit = 'Submit';

  /// Returns please wait text
  static String pleaseWait = 'Please wait...';

  /// Returns password and confirm password does not match text
  static String passwordDoesNotMatch =
      'Password and Confirm password does not match';

  /// Returns Verification Code text
  static String verificationCodeTitle = 'Verification Code';

  /// Returns Check your email for verification code that we sent to you text
  static String verificationCodeDescription =
      'Check your email for verification code that we sent to you';

  /// Returns Resend Code? text
  static String resendCode = 'Resend Code?';

  /// Returns cannot be empty text
  static String cannotBeEmpty = 'cannot be empty';

  /// Returns must be at least 6 characters text
  static String mustBeAtLeast6Chars = 'must be at least 6 characters';

  /// Returns invalid email format text
  static String invalidEmailFormat = 'Invalid email format';

  /// Returns already exists text
  static String alreadyExists = 'already exists!';

  /// Returns bullet text
  static String bullet = '\u2022 ';

  /// Returns bigger bullet text
  static String biggerBullet = '●';

  /// Returns hey text
  static String hey = 'Hey';

  /// Returns Gilroy bold text
  static String gilroyBold = 'Gilroy-bold';

  /// Returns account has been created text
  static String accountHasBeenCreated =
      'Your Account Has Been \nCreated, Now Lets Link Your Music';

  /// Returns link my music text
  static String linkMyMusic = 'Link my music';

  /// Returns skip for now text
  static String skipForNow = 'Skip for now do this later';

  /// Returns make your queue text
  static String makeYourQueue = 'Make Your Queue';

  /// Returns enter your queue name text
  static String enterYourQueueName = 'Enter your queue name';

  ///Returns eg. beatbridge favorite text
  static String egBeatBridgeFavorite = 'Eg: Beatbridge Favorite';

  ///Returns continue text
  static String continueTxt = 'Continue';

  ///Returns let's add music text
  static String letsAddMusic = "Let's add music";

  ///Returns spotify text
  static String spotify = 'Spotify';

  ///Returns sound cloud text
  static String soundCloud = 'Sound Cloud';

  ///Returns itunes text
  static String itunes = 'ITunes';

  /// Returns add your own text
  static String addYourOwn = 'Add Your Own';

  /// Returns recently played text
  static String recentlyPlayed = 'Recently Played';

  /// Returns top played text
  static String topPlayed = 'Top Played';

  /// Returns see all text
  static String seeAll = 'SEE ALL';

  ///Returns add friends text
  static String addFriends = 'Add Friends';

  ///Returns make admin text
  static String makeAdmin = 'Make Admin';

  ///Returns connect with bluetooth text
  static String connectWithBluetooth = 'Connect With Bluetooth';

  ///Returns bluetooth text
  static String bluetooth = 'Bluetooth';

  ///Returns discoverable as text
  static String discoverableAs = 'Discoverable As';

  ///Returns my devices text
  static String myDevices = 'My Devices';

  /// Returns connected text
  static String connected = 'Connected';

  /// Returns not connected text
  static String notConnected = 'Not Connected';

  ///Returns all done text
  static String allDone = 'All Done';

  ///Returns recent queues string
 static String recentQueues =  'Recent Queues';

  ///Returns all queues string
  static String allQueues =  'All Queues';

 ///Returns start new queue text
 static String startNewQueue = 'Start New Queue';

  ///Returns join nearby queue text
  static String joinNearbyQueue = 'Join Nearby Queue';

  ///Returns follow your friends text
  static String followYourFriends = 'Follow Your Friends';

}
