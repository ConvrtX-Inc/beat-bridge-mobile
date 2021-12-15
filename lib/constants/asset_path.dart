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

  /// returns assets png path
  static const String assetsJPGPath = 'assets/images/jpg';

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

  /// returns login colored text file name
  static const String loginColoredText = 'login_colored_text.png';

  /// returns link landing page header image file name
  static const String linkLandingPageHeaderImage =
      'link_landing_page_image.png';

  /// returns link landing page success image file name
  static const String linkLandingPageSuccessImage =
      'link_landing_page_success_image.png';

  /// returns link Your Music success image file name
  static const String linkYourMusic = 'link_your_music.png';

  /// returns spotify logo image file name
  static const String spotifyLogoImage = 'spotify_logo.png';

  /// returns sound cloud logo image file name
  static const String soundCloudLogoImage = 'sound_cloud_logo.png';

  /// returns itunes  logo image file name
  static const String itunesLogoImage = 'itunes_logo.png';

  /// returns own music  logo image file name
  static const String ownMusicLogoImage = 'own_music_logo.png';

  /// returns play button   image file name
  static const String playButtonImage = 'play_btn.png';

  /// returns bluetooth active image file name
  static const String bluetoothActiveImage = 'bluetooth_active.png';

  /// returns bluetooth inactive image file name
  static const String bluetoothInActiveImage = 'bluetooth_inactive.png';
}
