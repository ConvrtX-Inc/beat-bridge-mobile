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
  static String apiBaseUrl = 'dev-beatbridge-convrtx.herokuapp.com';

  /// Returns Spotify API base url
  static String spotifyApiBaseUrl = 'api.spotify.com/v1';

  /// Returns login url
  static String loginUrl = 'api/v1/auth/username/login';

  /// Returns user queues url
  static String userQueues = 'api/v1/user-queues';

  /// Returns queue members url
  static String queueMembers = 'api/v1/queue-members/list/';

  /// Returns get user by id url
  static String userDetails = 'api/v1/users/';

  /// Returns get user spotify play list
  static String userPlayList = 'me/playlists';

  /// Returns register url
  static String registerUrl = 'api/v1/auth/username/register';

  /// Returns payment api url
  static String paymentApiUrl = 'api/v1/charge';

  /// Returns user subscription api url
  static String userSubscriptionApiUrl = 'api/v1/user-subscription';
}
