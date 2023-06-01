/*
  When using REST API service in dart then we can store all the API endpoints in a separate file api_path.dart
 */
/// Class for app API urls
class AppAPIPath {
  /// Constructor
  const AppAPIPath();


  /// Returns staging mode (change to false if deploying to live)
  static bool isStaging = false;

  /// Returns API mode
  static String apiBaseMode = 'https://';
  //static String apiBaseMode = isStaging ? 'http://' : 'https://';

  /// Returns API base url production
  // static String apiBaseUrl = 'beat-bridge-api.herokuapp.com';
  static String apiBaseUrl = 'beat.softwarealliancetest.tk';

  /// Returns API base url staging
  // static String apiBaseUrl = 'beatbridge-api-staging.herokuapp.com';

  /// Returns Spotify API base url
  static String spotifyApiBaseUrl = 'https://api.spotify.com/v1';
  //songs played
  static String songPLayed = "/api/track/song-played/";

  /// Returns login url
  // static String loginUrl = 'api/v1/auth/username/login';

  //remove friend
  static String removeFriend = "/api/v1/user-connections/remove-friend/";
  static String leaveQueue = "/api/v1/queue-members/remove/";

  /// Returns login url email
  static String loginUrlEmail = 'api/v1/auth/email/login';

  /// Returns login url email
  static String getUserSongs = '/api/track/top-played/';

  /// Returns login url phone
  static String loginUrlPhone = 'api/v1/auth/mobile/login';

  /// Returns user queues url
  static String addUserQueues = '/api/v1/user-queues/add';

  /// Returns user queues url
  static String userQueues = '/api/v1/user-queues';

  /// add friend
  static String addFriend = '/api/v1/user-connections/add-friend';

  /// Returns queue members url
  static String addQueueMembers = 'api/v1/queue-members';

  /// join queue members
  static String joinQueue = 'api/v1/queue-members';

  /// Returns queue members url
  static String queueMembers = 'api/v1/queue-members/list/';

  /// Returns queue list song
  static String queueSongs = 'api/track/queue/';

  /// Returns get user by id url
  static String userDetails = 'api/v1/users/';

  /// Returns all users
  static String usersAll = 'api/v1/users';

  /// Returns get user spotify play list
  static String userPlayList = 'me/playlists';

  /// Returns register url
  static String registerUrl = 'api/v1/auth/username/register';
  static String checkFriend = 'api/v1/user-connections/friend/check';

  /// Returns payment api url
  static String paymentApiUrl = 'api/v1/charge';

  /// Returns user subscription api url
  static String userSubscriptionApiUrl = 'api/v1/user-subscription';

  /// Returns nearest user api url
  static String nearestUserApiUrl = 'api/v1/users/nearest-users';

  //spotify Api

  /// Return user playlist
  static String spotifyPlaylistUrl = '/me/playlists';
  static String deleteTracks = '/api/track';
  static String addSupport = '/api/v1/support';
  static String getFaqs = '/api/v1/guidlines/faq';
  static String getPrivacyPolicy = '/api/v1/guidlines/privacyPolicy';
  static String getTermsCondition = '/api/v1/guidlines/termsCondition';
  static String getSupport = '/api/v1/support/';


}
