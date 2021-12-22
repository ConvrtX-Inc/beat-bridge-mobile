// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:beatbridge/widgets/webview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SpotifyApiService {
  SpotifyApiService(this.context);
  BuildContext context;

  static SpotifyApiCredentials credentials = SpotifyApiCredentials(
      'cb43014c85e945c3b1a4ac2676283ba4', '167cc0d0c2a94c96926ee0107a85e6e5');
  SpotifyApi spotify = SpotifyApi(credentials);
  authorizeCodeFlow() async {
    final grant = SpotifyApi.authorizationCodeGrant(credentials);

    final redirectUri = 'https://example.com/auth';

    final List<String> scopes = [
      'user-read-recently-played',
    ];

    final authUri =
        grant.getAuthorizationUrl(Uri.parse(redirectUri), scopes: scopes);

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    await Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
            builder: (_) => WebViewWidget(initialUrl: authUri.toString()),
            fullscreenDialog: true));

    // if (await canLaunch(authUri.toString())) {
    //   launch(authUri.toString());
    // }
  }

  // void saveSpotifyCredential() async {
  //   SpotifyApi spotify = SpotifyApi(credentials);

  //   final dynamic listTest = await spotify.me.recentlyPlayed();

  //   print(listTest);
  // }
}
