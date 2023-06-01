import 'package:beatbridge/utils/approutes.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

///
class TestSpot extends StatefulWidget {
  /// Constructor
  const TestSpot({Key? key}) : super(key: key);

  @override
  _TestSpotState createState() => _TestSpotState();
}

class _TestSpotState extends State<TestSpot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton:
            IconButton(onPressed: getToken, icon: Icon(Icons.add)),
        body: Center(
          child: Text('test'),
        ));
  }

  //Request a token using the Client Credentials flow...
  Future<void> getToken() async {
    var credentials = SpotifyApiCredentials(
        '2e522304863a47b49febbb598d524472', '540aa17a76224bdebc8e25cf3c24951b');
    final grant = SpotifyApi.authorizationCodeGrant(credentials);

// The URI to redirect to after the user grants or denies permission. It must
// be in your Spotify application's Redirect URI whitelist. This URI can
// either be a web address pointing to an authorization server or a fabricated
// URI that allows the client device to function as an authorization server.
    final redirectUri = 'https://oauth.pstmn.io/v1/browser-callback';

// See https://developer.spotify.com/documentation/general/guides/scopes/
// for a complete list of these Spotify authorization permissions. If no
// scopes are specified, only public Spotify information will be available.
    final scopes = ['user-read-email', 'user-library-read'];

    final authUri = grant.getAuthorizationUrl(
      Uri.parse(redirectUri),
      scopes: scopes, // scopes are optional
    );

    await Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
            builder: (_) => WebViewWid(
                  initialUrl: authUri.toString(),
                  redirectUri: redirectUri,
                  onCountChanged: (String val) async {
                    print(val);
                    final spotify = SpotifyApi.fromAuthCodeGrant(grant, val);
                    // print(spotify.me.recentlyPlayed());

                    credentials = await spotify.getCredentials();
                    print('\nCredentials:');
                    print('Client Id: ${credentials.clientId}');
                    print('Access Token: ${credentials.accessToken}');
                    print('Credentials Expired: ${credentials.isExpired}');
                  },
                ),
            fullscreenDialog: true));
  }
}

class WebViewWid extends StatelessWidget {
  const WebViewWid(
      {Key? key,
      required this.initialUrl,
      required this.redirectUri,
      required this.onCountChanged})
      : super(key: key);

  final String initialUrl;
  final String redirectUri;
  final Function(String) onCountChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: InkWell(
        onTap: () {
          AppRoutes.pop(context);
        },
      )),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: initialUrl,
        navigationDelegate: (navReq) {
          if (navReq.url.startsWith(redirectUri)) {
            onCountChanged(navReq.url);
            Navigator.pop(context);
            return NavigationDecision.prevent;
          }

          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
