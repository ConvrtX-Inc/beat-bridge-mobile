import 'dart:convert';
import 'dart:io';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/app_list.dart';
import 'package:beatbridge/models/music_platform_model.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/utils/logout_helper.dart';
import 'package:beatbridge/utils/preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotify/spotify.dart';
import 'package:http/http.dart' as http;
import '../../models/apis/api_standard_return.dart';
import '../../models/spotify/playlists.dart';
import '../../utils/services/rest_api_service.dart';
import '../../widgets/buttons/app_button_rounded_gradient.dart';
import '../main_navigations/links/screens/select_platform_to_link.dart';
import '../main_navigations/queues/screens/recent_queue.dart';

///Music Source Screen
class MusicSourceScreen extends StatefulWidget {
  ///Constructor
  const MusicSourceScreen({Key? key}) : super(key: key);

  @override
  _MusicSourceScreenState createState() => _MusicSourceScreenState();
}

class _MusicSourceScreenState extends State<MusicSourceScreen> {
  List<MusicPlatformModel> musicPlatforms = <MusicPlatformModel>[];
  bool isChecked = false;
  var checkBoxCheck = '';
  bool _isAPICallInProgress = false;
  FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    setMusicSource();
    _asyncMethod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorConstants.mirage,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 40.h,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppColorConstants.roseWhite,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 41.h),
                      SizedBox(height: 26.h),
                      Text(
                        AppTextConstants.editMusicSource,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColorConstants.roseWhite,
                            fontSize: 30.sp),
                      ),
                      SizedBox(height: 36.h),
                    ]),
              ),
              Expanded(child: buildMusicSourceList()),
              isChecked != true
                  ? Container()
                  : ButtonRoundedGradient(
                      buttonText: AppTextConstants.submit.toUpperCase(),
                      isLoading: _isAPICallInProgress,
                      buttonCallback: () async {
                        setState(() {
                          UserSingleton.instance.myaccessToken = null;
                        });
                        await getSpotifyToken();
                        setState(() {
                          _isAPICallInProgress = true;
                        });
                      },
                    ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 26.h),
                child: TextButton(
                  child: Text(
                    '',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _isAPICallInProgress = false;
                    });
                    Navigator.of(context).pushNamed('/recent_queues');
                  },
                ),
              )
            ]));
  }

  Widget buildMusicSourceList() => ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(
            color: AppColorConstants.paleSky,
          ),
      itemCount: musicPlatforms.length,
      itemBuilder: (BuildContext ctx, int index) {
        return Padding(
            padding: EdgeInsets.all(8.w), child: buildMusicSource(index));
      });

  Widget buildMusicSource(int index) {
    return ListTile(
      leading: Container(
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
      title: Text(
        musicPlatforms[index].name,
        style: TextStyle(
            color: AppColorConstants.roseWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600),
      ),
      trailing: Transform.scale(
          scale: 1.5,
          child: Checkbox(
              value: musicPlatforms[index].isSelected,
              onChanged: (bool? value) {
                setState(() {
                  musicPlatforms[index].isSelected = value!;
                  if (musicPlatforms[0].isSelected == true) {
                    isChecked = true;
                    musicPlatforms[0].isSelected == false;
                    musicPlatforms[2].isSelected == true;
                  } else {
                    isChecked = false;
                    setState(() {
                      musicPlatforms[0].isSelected == true;
                    });
                  }
                });
                updateMusicSource();
              },
              checkColor: AppColorConstants.roseWhite,
              activeColor: AppColorConstants.artyClickPurple,
              side: MaterialStateBorderSide.resolveWith(
                (Set<MaterialState> states) => BorderSide(
                  width: 2,
                  color: AppColorConstants.paleSky,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)))),
    );
  }

  Future<void> setMusicSource() async {
    final List<MusicPlatformModel> musicSourceList =
        AppListConstants().musicSourceList;
    final String value = MusicPlatformModel.encode(musicSourceList);

    final String musicsString =
        SharedPreferencesRepository.getString('musicSource');
    debugPrint('music string, $musicsString');
    if (musicsString == '') {
      SharedPreferencesRepository.putString('musicSource', value);
      setState(() {
        musicPlatforms = musicSourceList;
      });
    } else {
      setState(() {
        musicPlatforms = MusicPlatformModel.decode(musicsString);
      });
    }
  }

  Future<void> updateMusicSource() async {
    final String value = MusicPlatformModel.encode(musicPlatforms);
    SharedPreferencesRepository.putString('musicSource', value);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        IterableProperty<MusicPlatformModel>('musicPlatforms', musicPlatforms));
  }

  Future<void> getSpotifyToken() async {
    // var credentials = SpotifyApiCredentials(
    //     'c26466a1b28745a6ab684c2ba28f6b52', 'eabffc89312a4a9f93ef46412f1a4e04');

    var credentials = SpotifyApiCredentials(
        '2e522304863a47b49febbb598d524472', '540aa17a76224bdebc8e25cf3c24951b');
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
                    print("authentication url: $val");
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

                      //Call Queue API
                      var _body = <String, dynamic>{
                        'user_id': userID,
                        'platform': 'spotify',
                        'image': 'byte64image',
                        'token': '${credentials.accessToken}',
                        'queueData': [playlist],
                      };
                      var bytes = json.encode(_body);

                      final APIStandardReturnFormat result = await APIServices()
                          .userQueueAdd(userToken.toString(), bytes);
                      if (result.statusCode == 201) {
                        await Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    RecentQueues()),
                            (Route<dynamic> route) => false);
                        // await Navigator.of(context)
                        //     .popAndPushNamed('/recent_queues');
                      }
                    }

                    //#endregion
                  },
                ),
            fullscreenDialog: true));
  }

  _asyncMethod() async {
    final String? userAuthToken = await storage.read(key: 'userAuthToken');
    final String? spotifyAuthToken =
        await storage.read(key: 'spotifyAuthToken');
    setState(() {
      token == spotifyAuthToken;
    });
  }

  String? token;
}
