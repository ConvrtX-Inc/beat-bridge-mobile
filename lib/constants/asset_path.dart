/*
  Although we have described the assets path in pubspec.yaml but to use that asset in an application we need to give there relative path in any widgets.
  If we add all the assets relative path in one file then it will be easy for us to get all the paths and update the path if required in the future.
 */

/// Class for app assets path
class AssetsPathConstants {
  /// Constructor
  const AssetsPathConstants();

  /// returns assets png path
  static const String assetsPNGPath = 'assets/images/png';

  /// returns assets svg path
  static const String assetsSVGPath = 'assets/images/svg';
}

/// Class for app assets path
class AssetsNameConstants {
  /// Constructor
  const AssetsNameConstants();

  /// returns splash screen background file name
  static const String splashScreenBackground = 'splash_screen_background.png';

  /// returns app logo colored slogan file name
  static const String appLogoColoredSlogan = 'app_logo_colored_slogan.png';

  /// returns app logo white file name
  static const String appLogoWhite = 'app_logo_white.png';

  /// returns walk through colored text 1 file name
  static const String walkThroughColoredText1 =
      'walk_through_colored_text_1.png';

  /// returns walk through colored text 2 file name
  static const String walkThroughColoredText2 =
      'walk_through_colored_text_2.png';

  /// returns walk through colored text 3 file name
  static const String walkThroughColoredText3 =
      'walk_through_colored_text_3.png';

  /// returns walk through background 1 file name
  static const String walkThroughBackground1 = 'walk_through_background_1.png';

  /// returns walk through background 2 file name
  static const String walkThroughBackground2 = 'walk_through_background_2.png';

  /// returns walk through background 1 file name
  static const String walkThroughBackground3 = 'walk_through_background_3.png';
}
