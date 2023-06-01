// ignore_for_file: curly_braces_in_flow_control_structures, always_specify_types, unnecessary_lambdas

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/helpers/basehelper.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/people_model.dart';
import 'package:beatbridge/models/recently_played_model.dart';
import 'package:beatbridge/models/songsmodel.dart';
import 'package:beatbridge/models/spotify/playlist_body.dart';
import 'package:beatbridge/models/users/login_reg_model.dart';
import 'package:beatbridge/models/users/new_queue_model.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/notifier/songstimernotifier.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/music/MusicPlayer.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/music/see_most_played.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/see_all_recent_queues.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/see_top_played.dart';
import 'package:beatbridge/utils/logout_helper.dart';
import 'package:beatbridge/utils/preferences/shared_preferences.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/spotify_api_service.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:beatbridge/widgets/justaudioidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:music_kit/music_kit.dart';
import 'package:playify/playify.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:spotify/spotify.dart' as spot;
import 'package:spotify_sdk/models/crossfade_state.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart' as sindu_player_state;
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:volume_controller/volume_controller.dart';
// import 'package:spotify/spotify.dart';

///Recent Queues
class RecentQueues extends StatefulWidget {
  ///Constructor
  const RecentQueues({Key? key}) : super(key: key);

  @override
  _RecentQueuesState createState() => _RecentQueuesState();
}

class _RecentQueuesState extends State<RecentQueues> {
  final String url =
      'https://accounts.spotify.com/authorize?client_id=13aa2f4fc14c4c70aeeac291a0580769&response_type=code&redirect_uri=spotify-ios-quick-start://spotify-login-callback&scope=user-read-private%20user-read-email';

  callUrl() async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  final String clientId = '2e522304863a47b49febbb598d524472';
  // '2e522304863a47b49febbb598d524472';
  final String clientSecret = '540aa17a76224bdebc8e25cf3c24951b';

  //  '540aa17a76224bdebc8e25cf3c24951b';
  var spotifyAccessToken;
  bool _loading = false;
  bool _connected = false;
  final Logger _logger = Logger(
    //filter: CustomLogFilter(), // custom logfilter can be used to have logs in release mode
    printer: PrettyPrinter(
      methodCount: 2,
      // number of method calls to be displayed
      errorMethodCount: 8,
      // number of method calls if stacktrace is provided
      lineLength: 120,
      // width of the output
      colors: true,
      // Colorful log messages
      printEmojis: true,
      // Print an emoji for each log message
      printTime: true,
    ),
  );
  CrossfadeState? crossfadeState;
  late ImageUri? currentTrackImageUri;

  // final List<RecentQueueModel> recentQueueList =
  //     StaticDataService.getRecentQueues();
  final List<RecentlyPlayedModel> topPlayedItems =
      StaticDataService.getRecentlyPlayedMockData();

  final List<PeopleModel> friendList =
      StaticDataService.getPeopleListMockData();
  int selectedQueueIndex = 1;
  ScrollController scrollController = ScrollController();
  List<String> errorMessages = <String>[];
  ValueNotifier<List<NewQueueModel>> queueData =
      ValueNotifier<List<NewQueueModel>>([]);
  ValueNotifier<List<SongsData>> songsData = ValueNotifier<List<SongsData>>([]);

  var songURL;
  var songName;
  var songArtist;
  // final AssetsAudioPlayer audioplayer = AssetsAudioPlayer();
  AudioPlayer _audioPlayer = AudioPlayer();
  bool playpause = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getpermission();
    // initPlatformState();
    // callUrl();
    getProfile();
    // getAccessToken();
    getQueue();

    // musickitInitialize();

    debugPrint('friends ${friendList.length}');
  }

  getLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    var long = position.longitude.toString();
    var lat = position.latitude.toString();

    setState(() {
      //refresh UI
      long = position.longitude.toString();
      lat = position.latitude.toString();
      UserSingleton.instance.lat = lat;
      UserSingleton.instance.long = long;
    });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      setState(() {
        //refresh UI on update
        UserSingleton.instance.lat = lat;
        UserSingleton.instance.long = long;
      });
    });
  }

  getpermission() async {
    var permission = await Permission.location.request();
    if (permission.isDenied) {
      getpermission();
    } else {}
    getLocation();
  }
  // final _musicKitPlugin = MusicKit();
  // Future<void> initPlatformState() async {
  //   final status = await _musicKitPlugin.authorizationStatus;

  //   final developerToken = await _musicKitPlugin.requestDeveloperToken();
  //   print("developer tokensssss: $developerToken");
  //   final userToken = await _musicKitPlugin.requestUserToken(developerToken);
  //   print("user token:ssssssss $userToken");
  //   final countryCode = await _musicKitPlugin.currentCountryCode;
  //   print("country code:ssss $countryCode");
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;

  //   setState(() {
  //     // _status = status;
  //     // _developerToken = developerToken;
  //     // _userToken = userToken;
  //     // _countryCode = countryCode;
  //   });
  // }

  // musickitInitialize() async {
  //   var musicKit = MusicKit();
  //   // musicKit.
  //   var musicToken;

  //   await musicKit.requestDeveloperToken().then((value) {
  //     setState(() {
  //       musicToken = musicToken;
  //     });
  //     print("the value of develoepr token is: $value");
  //   });
  //   print("the developer token is: ${musicToken}");
  //   musicKit.initialize(musicToken);
  // }

  getProfile() async {
    const _platform = const MethodChannel('samples.flutter.dev/test');
    if (Platform.isIOS) {
    } else {
      try {
        var res = await _platform.invokeMethod('myMethod') == 1;
      } on PlatformException catch (e) {
        print('Error = $e');
      }
    }

    await Future.delayed(
        Duration(
          seconds: 2,
        ), () {
      _asyncMethod();
    });
    await storage.read(key: 'profileimage').then((value) {
      setState(() {
        UserSingleton.instance.profileImage = value;
      });
    });
    // print("my profile image is: ${UserSingleton.instance.profileImage}");
  }

  Playify myplayer = Playify();
  getQueue() async {
    // var artists = await myplayer.getAllSongs(sort: true).then((value) {
    //   print("my all songs playlist: $value");
    //   for (int i = 0; i < value.length; i++) {
    //     print("each song: ${value[i].name}");
    //   }
    // });

    BaseHelper().getUserSongs(context: context, isUser: true).then((value) {
      songsData.value = value;
    });
    APIServices().recentQueue(userIdd: "0").then((value) {
      setState(() {
        queueData!.value = value;
      });
    });
  }
  // controlls widget

  // // slider timings

  String transformString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ' '}${seconds % 60}';
    return '$minuteString:$secondString';
  }

  // var access;
  _asyncMethod() async {
    var accessTokensss =
        SharedPreferencesRepository.getString('spotifyAccessToken');
    //  storage.read(key: 'spotifyAccessToken');
    print("my accessaaaa toke: $accessTokensss");
    if (Platform.isIOS) {
      if (UserSingleton.instance.myaccessToken == null) {
        await Future.delayed(
            Duration(
              seconds: 2,
            ), () async {
          print("nt queues");
          await getAccessToken().then((value) async {
            print("token value: ${value}");
            setState(() {
              spotifyAccessToken = value.toString();
              UserSingleton.instance.myaccessToken = spotifyAccessToken;
              storage.write(key: 'spotifyAccessToken', value: value);
            });
            await connectToSpotifyRemote(value).then((_) async {
              await getPlayerState().then((spotifyAccessToken) async {
                await getCrossfadeState();
              }).catchError((onError) {
                print("getCrossfadeState error: $onError");
              });
            }).catchError((onError) {
              print("connectToSpotifyRemote error: $onError");
            });
          });
        });
      } else {
        setState(() {
          _loading = false;
          _connected = true;
        });
        print("sending access token: $accessTokensss");
        try {
          await connectToSpotifyRemote(UserSingleton.instance.myaccessToken)
              .then((value) async {
            await getPlayerState().then((accessTokensss) async {
              await getCrossfadeState();
            }).catchError((onError) {
              print("getCrossfadeState error: $onError");
              setState(() {
                UserSingleton.instance.myaccessToken = null;
              });
            });
          }).catchError((onError) {
            print("connectToSpotifyRemote error: $onError");
          });
        } catch (e) {
          print("spotify catch  error: $e");
        }
      }
    } else {
      await Future.delayed(
          Duration(
            seconds: 2,
          ), () async {
        print("nt queues");
        await getAccessToken().then((value) async {
          print("token value: ${value}");
          setState(() {
            spotifyAccessToken = value.toString();
            UserSingleton.instance.myaccessToken = spotifyAccessToken;
            storage.write(key: 'spotifyAccessToken', value: value);
          });
          await connectToSpotifyRemote(value).then((_) async {
            await getPlayerState().then((spotifyAccessToken) async {
              await getCrossfadeState();
            });
          });
        });
      });
    }

    // final String? userAuthToken = await storage.read(key: 'userAuthToken');
    // final String? spotifyAuthToken =
    //     await storage.read(key: 'spotifyAuthToken');
    // final String? tempRegResponse = await storage.read(key: 'tempRegResponse');
    // setState(() async {
    //   Global.userid = await storage.read(key: 'userID');
    // });
    // print("my user id here is: ${Global.userid}");
    // final UserValidResponse user =
    //     UserValidResponse.fromJson(json.decode(tempRegResponse.toString()));

    // buildRecentQueuesList();
  }

  closeapp() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await closeapp(),
      child: Scaffold(
        backgroundColor: AppColorConstants.mirage,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: buildRecentQueuesUI(),
        ),
      ),
    );
  }

  ///working widget
  Widget _buildPlayerStateWidget() {
    return customPlayer();
    //  StreamBuilder<sindu_player_state.PlayerState>(
    //   stream: SpotifySdk.subscribePlayerState(),
    //   builder: (BuildContext context,
    //       AsyncSnapshot<sindu_player_state.PlayerState> snapshot) {
    //     print("response from spotify subscribe: ${snapshot.data}");
    //     var track = snapshot.data?.track;
    //     var playerState = snapshot.data;

    //     print('track : $track');
    //     log('$track');

    //     print('player state : $playerState');
    //     //  print('seekbar state : ${track.d}');

    //     if (playerState == null || track == null) {
    //       // _logger.i("Null player start " + snapshot.toString());
    //       return Center(
    //         child: Container(),
    //       );
    //     }
    //     //  SpotifySdk.s
    //     print('spotifyImage : ${track.artist}');
    //     var duration = double.parse(snapshot.data!.track!.duration.toString());
    //     print("track duration: ${snapshot.data!.track!.duration}");
    //     int mins = Duration(
    //             seconds: int.parse(snapshot.data!.track!.duration.toString()))
    //         .inMinutes;
    //     SongsTimeNotifier().lastValue.value = Duration(
    //             seconds: int.parse(snapshot.data!.track!.duration.toString()))
    //         .inMinutes;

    //     int mins1 = Duration(
    //                 seconds:
    //                     int.parse(snapshot.data!.track!.duration.toString()))
    //             .inMinutes %
    //         100;
    //     return Center(
    //       child: Container(
    //         width: MediaQuery.of(context).size.width,
    //         height: MediaQuery.of(context).size.height * .3,
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: <Widget>[
    //             Row(
    //               children: [
    //                 spotifyImageWidget(track.imageUri),
    //                 SizedBox(
    //                   width: 15,
    //                 ),
    //                 Expanded(
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text(
    //                         '${track.name}',
    //                         style: const TextStyle(
    //                             overflow: TextOverflow.ellipsis,
    //                             color: Colors.white,
    //                             fontFamily: 'Glory',
    //                             fontSize: 18),
    //                       ),
    //                       Text(
    //                         track.album.name,
    //                         style: const TextStyle(
    //                             overflow: TextOverflow.ellipsis,
    //                             color: Colors.white,
    //                             fontFamily: 'Glory',
    //                             fontSize: 18),
    //                       ),
    //                       Text(
    //                         '${track.artist.name}',
    //                         style: const TextStyle(
    //                             overflow: TextOverflow.ellipsis,
    //                             color: Colors.white,
    //                             fontFamily: 'Glory',
    //                             fontSize: 18),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             const SizedBox(
    //               height: 15,
    //             ),
    //             Container(
    //               width: MediaQuery.of(context).size.width,
    //               child: Align(
    //                 alignment: Alignment.center,
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     const SizedBox(
    //                       width: 15,
    //                     ),
    //                     IconButton(
    //                       padding: EdgeInsets.zero,
    //                       constraints: BoxConstraints(),
    //                       icon: Image.asset(
    //                         'assets/images/shuffle.png',
    //                         height: 20,
    //                         width: 25,
    //                       ),
    //                       onPressed: () {
    //                         toggleShuffle();
    //                         print('music shuffle');
    //                       },
    //                     ),
    //                     const SizedBox(
    //                       width: 15,
    //                     ),
    //                     IconButton(
    //                         padding: EdgeInsets.zero,
    //                         constraints: BoxConstraints(),
    //                         icon: Image.asset(
    //                           'assets/images/backforward.png',
    //                           height: 20,
    //                           width: 25,
    //                         ),
    //                         onPressed: skipPrevious),
    //                     const SizedBox(
    //                       width: 15,
    //                     ),
    //                     if (playerState.isPaused)
    //                       IconButton(
    //                         padding: EdgeInsets.zero,
    //                         constraints: BoxConstraints(),
    //                         iconSize: 50,
    //                         icon: Image.asset(
    //                           'assets/images/Play1.png',
    //                         ),
    //                         onPressed: () {
    //                           resume();
    //                           setState(() {
    //                             // SongsTimeNotifier().lastValue.value = int.parse(
    //                             //     mins.toString().split("")[0].toString());
    //                             print("minsss: $mins");
    //                             print(
    //                                 "last value: ${SongsTimeNotifier().lastValue.value}");
    //                           });

    //                           print("minsss: $mins");
    //                           print(
    //                               "last value: ${SongsTimeNotifier().lastValue.value}");
    //                           print('music forward');
    //                         },
    //                       )
    //                     else
    //                       IconButton(
    //                         padding: EdgeInsets.zero,
    //                         constraints: BoxConstraints(),
    //                         iconSize: 50,
    //                         icon: Image.asset(
    //                           'assets/images/pause.png',
    //                         ),
    //                         onPressed: () {
    //                           pause();
    //                           setState(() {
    //                             duration = double.parse(
    //                                 snapshot.data!.track!.duration.toString());
    //                           });
    //                           // SongsTimeNotifier().lastValue.value = int.parse(
    //                           //     mins.toString().split("")[0].toString());
    //                           print("minsss: $mins");
    //                           print(
    //                               "last value: ${SongsTimeNotifier().lastValue.value}");
    //                           print('music forward');
    //                         },
    //                       ),
    //                     const SizedBox(
    //                       width: 15,
    //                     ),
    //                     IconButton(
    //                       padding: EdgeInsets.zero,
    //                       constraints: BoxConstraints(),
    //                       icon: Image.asset(
    //                         'assets/images/forward.png',
    //                         height: 20,
    //                         width: 25,
    //                       ),
    //                       onPressed: () {
    //                         skipNext();

    //                         print('music sound forward');
    //                       },
    //                     ),
    //                     const SizedBox(
    //                       width: 15,
    //                     ),
    //                     ValueListenableBuilder<bool>(
    //                         valueListenable: SongsTimeNotifier().isMute,
    //                         builder:
    //                             (BuildContext context, value, Widget? child) {
    //                           return IconButton(
    //                             padding: EdgeInsets.zero,
    //                             constraints: BoxConstraints(),
    //                             icon: SongsTimeNotifier().isMute.value == true
    //                                 ? Icon(
    //                                     Icons.volume_mute_rounded,
    //                                     size: 20,
    //                                     color: Colors.grey,
    //                                   )
    //                                 : Icon(
    //                                     Icons.volume_up,
    //                                     size: 20,
    //                                     color: Colors.grey,
    //                                   ),
    //                             // Image.asset(
    //                             //   'assets/images/sound.png',
    //                             //   height: 20,
    //                             //   width: 25,
    //                             // ),
    //                             onPressed: () {
    //                               setState(() {
    //                                 SongsTimeNotifier().isMute.value =
    //                                     !SongsTimeNotifier().isMute.value;
    //                               });
    //                               print(
    //                                   "mute value: ${SongsTimeNotifier().isMute.value}");
    //                               // skipNext();
    //                               SongsTimeNotifier().setVolumn(
    //                                   SongsTimeNotifier().isMute.value);
    //                               // VolumeController().setVolume(0);

    //                               print('music sound');
    //                             },
    //                           );
    //                         }),
    //                     const SizedBox(
    //                       width: 15,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //             // Container(child: buildRecentlyPlayedItem(context, 0)),
    //             // ProgressBar(
    //             //   progress: Duration(milliseconds: count),
    //             //   buffered: Duration(milliseconds: 2000),
    //             //   total: Duration(milliseconds: lastValue),
    //             //   onSeek: (duration) {
    //             //     count = duration.inSeconds;
    //             //     // SpotifySdk.see
    //             //     print("duration: $duration");
    //             //     print('User selected a new time: $duration');
    //             //   },
    //             // ),
    //             customPlayer(

    //             )
    //             // mySlider(mins)
    //             // , slider(realtimePlayingInfos)
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  Widget mySlider(mins) {
    return ValueListenableBuilder<int>(
        valueListenable: SongsTimeNotifier().counter,
        builder: (BuildContext context, value, Widget? child) {
          print("valueeeeee: $value");
          return Column(
            children: [
              Slider(
                  value: double.parse(
                      SongsTimeNotifier().counter.value.toString()),
                  min: -1,
                  max: 100,
                  // divisions: 20,
                  activeColor: Colors.green,
                  inactiveColor: Colors.grey,
                  label: 'sa',
                  onChanged: (double newValue) {
                    var data = newValue;
                    SongsTimeNotifier().counter.value =
                        int.parse(newValue.toString());
                    // print("counter value incremented: $counter");
                    // duration = newValue;
                    setState(() {
                      // double.parse(
                      //     snapshot.data!.track!.duration.toString());
                      // valueHolder = newValue.round();
                    });
                  },
                  semanticFormatterCallback: (double newValue) {
                    return '${newValue.round()}';
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // SongsTimeNotifier().count.value == 0
                    //     ?
                    "0:${SongsTimeNotifier().counter.value}"
                    // :
                    // "${SongsTimeNotifier().count.value}:${SongsTimeNotifier().counter.value}"
                    ,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${mins.toString().split("")[0]}:${mins.toString().split("")[1]}0",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          );
        });
  }

  Widget spotifyImageWidget(ImageUri image) {
    return FutureBuilder(
        future: SpotifySdk.getImage(
          imageUri: image,
          dimension: ImageDimension.large,
        ),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData) {
            return Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Image.memory(snapshot.data!));
          } else if (snapshot.hasError) {
            setStatus(snapshot.error.toString());
            return SizedBox(
              width: 10,
              height: 10,
              child: const Center(child: Text('')),
            );
          } else {
            return SizedBox(
              width: 10,
              height: 10,
              child: const Center(child: Text('')),
            );
          }
        });
  }

  refreshData() async {
    getProfile();
    // _asyncMethod();
    getQueue();
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Widget buildRecentQueuesUI() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        // enablePullUp: true,
        onRefresh: () {
          setState(() {
            _connected = false;
          });
          // _asyncMethod();
          refreshData();
        },
        header: WaterDropHeader(),
        child: _connected == false
            ? Center(
                child: Text(
                  "Loading...",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 41.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: InkWell(
                                onTap: () {
                                  debugPrint('should open profile...');

                                  Navigator.of(context)
                                      .pushNamed('/profile-settings');
                                },
                                child: SvgPicture.asset(
                                    '${AssetsPathConstants.assetsSVGPath}/menu.svg')),
                          ),
                          SizedBox(height: 36.h),

                          _buildPlayerStateWidget(),
                          // SizedBox(height: 3.h),

                          ///song description container
                          //
                          // audioplayer.builderRealtimePlayingInfos(
                          //     builder: (context, realtimePlayingInfos) {
                          //   // ignore: unnecessary_null_comparison
                          //   if (realtimePlayingInfos != null) {
                          //     return Column(
                          //       //Designing Texts and image
                          //       children: [
                          //         // slider code is here
                          //
                          //         Stack(
                          //           children: [
                          //             Column(
                          //               mainAxisAlignment: MainAxisAlignment.end,
                          //               children: [
                          //                 slider(realtimePlayingInfos),
                          //                 const SizedBox(
                          //                   height: 10,
                          //                 ),
                          //                 timeStamps(realtimePlayingInfos),
                          //                 const SizedBox(
                          //                   height: 10,
                          //                 ),
                          //                 playBar(realtimePlayingInfos),
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //       ],
                          //     );
                          //   } else {
                          //     return Column();
                          //   }
                          // }),

                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 11.w),
                                child: Text(
                                  AppTextConstants.recentQueues,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColorConstants.roseWhite,
                                      fontSize: 22),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    // FIRST SPRINT DISABLED ITEM

                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SeeAllQueueData(
                                                  queueData: queueData,
                                                )));

                                    // FIRST SPRINT DISABLED ITEM
                                  },
                                  child: Text(AppTextConstants.seeAll,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColorConstants.roseWhite,
                                          fontSize: 13)))
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          buildRecentQueuesList(),

                          ///top played text and see all
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 11.w),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(AppTextConstants.topPlayed,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColorConstants.roseWhite
                                                .withOpacity(0.7),
                                            fontSize: 22)),
                                    TextButton(
                                        onPressed: () {
                                          // FIRST SPRINT DISABLED ITEM

                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SeeAllTopPlayed(
                                                        songsData,
                                                      )));

                                          // FIRST SPRINT DISABLED ITEM
                                        },
                                        child: Text(AppTextConstants.seeAll,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppColorConstants.roseWhite,
                                                fontSize: 13)))
                                  ])),
                        ]),
                  ),
                  ValueListenableBuilder<List<SongsData>>(
                      valueListenable: songsData,
                      builder: (BuildContext context, value, Widget? child) {
                        // ignore: unnecessary_null_comparison
                        // print("hedsadsallo: $value");
                        if (value.isEmpty) {
                          return SliverToBoxAdapter(
                            child: SizedBox(
                              // height: MediaQuery.of(context).size.height * .06,
                              width: MediaQuery.of(context).size.width * .9,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return SliverList(
                              delegate: SliverChildBuilderDelegate(
                            (context, int index) {
                              return newSongsWidget(value[index], index);
                            },
                            childCount: value.length >= 3 ? 3 : value.length,
                          ));
                        }
                      }),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(height: 28.h),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 11.w,
                          ),
                          child: ButtonRoundedGradient(
                            buttonText: AppTextConstants.startNewQueue,
                            buttonCallback: () {
                              SpotifySdk.pause();
                              Navigator.of(context)
                                  .pushNamed('/make_your_queue_screen');
                              PlaylistBody();
                            },
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 11.w,
                          ),
                          child: ButtonRoundedGradient(
                            buttonTextColor: Colors.white,
                            buttonColor: AppColorConstants.roseWhite,
                            buttonText: AppTextConstants.joinNearbyQueue,
                            buttonCallback: () {
                              // FIRST SPRINT DISABLED ITEM
                              Navigator.of(context).pushNamed('/all_queues');
                            },
                          ),
                        ),
                        SizedBox(height: 20.h),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildRecentQueuesList() {
    return ValueListenableBuilder<List<NewQueueModel>>(
        valueListenable: queueData,
        builder: (BuildContext context, value, Widget? child) {
          // ignore: unnecessary_null_comparison
          // print("hedsadsallo: $value");
          if (value == null || value.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * .06,
              width: MediaQuery.of(context).size.width * .9,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          } else {
            return SizedBox(
              height: Platform.isIOS
                  ? MediaQuery.of(context).size.height * .14
                  : MediaQuery.of(context).size.height * .12,
              child: ListView.builder(
                itemCount: value.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  if (value.first.queueData == null) {
                    return buildRecentQueueItem(
                      value[index],
                      index,
                    );
                  } else {
                    return buildRecentQueueItem(
                      value[index],
                      index,
                    );
                  }
                  // return buildRecentQueueItem(userQueues[index], index);
                },
              ),
            );
          }
        });
  }

  Widget buildRecentQueueItem(NewQueueModel queue, int index) {
    // print("queue platform: ${queue?.image}");

    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              UserSingleton.instance.queueIndex = index;
            });
            print("my queue id: ${queue.id}");
            // UserSingleton.instance.user
            APIServices().getQueueMember('${queue.id}');
            Navigator.of(context).pushNamed('/queue-details', arguments: queue);
          },
          child: SizedBox(
            height: 60,
            width: 60,
            child: Container(
              decoration: BoxDecoration(
                color: AppColorConstants.mirage,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Container(
                padding: const EdgeInsets.all(6),
                child: ClipOval(
                    child: queue.platform == null
                        ? queue.image.toString().isNotEmpty ||
                                queue?.image != null
                            ? Image.network(
                                "https://beat.softwarealliancetest.tk${queue?.image}",
                                fit: BoxFit.fill,
                                height: 70.h)
                            : Image.network(
                                queue?.image ??
                                    'https://www.w3schools.com/howto/img_avatar.png',
                                height: 70.h)
                        : Image.network(
                            queue.queueData!.images![0].url.toString(),
                            height: 70.h)
                    // child: Image.asset(recentQueueList[index].thumbnailUrl,
                    // height: 70.h),
                    ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
            width: 60.w,
            child: Text(
              queue.name.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 10.sp),
            ))
      ],
    );
  }

  Widget buildTopPlayedItemList(Iterable<spot.Track> rPlayed) {
    final Iterable<spot.Track> firstFour = rPlayed.take(4);
    return Column(
        // FIRST SPRINT DISABLED ITEM BELOW

        children: []);
  }

  Widget newSongsWidget(SongsData songsResult, int index) {
    return ListTile(
      onTap: () async {
        // await SpotifySdk.pause();
        // await SpotifySdk.seekTo(positionedMilliseconds: 0);
        // customPlayer();
        // customPlayer().myPlayer();
        await play(songsResult.uri.toString());

        // SpotifySdk.subscribePlayerState();
        // await SpotifySdk.seekTo(positionedMilliseconds: 0);
        BaseHelper()
            .songsPLayed(context: context, uriId: songsResult.uri.toString())
            .then((value) {
          print("song played with uri");
        });
        songName = songsResult.name.toString();
        songURL = songsResult.uri.toString();

        // buffering();
      },
      contentPadding: EdgeInsets.zero,
      key: Key(songsResult.id.toString()),
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
              image: NetworkImage(songsResult
                  .tracksData!.tracks!.album!.images!.first.url
                  .toString()),
              fit: BoxFit.cover),
        ),
        child: Align(
          child: Image.asset(
              '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}'),
        ),
      ),
      title: Text(
        "${songsResult.tracksData!.tracks!.album!.artist!.first.name}",
        key: Key(index.toString() + songsResult.id.toString()),
        style: TextStyle(
            color: AppColorConstants.roseWhite,
            fontWeight: FontWeight.w600,
            fontSize: 17),
      ),
      subtitle: Text(
        "${songsResult.tracksData!.tracks!.album!.name}",
        key: Key("item" + index.toString()),
        style: TextStyle(color: AppColorConstants.paleSky, fontSize: 13),
      ),
    );
  }

  Widget buildFriendList() {
    return Container(
      height: 120.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            for (int i = 0; i < friendList.length - 1; i++) buildFriendItem(i),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(children: <Widget>[]))
          ]),
    );
  }

  Widget buildFriendItem(int index) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(friendList[index].profileImageUrl),
                    fit: BoxFit.fitHeight,
                  )),
            ),
            SizedBox(
              height: 6.h,
            ),
            Text(friendList[index].name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600))
          ],
        ));
  }

  Future<void> disconnect() async {
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.disconnect();
      setStatus(result ? 'disconnect successful' : 'disconnect failed');
      setState(() {
        _loading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus('not implemented');
    }
  }

  Future<void> connectToSpotifyRemote(value) async {
    try {
      setState(() {
        // _loading = true;
      });
      print("Access token in remote: $value");
      var result = await SpotifySdk.connectToSpotifyRemote(
          clientId: clientId,
          accessToken: value,
          redirectUrl: Platform.isIOS
              ? 'spotify-ios-quick-start://spotify-login-callback'
              // "spotify-ios-quick-start://spotify-login-callback"
              : 'https://spotifydata.com/callback'
          // 'https://spotifydata.com/callback'
          );

      setState(() {
        _loading = false;
      });
      print("spotify access token connectToSpotifyRemote is: ${result}");
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
      await getAccessToken().then((value) async {
        print("token value: ${value}");
        setState(() {
          spotifyAccessToken = value.toString();
          UserSingleton.instance.myaccessToken = spotifyAccessToken;
          storage.write(key: 'spotifyAccessToken', value: value);
        });
        await connectToSpotifyRemote(value).then((_) async {
          await getPlayerState().then((spotifyAccessToken) async {
            await getCrossfadeState();
          }).catchError((onError) {
            print("getCrossfadeState error: $onError");
          });
        }).catchError((onError) {
          print("connectToSpotifyRemote error: $onError");
        });
      });
      print("spotify access token connectToSpotifyRemote error is: ${e}");
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      print("spotify access token connectToSpotifyRemote error is:");
      setStatus('not implemented');
    } catch (e) {
      print("spotify access token connectToSpotifyRemote error is: ${e}");
    }
  }

  Future<String?> getAccessToken() async {
    try {
      var spotifyAccessToken = await SpotifySdk.getAccessToken(
          clientId: clientId,
          spotifyUri: 'spotify-ios-quick-start://spotify-login-callback',
          redirectUrl: Platform.isIOS
              ? 'spotify-ios-quick-start://spotify-login-callback'
              //"spotify-ios-quick-start://spotify-login-callback"
              : 'https://spotifydata.com/callback',
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public,user-read-currently-playing');

      print("spotify access token is: $spotifyAccessToken");
      print('this is : {$spotifyAccessToken}');
      SharedPreferencesRepository.putString(
          'spotifyAccessToken', spotifyAccessToken);
      print("token saved to sharepreferences");
      await storage.write(key: 'spotifyACcessToken', value: spotifyAccessToken);
      //log('$authenticationToken');
      SpotifySdk.seekTo(positionedMilliseconds: 0);
      SpotifySdk.pause();
      setState(() {
        _connected = true;
      });
      return spotifyAccessToken;
    } on PlatformException catch (e) {
      print("patform exception of access token: ${e.message}");
      setStatus(e.code, message: e.message);

      return Future.error('$e.code: $e.message');
    } on MissingPluginException {
      print("missing platform exception");
      print("spotify access token missing plugin is:");
      setStatus('not implemented');
      return Future.error('not implemented');
    }
  }

// Future<String> getAccessToken() async {
//   print("In ACESS TOKEN METHODDDDDD");
//   final String clientId = "2e522304863a47b49febbb598d524472";
//   final String clientSecret = "540aa17a76224bdebc8e25cf3c24951b";
//   final String basicAuth =
//       'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret'));
//   final response = await post(
//     Uri.parse('https://accounts.spotify.com/api/token'),
//     headers: <String, String>{
//       'Content-Type': 'application/x-www-form-urlencoded',
//       'Authorization': basicAuth,
//     },
//     body: <String, String>{
//       'grant_type': 'client_credentials',
//     },
//   );
//   print("Respinse code: ${response.statusCode}");
//   if (response.statusCode == 200) {
//     final parsedJson = json.decode(response.body);
//       print("RespOnseeee : ${parsedJson}");
//     return parsedJson['access_token'];
//   } else {
//     throw Exception('Failed to get access token');
//   }
// }

  Future getPlayerState() async {
    try {
      return await SpotifySdk.getPlayerState();
      print("spotify access token player state is:");
    } on PlatformException catch (e) {
      print("spotify access token player state exception ${e.message}:");
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future getCrossfadeState() async {
    try {
      var crossfadeStateValue = await SpotifySdk.getCrossFadeState();
      setState(() {
        crossfadeState = crossfadeStateValue;
      });
      print("spotify access token cross fade  ${crossfadeState}:");
    } on PlatformException catch (e) {
      print("spotify access token cross fade  exception: ${e.message}:");
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> setShuffle(bool shuffle) async {
    try {
      await SpotifySdk.setShuffle(
        shuffle: shuffle,
      );
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> toggleShuffle() async {
    try {
      await SpotifySdk.toggleShuffle();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> play(String uri) async {
    try {
      // await _audioPlayer.play();
      print("spotify uri: $uri");
      await SpotifySdk.play(spotifyUri: uri);
      SpotifySdk.seekTo(positionedMilliseconds: 0);
      // SongsTimeNotifier().startTime();
      // await SpotifySdk.play(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> pause() async {
    try {
      await SpotifySdk.pause();
      SongsTimeNotifier().stopTimer();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> resume() async {
    try {
      await SpotifySdk.resume();

      SongsTimeNotifier().stopTimer();
      SongsTimeNotifier().startTime();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> skipNext() async {
    try {
      await SpotifySdk.skipNext();
      SongsTimeNotifier().stopTimer();
      SongsTimeNotifier().startTime();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> skipPrevious() async {
    print('function call inside skip previous');
    try {
      await SpotifySdk.skipPrevious();
      SongsTimeNotifier().stopTimer();
      SongsTimeNotifier().startTime();
    } catch (e) {
      final snackBar = SnackBar(
        content: Text("Cant Skip To Previous Song"),
        backgroundColor: (Colors.red),
        action: SnackBarAction(
          label: 'dismiss',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> seekTo() async {
    try {
      await SpotifySdk.seekTo(positionedMilliseconds: 20000);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> seekToRelative() async {
    try {
      await SpotifySdk.seekToRelativePosition(relativeMilliseconds: 20000);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> addToLibrary() async {
    try {
      await SpotifySdk.addToLibrary(
          spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> checkIfAppIsActive(BuildContext context) async {
    try {
      var isActive = await SpotifySdk.isSpotifyAppActive;
      final snackBar = SnackBar(
          content: Text(isActive
              ? 'Spotify app connection is active (currently playing)'
              : 'Spotify app connection is not active (currently not playing)'));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
    // _logger.i('$code$text');
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      // ..add(IterableProperty<RecentQueueModel>(
      //     'recentQueueList', recentQueueList))
      ..add(IterableProperty<RecentlyPlayedModel>(
          'topPlayedItems', topPlayedItems))
      ..add(IntProperty('selectedQueueIndex', selectedQueueIndex))
      ..add(IterableProperty<PeopleModel>('friendList', friendList));
  }

  bool MuteVolume = false;
  var _state;
}
