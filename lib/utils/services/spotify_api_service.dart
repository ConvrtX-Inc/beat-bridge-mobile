// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:beatbridge/widgets/webview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

final storage = new FlutterSecureStorage();

class SpotifyApiService {
  SpotifyApiService(this.context);
  BuildContext context;

  static SpotifyApiCredentials credentials = SpotifyApiCredentials(
      'cb43014c85e945c3b1a4ac2676283ba4', '167cc0d0c2a94c96926ee0107a85e6e5');
  SpotifyApi spotify = SpotifyApi(credentials);
  authorizeCodeFlow() async {
    final grant = SpotifyApi.authorizationCodeGrant(credentials);
    final redirectUri = 'https://oauth.pstmn.io/v1/browser-callback';
    final List<String> scopes = [
      'user-read-recently-played',
    ];

    final authUri =
        grant.getAuthorizationUrl(Uri.parse(redirectUri), scopes: scopes);

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

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
      final authenticationToken = await SpotifySdk.getAuthenticationToken(
          clientId: dotenv.env['CLIENT_ID'].toString(),
          redirectUrl: dotenv.env['REDIRECT_URL'].toString(),
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

  static Future<Iterable<PlayHistory>> getRecentPlayed() async {
    final Iterable<PlayHistory> rPlayed = [];
    // Read value
    final String? token = await storage.read(key: 'spotifyAuthToken');
    try {
      final SpotifyApi spotify = SpotifyApi.withAccessToken(token!);
      return await spotify.me.recentlyPlayed();
    } on PlatformException catch (e) {
      return rPlayed;
    } on MissingPluginException {
      return rPlayed;
    }
  }

  static Future<Iterable<Track>> getTopTracks() async {
    final Iterable<Track> topTrack = [];
    // Read value
    final String? token = await storage.read(key: 'spotifyAuthToken');
    try {
      final SpotifyApi spotify = SpotifyApi.withAccessToken(token!);
      return await spotify.me.topTracks();
    } on PlatformException catch (e) {
      return topTrack;
    } on MissingPluginException {
      return topTrack;
    }
  }

  static Future<Artist> getArtistDetails(String artistID) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'spotifyAuthToken');
    final Artist art = Artist();
    try {
      final SpotifyApi spotify = SpotifyApi.withAccessToken(token!);
      return await spotify.artists.get(artistID);
    } on PlatformException catch (e) {
      return art;
    } on MissingPluginException {
      return art;
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
}
