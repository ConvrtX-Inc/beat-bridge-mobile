// ignore_for_file: public_member_api_docs, always_specify_types, avoid_catches_without_on_clauses

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' as Foundation;
import 'package:beatbridge/constants/api_path.dart';
import 'package:beatbridge/widgets/webview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:oauth2/src/authorization_code_grant.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as Http;
import 'package:http/src/response.dart';
import 'package:get/get_connect/http/src/request/request.dart';

const FlutterSecureStorage storage = FlutterSecureStorage();
const int timeoutInSeconds = 30;

class SpotifyApiService {
  SpotifyApiService(this.context);
  BuildContext context;

  Response handleResponse(Http.Response response, String uri) {
    dynamic _body;
    try {
      _body = jsonDecode(response.body);
    } catch (e) {}
    Response _response = Response(
      _body ?? response.body,
      response.statusCode,
    );
    // Response _response = Response(
    //   body: _body ?? response.body,
    //   bodyString: response.body.toString(),
    //   request: Request(
    //       headers: response.request.headers,
    //       method: response.request.method,
    //       url: response.request.url),
    //   headers: response.headers,
    //   statusCode: response.statusCode,
    //   statusText: response.reasonPhrase,
    // );
    if (_response.statusCode != 200 &&
        _response.body != null &&
        _response.body is! String) {
      if (_response.body.toString().startsWith('{errors: [{code:')) {
        // ErrorResponse _errorResponse = ErrorResponse.fromJson(_response.body);
        _response = Response(
          _response.body,
          _response.statusCode,
          // statusText: _errorResponse.errors[0].message
        );
      } else if (_response.body.toString().startsWith('{message')) {
        _response = Response(
          _response.body,
          _response.statusCode,
        );
      }
    } else if (_response.statusCode != 200 && _response.body == null) {
      // _response = Response(statusCode: 0, statusText: noInternetMessage);
    }
    if (Foundation.kDebugMode) {
      print(
          '====> API Response: [${_response.statusCode}] $uri\n${_response.body}');
    }
    return _response;
  }

  Future<Response> getData(String uri,
      {required Map<String, dynamic> query,
      required Map<String, String> headers}) async {
    try {
      final Http.Response _response = await Http.get(
        Uri.parse(AppAPIPath.spotifyApiBaseUrl + uri),
      ).timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      print('------------${e.toString()}');
      return Response('', 200);
    }
  }

  static SpotifyApiCredentials credentials = SpotifyApiCredentials(
      '2e522304863a47b49febbb598d524472', '540aa17a76224bdebc8e25cf3c24951b');
  SpotifyApi spotify = SpotifyApi(credentials);

  Future<void> authorizeCodeFlow() async {
    final AuthorizationCodeGrant grant =
        SpotifyApi.authorizationCodeGrant(credentials);
    String redirectUri = Platform.isIOS
        ? "hellospotify1"
        // "spotify-ios-quick-start://spotify-login-callback"
        : 'https://spotifydata.com/callback';
    final List<String> scopes = [
      'app-remote-control',
      'user-modify-playback-state',
      'playlist-read-private',
      'playlist-modify-public',
      'user-read-currently-playing',
      'playlist-modify-private',
      'user-read-recently-played',
      'user-read-private',
      'user-read-email',
      'user-top-read',
    ];

    final Uri authUri =
        grant.getAuthorizationUrl(Uri.parse(redirectUri), scopes: scopes);

    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }

    await Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
            builder: (_) => WebViewWidget(
                  initialUrl: authUri.toString(),
                  redirectUri: redirectUri,
                  onCountChanged: (String) {},
                ),
            fullscreenDialog: true));
  }

  static Future<String> getAuthenticationToken() async {
    try {
      final String authenticationToken = await SpotifySdk.getAccessToken(
          clientId: '13aa2f4fc14c4c70aeeac291a0580769',
          // '7f9bf13747164bbd999f79a1c91eb4b2',
          // dotenv.env['CLIENT_ID'].toString(),
          redirectUrl: 'https://spotifydata.com/callback',
          // dotenv.env['REDIRECT_URL'].toString(),
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public, '
              'user-read-currently-playing, '
              'playlist-modify-private, '
              'user-read-recently-played, '
              'user-read-private, '
              'user-read-email, '
              'user-top-read');

      await storage.write(key: 'spotifyAuthToken', value: authenticationToken);
      return authenticationToken;
    } on PlatformException catch (e) {
      return Future.error('$e.code: $e.message');
    } on MissingPluginException {
      return Future.error('not implemented');
    }
  }

  // Future appRemote() async{
  //   final String? token = await storage.read(key: 'spotifyAuthToken');
  //   try{

  //   }on PlatformException catch(e){
  //     return [];
  //   }
  // }

  static Future<Iterable<PlayHistory>> getRecentPlayed() async {
    // Read value
    final String? token = await storage.read(key: 'spotifyAuthToken');
    try {
      final Uri path = Uri.parse('${AppAPIPath.spotifyApiBaseUrl}?limit=50');

      final SpotifyApi spotify = SpotifyApi.withAccessToken(token!);
      final CursorPages<PlayHistory> recentlyPlayed =
          spotify.me.recentlyPlayed();

      return await recentlyPlayed.all();
    } on PlatformException catch (e) {
      return Future.error('$e.code: $e.message');
    } on MissingPluginException {
      return Future.error('no recently songs available');
    }
  }
  // Future<void> userPlaylist() async {
  //   final String? token = await storage.read(key: 'spotifyAuthToken');
  //   try{
  //     Response response = await
  //   } on PlatformException catch (e){}
  // }

  static Future<Iterable<Track>> getTopTracks() async {
    // Read value
    final String? token = await storage.read(key: 'spotifyAuthToken');

    if (token == null) return [];

    try {
      final SpotifyApi spotify = SpotifyApi.withAccessToken(token!);
      return await spotify.me.topTracks();
    } on PlatformException {
      return [];
    } on MissingPluginException {
      return [];
    }
  }

  static Future<Artist> getArtistDetails(String artistID) async {
    // const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'spotifyAuthToken');
    final Artist art = Artist();
    try {
      final SpotifyApi spotify = SpotifyApi.withAccessToken(token!);
      print(spotify.artists.get(artistID));
      return await spotify.artists.get(artistID);
    } on PlatformException catch (e) {
      return art;
    } on MissingPluginException {
      return art;
    }
  }

  static Future<Paging<Track>> getPlayListTracks(String playlistId) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'spotifyAuthToken');
    final Paging<Track> pl = Paging<Track>();
    try {
      final SpotifyApi spotify = SpotifyApi.withAccessToken(token!);
      final Playlist playlist = await spotify.playlists.get(playlistId);
      return playlist.tracks!;
      // return await spotify.playlists.get(playlistId);
    } on PlatformException catch (e) {
      return pl;
    } on MissingPluginException {
      return pl;
    }
  }

  static Future<Iterable<PlaylistSimple>> getFeaturedPlayList() async {
    final Iterable<PlaylistSimple> playList = [];
    // Read value
    final String? token = await storage.read(key: 'spotifyAuthToken');
    try {
      final SpotifyApi spotify = SpotifyApi.withAccessToken(token!);
      return await spotify.playlists.featured.all();
      // return await spotify.me.topTracks();
    } on PlatformException catch (e) {
      return playList;
    } on MissingPluginException {
      return playList;
    }
  }

  static Future<Iterable<PlaylistSimple>> getUserPlayList() async {
    final Iterable<PlaylistSimple> userPlaylist = [];
    // Read value
    final String? token = await storage.read(key: 'spotifyAuthToken');
    try {
      final SpotifyApi spotify = SpotifyApi.withAccessToken(token!);
      return await spotify.playlists
          .getUsersPlaylists('31xpmfeoflk5fjj37y3lk5ifze5i')
          .all();
    } on PlatformException catch (e) {
      return userPlaylist;
    } on MissingPluginException {
      return userPlaylist;
    }
  }
}
