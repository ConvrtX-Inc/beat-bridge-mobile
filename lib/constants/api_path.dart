/*
  When using REST API service in dart then we can store all the API endpoints in a separate file api_path.dart
 */

/// Class for app API urls
class AppAPIPath {
  /// Constructor
  const AppAPIPath();

  /// Returns staging mode (change to false if deploying to live)
  static bool isStaging = true;

  /// Returns API mode
  static String apiBaseMode = isStaging ? 'http://' : 'https://';

  /// Returns API base url
  static String apiBaseUrl = '192.168.68.116:3000';

  /// Returns login url
  static String loginUrl = 'api/v1/auth/email/login';

  /// Returns register url
  static String registerUrl = 'api/v1/auth/username/register';
}
