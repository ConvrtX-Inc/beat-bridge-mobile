import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/music_platform_model.dart';
import 'package:beatbridge/models/spotify/playlists.dart';
import 'package:beatbridge/screens/main_navigations/make_queues/screens/make_queue_screen.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/recent_queue.dart';
import 'package:beatbridge/utils/constant.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:logger/logger.dart';

import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:http/http.dart' as http;

import '../../../../utils/logout_helper.dart';

const FlutterSecureStorage storage = FlutterSecureStorage();

/// Screen for link landing page
class SelectPlatformToLink extends StatefulWidget {
  /// Constructor
  SelectPlatformToLink({Key? key, this.name = 'David'}) : super(key: key);

  /// Name of the logged in user
  final String name;
  bool _isAPICallInProgress = false;

  @override
  State<SelectPlatformToLink> createState() => _SelectPlatformToLinkState();
}

class _SelectPlatformToLinkState extends State<SelectPlatformToLink> {
  final List<MusicPlatformModel> musicPlatforms =
      StaticDataService.getMusicPlatformModel();

  int selectedPlatform = -1;
  final Logger _logger = Logger(
    //filter: CustomLogFilter(), // custom logfilter can be used to have logs in release mode
    printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: true,
    ),
  );
  var value;
  var check = 0;
  bool _isAPICallInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 80.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 11.w),
                    child: Text(
                      AppTextConstants.success.toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 4,
                          fontSize: 12.sp),
                    ),
                  ),
                  SizedBox(height: 35.h),
                  Container(
                    margin: EdgeInsets.only(left: 5.w, right: 45.w),
                    width: 500,
                    height: 34.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/llinkerMusic.png"),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 11.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 15.h),

                        //Image.asset(Constants.volume),
                        Text(
                          AppTextConstants.selectMusicProfile,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18.sp,
                              color: Colors.white,
                              height: 1.5,
                              letterSpacing: 1),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 11.w),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 40.h,
                                ),
                                Column(
                                  children: musicPlatforms.map((p) {
                                    return _musicPlatformItems(
                                        context, p.index);
                                  }).toList(),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            ButtonRoundedGradient(
              buttonText: AppTextConstants.submit.toUpperCase(),
              isLoading: _isAPICallInProgress,
              buttonCallback: () async {
                setState(() {
                  _isAPICallInProgress = true;
                });
                await getSpotifyToken();
                //log('connectToSpotifyRemote');
                //if (selectedPlatform == 0) {
                //log('connectToSpotifyRemote');
                //await connectToSpotifyRemote();
                // }
                // await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RecentQueues(),));
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 26.h),
              child: TextButton(
                child: Text(
                  AppTextConstants.skipForNow,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
                onPressed: () {
                  setState(() {});
                  Navigator.of(context).pushNamed('/recent_queues');
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  //Request a token using the Client Credentials flow...
  Future<void> getSpotifyToken() async {
    // var credentials = SpotifyApiCredentials(
    //     'c26466a1b28745a6ab684c2ba28f6b52', 'eabffc89312a4a9f93ef46412f1a4e04');
    var credentials = SpotifyApiCredentials(
        // '13aa2f4fc14c4c70aeeac291a0580769',
        '2e522304863a47b49febbb598d524472',
        '540aa17a76224bdebc8e25cf3c24951b');
    // SpotifyApiCredentials(
    //     '7f9bf13747164bbd999f79a1c91eb4b2', 'b4b49577b89b49af98b8e17f4f761283');
    final grant = SpotifyApi.authorizationCodeGrant(credentials);

// The URI to redirect to after the user grants or denies permission. It must
// be in your Spotify application's Redirect URI whitelist. This URI can
// either be a web address pointing to an authorization server or a fabricated
// URI that allows the client device to function as an authorization server.
    final redirectUri = 'https://oauth.pstmn.io/v1/browser-callback';

// See https://developer.spotify.com/documentation/general/guides/scopes/
// for a complete list of these Spotify authorization permissions. If no
// scopes are specified, only public Spotify information will be available.
    final scopes = [
      'app-remote-control',
      'user-read-private',
      'user-read-email',
      'playlist-read-private',
      'user-modify-playback-state',
      'user-read-playback-state',
      'user-read-recently-played',
      'user-read-playback-position',
      'user-top-read',
    ];

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

                    // Map<String, String> requestHeaders = {
                    //   'Content-Type': 'application/json',
                    //   'Authorization': 'Bearer ${credentials.accessToken}',
                    // };
                    // await http.get('https://api.spotify.com/v1/me/playlists', headers: requestHeaders);

                    // final Future<APIStandardReturnFormat> playlist =
                    //     APIServices().getUserPlayList();
                    //log(playlist);

                    //#region spotify playlist import
                    final http.Response response = await http.get(
                        Uri.parse('https://api.spotify.com/v1/me/playlists'),
                        headers: {
                          HttpHeaders.authorizationHeader:
                              'Bearer ${credentials.accessToken}',
                        });
                    log(response.statusCode.toString());
                    if (response.statusCode == 200) {
                      final playlistJson = json.decode(response.body);
                      SportifyPlaylist playlist =
                          SportifyPlaylist.fromJson(playlistJson);
                      //log(playlist.href.toString());
                      //log(jsonEncode(playlist));

                      String playlistData = jsonEncode([playlist]);
                      await storage.write(
                          key: 'spotifyAuthToken',
                          value: credentials.accessToken.toString());
                      final String? userID = await storage.read(key: 'userID');
                      final String? userToken =
                          await storage.read(key: 'userAuthToken');

                      log(userID.toString());
                      log(userToken.toString());
                      //Call Queue API
                      var _body = <String, dynamic>{
                        'user_id': userID,
                        'platform': 'spotify',
                        'image': 'byte64image',
                        'token': '${credentials.accessToken}',
                        'queueData': [playlist],
                      };
                      var bytes = json.encode(_body);
                      log(bytes.toString());

                      final APIStandardReturnFormat result = await APIServices()
                          .userQueueAdd(userToken.toString(), bytes);
                      if (result.statusCode == 201) {
                        log(result.statusCode.toString());
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecentQueues(),
                            ));
                        //  Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (BuildContext context) =>
                        //             RecentQueues()),
                        //     (Route<dynamic> route) => false);
                        // await Navigator.of(context)
                        //     .popAndPushNamed('/recent_queues');
                      }
                    }

                    //#endregion
                  },
                ),
            fullscreenDialog: true));
  }

  // Future<String> createLead(String clientName, String clientEmail,
  //     String clientPhone, String eventId) async {
  //   // Create storage
  //   //final storage = new FlutterSecureStorage();

  //   // Get API url from env
  //   String url = (DotEnv().env['BASE_URL'] + "/leads/create");
  //   String authToken = await storage.read(key: 'api-token');

  //   // Create some request headers
  //   Map<String, String> requestHeaders = {
  //     'Content-type': 'application/json',
  //     'Accept': 'application/json',
  //     'X-Token': authToken
  //   };

  //   final response = await http.post(url,
  //       // enconde some JSON data on the request body
  //       body: json.encode({
  //         'event_id': eventId,
  //         'name': clientName,
  //         'phone': clientPhone,
  //         'email': clientEmail
  //       }),
  //       headers: requestHeaders);

  //   if (response.statusCode == 200) {
  //     final leadsJson = json.decode(response.body);
  //     //Lead lead = Lead.fromJson(leadsJson);
  //     return "success";
  //   } else {
  //     // If that response was not OK, throw an error.
  //     // throw Exception('Failed to load post');
  //     return null;
  //   }
  // }

  Future<void> connectToSpotifyRemote() async {
    Navigator.of(context).pushNamed('/test_spotify_sdk');
    // try {
    //   log('7f9bf13747164bbd999f79a1c91eb4b2');
    //   final bool result = await SpotifySdk.connectToSpotifyRemote(
    //       clientId: '7f9bf13747164bbd999f79a1c91eb4b2',
    //       redirectUrl: 'https://spotifydata.com/callback');
    //   setStatus(result
    //       ? 'connect to spotify successful'
    //       : 'connect to spotify failed');
    // } on PlatformException catch (e) {
    //   setStatus(e.code, message: e.message);
    // } on MissingPluginException {
    //   setStatus('not implemented');
    // }
  }

  Future<String> getAuthenticationToken() async {
    try {
      final String authenticationToken =
          await SpotifySdk.getAuthenticationToken(
              clientId: dotenv.env['CLIENT_ID'].toString(),
              redirectUrl: dotenv.env['REDIRECT_URL'].toString(),
              scope: 'app-remote-control, '
                  'user-modify-playback-state, '
                  'playlist-read-private, '
                  'playlist-modify-public,user-read-currently-playing');
      setStatus('Got a token: $authenticationToken');
      return authenticationToken;
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      return Future<String>.error('$e.code: $e.message');
    } on MissingPluginException {
      setStatus('not implemented');
      return Future<String>.error('not implemented');
    }
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }

  Widget _musicPlatformItems(BuildContext context, int index) {
    return Column(children: <Widget>[
      GestureDetector(
        onTap: () {
          setState(() {
            selectedPlatform = index;
          });
        },
        child: Padding(
          padding: EdgeInsets.only(
            top: 20.h,
            bottom: 20.h,
          ),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 5.w, right: 20.w),
                width: 34.w,
                height: 34.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(musicPlatforms[index].logoImagePath),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),

              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.only(left: 25.w),
                  child: Row(
                    children: [
                      Text(
                        musicPlatforms[index].name,
                        style: TextStyle(
                            color: AppColorConstants.roseWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              check = index;
                            });

                            print(value);
                          },
                          icon: Icon(
                            Icons.check,
                            color: index != check
                                ? AppColorConstants.mirage
                                : Colors.white,
                          ))
                    ],
                  ),
                ),
              ),

              // Expanded(
              //   child: Column(
              //     children: <Widget>[
              //       if (musicPlatforms[index].name ==
              //           AppTextConstants.addYourOwn)
              //         Transform.scale(
              //           scale: 1.5,
              //           child: Icon(
              //             Icons.create_new_folder_outlined,
              //             color: AppColorConstants.roseWhite,
              //           ),
              //         )
              //       else
              //         selectedPlatform == index
              //             ? Icon(
              //                 Icons.check,
              //                 color: AppColorConstants.roseWhite,
              //               )
              //             : Container(),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
      if (index < musicPlatforms.length - 1)
        Divider(
          color: AppColorConstants.paleSky,
        )
    ]);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('name', widget.name));
  }
}

class WebViewWid extends StatelessWidget {
  WebViewWid(
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
      appBar: AppBar(
          backgroundColor: Colors.grey,
          leading: InkWell(
            child: Icon(
              Icons.arrow_back_ios,
              size: 30,
            ),
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
