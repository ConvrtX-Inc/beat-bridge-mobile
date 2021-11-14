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
}
