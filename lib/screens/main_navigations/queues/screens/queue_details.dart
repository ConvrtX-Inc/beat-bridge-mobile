// ignore_for_file: diagnostic_describe_all_properties, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, sort_constructors_first, public_member_api_docs, prefer_if_elements_to_conditional_expressions

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/helpers/basehelper.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/apis/response_to_user.dart';
import 'package:beatbridge/models/people_model.dart';
import 'package:beatbridge/models/recent_queue_model.dart';
import 'package:beatbridge/models/recently_played_model.dart';
import 'package:beatbridge/models/songsmodel.dart';
import 'package:beatbridge/models/users/new_queue_model.dart';
import 'package:beatbridge/models/users/queue_member_model.dart';
import 'package:beatbridge/models/users/queue_model.dart';
import 'package:beatbridge/models/users/user_queue_songs.dart' as songQueues;
import 'package:beatbridge/models/users/user_track_model.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/music/addmusic.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/music/queuesongs.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/recent_queue.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/see_all_member.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/see_top_played.dart';
import 'package:beatbridge/utils/approutes.dart';
import 'package:beatbridge/utils/preferences/shared_preferences.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/spotify_api_service.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:beatbridge/widgets/justaudioidget.dart';
import 'package:beatbridge/widgets/queueCustomPlayer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spotify/spotify.dart' as spot;
import 'package:spotify_sdk/models/crossfade_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import 'package:beatbridge/screens/main_navigations/queues/screens/music/member_profile.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/music/see_most_played.dart';

import '../../../../models/queuecountNotifier.dart';
import '../../../../models/users/user_model.dart';
import '../../../../utils/helpers/text_helper.dart';
import '../../../../utils/services/global_api_service.dart';

///Queue Details
class QueueDetails extends StatefulWidget {
  ///Constructor
  final NewQueueModel queue;

  QueueDetails(this.queue);

  @override
  _QueueDetailsState createState() => _QueueDetailsState();
}

class _QueueDetailsState extends State<QueueDetails> {
  final List<RecentQueueModel> recentQueueList =
      StaticDataService.getRecentQueues();

  final String clientId = '2e522304863a47b49febbb598d524472';
  // '2e522304863a47b49febbb598d524472';
  final String clientSecret = '540aa17a76224bdebc8e25cf3c24951b';
  // '540aa17a76224bdebc8e25cf3c24951b';
  bool isloading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final List<RecentlyPlayedModel> topPlayedItems =
      StaticDataService.getRecentlyPlayedMockData();

  final List<PeopleModel> friendList =
      StaticDataService.getPeopleListMockData();
  int selectedQueueIndex = 1;

  List<songQueues.GetQueueListSong> queueSongList =
      <songQueues.GetQueueListSong>[];
  bool hasError = false;
  var membersLength = 0;
  ValueNotifier<List<SongsData>> songsData = ValueNotifier<List<SongsData>>([]);
  APIServices queListSong = APIServices();
  String joinQueue = 'Join Queue';
  String? tempQueueID;

  bool _isAPICallInProgress = false;
  List<UserTrackModel> userTrackList = <UserTrackModel>[];
  List<String> userChecked = [];
  bool isLoading = false;
  var userId = "";
  @override
  void initState() {
    // queListSong.getQueueListSong('b4554759-c28b-4241-9f93-a3ff0a8d7c80');
    super.initState();
    queListSong.getQueueListSong(widget.queue.id ?? 'empty');
    membersCount();
    print('print admin status :${widget.queue.id}');
    print(
        'is admin :${widget.queue.isAdmin} is member: ${widget.queue.isMember}');
    _queueMethod();
    _asyncMethod();
  }

  var _connected;
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

  CrossfadeState? crossfadeState;
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

  var access;
  _asyncMethod() async {
    await Future.delayed(
        Duration(
          seconds: 2,
        ), () async {
      print("calling async function");
      var myToken = SharedPreferencesRepository.getString('spotifyAccessToken');
      setState(() {
        access = myToken;
      });
      if (Platform.isIOS) {
        await connectToSpotifyRemote(UserSingleton.instance.myaccessToken)
            .then((myToken) async {
          await getPlayerState().then((value) async {
            await getCrossfadeState();
          });
        });
      } else {
        await getAccessToken().then((value) async {
          print("token value: ${value}");
          setState(() {
            access = value.toString();
          });
          await connectToSpotifyRemote(value).then((myToken) async {
            await getPlayerState().then((value) async {
              await getCrossfadeState();
            });
          });
        });
      }

      membersCount();
    });

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

      print("spotify access token connectToSpotifyRemote is: ${result}");
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  membersCount() {
    APIServices().getQueueMemberCount(widget.queue.id.toString()).then((value) {
      setState(() {
        UserSingleton.instance.membersCount = value;
        print("memebrws count: ${UserSingleton.instance.membersCount}");
      });
    });
    BaseHelper()
        .getUserSongs(context: context, queueId: widget.queue.id, isUser: false)
        .then((value) {
      songsData.value = value;
    });
  }

  _queueMethod() async {
    await storage.read(key: 'userID').then((value) {
      setState(() {
        userId = value!;
      });
    });
    setState(() async {
      print("ques detail user id: $userId");
      print("ques detail  api user id: ${widget.queue.id}");
    });
    String? tempQueueID = await storage.read(key: 'tempQueueID');
    return tempQueueID;
  }

  var membersData;
  @override
  Widget build(BuildContext context) {
    membersData = QueueNotifier().getmembersCount();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColorConstants.mirage,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: buildRecentQueuesUI()),
        //child: SingleChildScrollView(child: Container(color: Colors.red,)),
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: AppColorConstants.mirage,
          title: Center(
              child: Text(
            'Permission Request',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColorConstants.roseWhite,
                fontSize: 22,
                fontFamily: 'Gilgor'),
          )),
          content: Text(
            "do you want to join the ${widget.queue.name}?",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w300,
                color: AppColorConstants.roseWhite,
                fontSize: 14,
                fontFamily: 'Gilgor'),
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        primary: Colors.transparent,
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: AppColorConstants.roseWhite,
                            fontSize: 14,
                            fontFamily: 'Gilgor')),
                    child: Text(
                      'Deny',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColorConstants.roseWhite,
                          fontSize: 14,
                          fontFamily: 'Gilgor'),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        primary: Colors.transparent,
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: AppColorConstants.midnightPurple,
                            fontSize: 14,
                            fontFamily: 'Gilgor')),
                    child: Text(
                      'Accept',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColorConstants.artyClickPurple,
                          fontSize: 14,
                          fontFamily: 'Gilgor'),
                    ),
                    onPressed: () async {
                      setState(() {
                        isloading = true;
                      });
                      await APIServices()
                          .joinQueueMember(widget.queue.id ?? "empty",
                              widget.queue.userId ?? "empty")
                          .then((value) {
                        setState(() {
                          setState(() {
                            isloading = false;
                          });
                          joinQueue = 'Leave Queue';
                          Navigator.pop(context);
                          queListSong
                              .getQueueListSong(widget.queue.id ?? 'empty');
                          print('print admin status :${widget.queue.id}');
                          _queueMethod();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.amber,
                                  content: Text('User Added to Queue')));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RecentQueues(),
                            ),
                          );
                        });
                      });
                      print("objectobjectobject : user added");
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void leavequeueDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: AppColorConstants.mirage,
          title: Center(
              child: Text(
            'Permission Request',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColorConstants.roseWhite,
                fontSize: 22,
                fontFamily: 'Gilgor'),
          )),
          content: Text(
            "do you want to leave the Queue?",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w300,
                color: AppColorConstants.roseWhite,
                fontSize: 14,
                fontFamily: 'Gilgor'),
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        primary: Colors.transparent,
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: AppColorConstants.roseWhite,
                            fontSize: 14,
                            fontFamily: 'Gilgor')),
                    child: Text(
                      'Deny',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColorConstants.roseWhite,
                          fontSize: 14,
                          fontFamily: 'Gilgor'),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        primary: Colors.transparent,
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: AppColorConstants.midnightPurple,
                            fontSize: 14,
                            fontFamily: 'Gilgor')),
                    child: Text(
                      'Allow',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColorConstants.artyClickPurple,
                          fontSize: 14,
                          fontFamily: 'Gilgor'),
                    ),
                    onPressed: () async {
                      // ignore: unawaited_futures
                      AppRoutes.pop(context);
                      setState(() {
                        isloading = true;
                      });
                      BaseHelper()
                          .leaveQueueMember(widget.queue.id ?? "empty",
                              widget.queue.userId ?? "empty", context)
                          .then((value) {
                        // setState(() {
                        //   isloading = false;
                        // });
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const RecentQueues(),
                        //   ),
                        // );
                        // Navigator.pop(context);

                        if (value['message']
                                .toString()
                                .contains("Deleted Successfully") &&
                            value['message'] != null) {
                          print("i got leave member response: $value");
                          setState(() {
                            isloading = false;
                          });
                          AppRoutes.makeFirst(context, RecentQueues());
                          _showToast(context, value.toString());
                        } else {
                          setState(() {
                            isloading = false;
                          });
                          _showToast(context, "${value['message']}!");
                        }
                      });
                      AppRoutes.makeFirst(context, RecentQueues());
                      print("objectobjectobject : user added");
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showToast(BuildContext context, String message) {
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: message.toString().contains("Leaved Successfully!")
            ? Colors.green
            : Colors.red,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
    //   _scaffoldKey.currentState!.showSnackBar(new SnackBar(content: new Text("")));
    // ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text(message), duration: const Duration(seconds: 1)));
  }

  Widget buildRecentQueuesUI() {
    var count = QueueNotifier().membersCounts;

    return ValueListenableBuilder<int>(
      valueListenable: QueueNotifier().membersCounts,
      builder: (BuildContext context, int value, Widget? child) {
        // This builder will only get called when the counter
        // is updated.

        return SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            SizedBox(height: 41.h),

            ///Join Queue
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: InkWell(
                        onTap: () {
                          debugPrint('should open profile...');
                          Navigator.of(context).pushNamed('/profile-settings');
                        },
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            )))),
                widget.queue.isAdmin == true && widget.queue.isMember == false
                    ? Container(
                        height: 0,
                        width: 0,
                      )
                    : widget.queue.isAdmin == true &&
                            widget.queue.isMember == true
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : widget.queue.isAdmin == false &&
                                widget.queue.isMember == true
                            ? isloading == true
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.r), // <-- Radius
                                      ),
                                    ),
                                    onPressed: leavequeueDialog,
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          AppColorConstants.artyClickPurple,
                                          AppColorConstants.jasminePurple
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        constraints:
                                            BoxConstraints(minWidth: 88.w),
                                        child: Text("Leave Queue",
                                            textAlign: TextAlign.center),
                                      ),
                                    ),
                                  )
                            : isloading == true
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.r), // <-- Radius
                                      ),
                                    ),
                                    onPressed: _showDialog,
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          AppColorConstants.artyClickPurple,
                                          AppColorConstants.jasminePurple
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        constraints:
                                            BoxConstraints(minWidth: 88.w),
                                        child: Text(joinQueue,
                                            textAlign: TextAlign.center),
                                      ),
                                    ),
                                  )
              ],
            ),
            SizedBox(height: 36.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 11.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Image.asset(
                  //   '${AssetsPathConstants.assetsPNGPath}/circular_mic.png',
                  //   height: 132.h,
                  //   width: 132.w,
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width * .2,
                    height: MediaQuery.of(context).size.height * .1,
                    child: ClipOval(
                        child:
                            //  widget.queue.image.toString().isNotEmpty ||
                            //         widget.queue.image != null ||
                            //         widget.queue.image.toString() != 'null'
                            widget.queue.image != null
                                ? Image.network(
                                    "${BaseHelper().baseUrl}${widget.queue.image}",
                                    fit: BoxFit.cover,
                                    height: 132.h,
                                    width: 132.w,
                                  )
                                : Image.network(
                                    'https://www.w3schools.com/howto/img_avatar.png',
                                    height: 132.h,
                                    width: 132.w,
                                    fit: BoxFit.cover,
                                  )
                        // child: Image.asset(recentQueueList[index].thumbnailUrl,
                        // height: 70.h),
                        ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.queue.user?.username == null
                              ? 'unknown'
                              : 'Created by : ${widget.queue.user?.username}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                        Text(
                          '${widget.queue.name}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800),
                        ),
                        ValueListenableBuilder<List<SongsData>>(
                            valueListenable: songsData,
                            builder:
                                (BuildContext context, value, Widget? child) {
                              return RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Songs : ',
                                        style: TextStyle(
                                            fontFamily: 'Gilroy',
                                            fontSize: 15.sp,
                                            color: Colors.grey)),
                                    TextSpan(
                                        text: '${songsData.value.length}',
                                        style: TextStyle(
                                            fontFamily: 'Gilroy',
                                            fontSize: 15.sp,
                                            color: Colors.white)),
                                  ],
                                ),
                              );
                            }),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Members : ',
                                  style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      fontSize: 15.sp,
                                      color: Colors.grey)),
                              TextSpan(
                                  text:
                                      '${UserSingleton.instance.membersCount}',
                                  style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      fontSize: 15.sp,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                        // RichText(
                        //   text: TextSpan(
                        //     children: <TextSpan>[
                        //       TextSpan(
                        //           text: 'Times Played : ',
                        //           style: TextStyle(
                        //               fontFamily: 'Gilroy',
                        //               fontSize: 15.sp,
                        //               color: Colors.grey)),
                        //       TextSpan(
                        //           text: widget.queue.queueData?.owner
                        //                       ?.displayName ==
                        //                   null
                        //               ? 'unknown'
                        //               : '${widget.queue.queueData?.owner?.displayName}',
                        //           style: TextStyle(
                        //               fontFamily: 'Gilroy',
                        //               fontSize: 15.sp,
                        //               color: Colors.white)),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            ///recent queues songs
            ///
            SizedBox(height: 36.h),
            widget.queue.isAdmin == true && widget.queue.isMember == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10.r), // <-- Radius
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddMusic(widget.queue, userTrackList),
                              ));
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              AppColorConstants.artyClickPurple,
                              AppColorConstants.jasminePurple
                            ]),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            constraints: BoxConstraints(minWidth: 88.w),
                            child:
                                Text("Add Music", textAlign: TextAlign.center),
                          ),
                        ),
                      )
                    ],
                  )
                : widget.queue.isAdmin == true && widget.queue.isMember == false
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10.r), // <-- Radius
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddMusic(widget.queue, userTrackList),
                                  ));
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  AppColorConstants.artyClickPurple,
                                  AppColorConstants.jasminePurple
                                ]),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                constraints: BoxConstraints(minWidth: 88.w),
                                child: Text("Add Music",
                                    textAlign: TextAlign.center),
                              ),
                            ),
                          )
                        ],
                      )
                    : Container(),
            widget.queue.isMember == true || widget.queue.isAdmin == true
                ? _buildPlayerStateWidget()
                : Container(
                    width: 0,
                    height: 0,
                  ),
            SizedBox(height: 15.h),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 11.w),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Queues Song',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  AppColorConstants.roseWhite.withOpacity(0.7),
                              fontSize: 22)),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AllQueueSongs(widget.queue),
                                ));
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => SeeMostPlayed()));
                          },
                          child: Text(AppTextConstants.seeAll,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColorConstants.roseWhite,
                                  fontSize: 13)))
                    ])),
            //Queue Songs

            buildTrackUI(),

            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 11.w,
            //   ),
            //   // child: buildTopPlayedItemList(),
            //   child: FutureBuilder<Iterable<spot.Track>>(
            //     future: SpotifyApiService.getTopTracks(),
            //     builder: (BuildContext context,
            //         AsyncSnapshot<Iterable<spot.Track>> recentPlayed) {
            //       switch (recentPlayed.connectionState) {
            //         case ConnectionState.waiting:
            //           return const Center(
            //             child: CircularProgressIndicator(),
            //           );
            //         case ConnectionState.done:
            //           if (recentPlayed.hasError) {
            //             return Text(recentPlayed.error.toString());
            //           } else {
            //             return buildTopQueuedItemList(recentPlayed.data!);
            //           }
            //         // ignore: no_default_cases
            //         default:
            //           return const Text('Unhandle State');
            //       }
            //     },
            //   ),
            // ),

            ///
            /// recent queues ending
            SizedBox(height: 36.h),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 11.w),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(AppTextConstants.mostPlayed,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  AppColorConstants.roseWhite.withOpacity(0.7),
                              fontSize: 22)),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SeeAllTopPlayed(
                                      songsData,
                                    )));
                          },
                          child: Text(AppTextConstants.seeAll,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColorConstants.roseWhite,
                                  fontSize: 13)))
                    ])),
            ValueListenableBuilder<List<SongsData>>(
                valueListenable: songsData,
                builder: (BuildContext context, value, Widget? child) {
                  // ignore: unnecessary_null_comparison
                  // print("hedsadsallo: $value");
                  if (value.isEmpty) {
                    return SizedBox(
                      // height: MediaQuery.of(context).size.height * .06,
                      width: MediaQuery.of(context).size.width * .9,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                        width: MediaQuery.of(context).size.width * .9,
                        height: MediaQuery.of(context).size.height * .22,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return newSongsWidget(value[index], index);
                          },
                          itemCount: value.length >= 3 ? 3 : value.length,
                        ));
                  }
                }),

            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 11.w,
            //   ),
            //   // child: buildTopPlayedItemList(),
            //   child: FutureBuilder<Iterable<spot.Track>>(
            //     future: SpotifyApiService.getTopTracks(),
            //     builder: (BuildContext context,
            //         AsyncSnapshot<Iterable<spot.Track>> recentPlayed) {
            //       switch (recentPlayed.connectionState) {
            //         case ConnectionState.waiting:
            //           return const Center(
            //             child: CircularProgressIndicator(),
            //           );
            //         case ConnectionState.done:
            //           if (recentPlayed.hasError) {
            //             return Text(recentPlayed.error.toString());
            //           } else {
            //             return buildTopPlayedItemList(recentPlayed.data!);
            //           }
            //         // ignore: no_default_cases
            //         default:
            //           return const Text('Unhandle State');
            //       }
            //     },
            //   ),
            // ),

            // SizedBox(height: 20.h),
            // Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 11.w),
            //     child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: <Widget>[
            //           Text(AppTextConstants.allSongs,
            //               style: TextStyle(
            //                   fontWeight: FontWeight.bold,
            //                   color: AppColorConstants.roseWhite.withOpacity(0.7),
            //                   fontSize: 22)),
            //           TextButton(
            //               onPressed: () {
            //                 // Navigator.of(context).push(MaterialPageRoute(
            //                 //     builder: (context) => SeeAllTopPlayed(
            //                 //       so
            //                 //     )));
            //               },
            //               child: Text(AppTextConstants.seeAll,
            //                   style: TextStyle(
            //                       fontWeight: FontWeight.bold,
            //                       color: AppColorConstants.roseWhite,
            //                       fontSize: 13)))
            //         ])),

            // ///all songs widget
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 11.w,
            //   ),
            //   // child: buildTopPlayedItemList(),
            //   child: FutureBuilder<Iterable<spot.PlayHistory>>(
            //     future: SpotifyApiService.getRecentPlayed(),
            //     builder: (BuildContext context,
            //         AsyncSnapshot<Iterable<spot.PlayHistory>> recentPlayed) {
            //       switch (recentPlayed.connectionState) {
            //         case ConnectionState.waiting:
            //           return const Center(
            //             child: CircularProgressIndicator(),
            //           );
            //         case ConnectionState.done:
            //           if (recentPlayed.hasError) {
            //             return Text(recentPlayed.error.toString());
            //           } else {
            //             return buildRecentPlayedItemList(recentPlayed.data!);
            //           }
            //         // ignore: no_default_cases
            //         default:
            //           return const Text('Unhandle State');
            //       }
            //     },
            //   ),
            // ),

            SizedBox(height: 20.h),
            Divider(
              color: AppColorConstants.paleSky,
            ),
            SizedBox(height: 20.h),

            ///members
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 11.w),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(AppTextConstants.members,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  AppColorConstants.roseWhite.withOpacity(0.7),
                              fontSize: 22)),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SeeAllMemeber(
                                  widget.queue?.id ?? 'empty', widget.queue),
                            ));
                          },
                          child: Text(AppTextConstants.seeAll,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColorConstants.roseWhite,
                                  fontSize: 13)))
                    ])),
            SizedBox(height: 20.h),
            buildFriendList()
          ]),
        );
      },
    );
  }

  Widget _buildPlayerStateWidget() {
    return queuecustomPlayer(
      userTrackList: userTrackList,
    );
    // customPlayer();
  }

  Widget newSongsWidget(SongsData songsResult, int index) {
    // print(
    //     "image url: ${songsResult.tracksData!.tracks!.album!.images![0].url}");
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * .08),
      child: ListTile(
        onTap: () async {
          if (widget.queue.isMember == true || widget.queue.isAdmin == true) {
            BaseHelper()
                .songsPLayed(
                    context: context, uriId: songsResult.uri.toString())
                .then((value) {
              print("song played with uri");
              // songsData.value = value;
            });
            var songURL = songsResult.uri.toString();
            await play(songURL);
          } else {}

          // songName = songsResult.name.toString();
          // songURL = songsResult.uri.toString();
          // await play(songURL);
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

        // FutureBuilder<spot.Artist>(
        //   future: SpotifyApiService.getArtistDetails(
        //       songsResult.tracksData!.tracks.artists!.first.id!), // async work
        //   builder: (BuildContext context, AsyncSnapshot<spot.Artist> snapshot) {
        //     switch (snapshot.connectionState) {
        //       case ConnectionState.waiting:
        //         return const SizedBox(
        //           height: 50,
        //           width: 50,
        //           child: Center(child: CircularProgressIndicator()),
        //         );

        //       // ignore: no_default_cases
        //       default:
        //         if (snapshot.hasError)
        //           return Text('Error: ${snapshot.error}');
        //         else
        //           print(
        //               "uri images :  ${snapshot.data!.images!.first.url.toString()}");

        //         return Padding(
        //           padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
        //           child: Container(
        //             height: 50,
        //             width: 50,
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(8),
        //               image: DecorationImage(
        //                   image: NetworkImage(
        //                       snapshot.data!.images!.first.url.toString()),
        //                   fit: BoxFit.cover),
        //             ),
        //             child: Align(
        //               child: Image.asset(
        //                   '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}'),
        //             ),
        //           ),
        //         );
        //     }
        //   },
        // ),

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
      ),
    );
  }

  Widget buildRecentQueuesList() {
    return Container(
        height: 120.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: ListView.builder(
          itemCount: recentQueueList.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return buildRecentQueueItem(index);
          },
        ));
  }

  Widget buildRecentQueueItem(int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Column(
        children: <Widget>[
          InkWell(
              onTap: () {
                setState(() {
                  selectedQueueIndex = index;
                });
              },
              child: Container(
                decoration: selectedQueueIndex == index
                    ? BoxDecoration(
                        gradient: LinearGradient(
                          begin: const Alignment(-0.5, 0),
                          colors: <Color>[
                            AppColorConstants.artyClickPurple,
                            AppColorConstants.rubberDuckyYellow
                          ],
                        ),
                        borderRadius: BorderRadius.circular(50),
                      )
                    : const BoxDecoration(),
                height: 60,
                width: 60,
                child: Padding(
                  padding: const EdgeInsets.all(1.5),
                  child: Container(
                      decoration: BoxDecoration(
                        color: AppColorConstants.mirage,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Container(
                          padding: const EdgeInsets.all(6),
                          child: ClipOval(
                              child: Image.asset(
                                  recentQueueList[index].thumbnailUrl,
                                  height: 70.h)))),
                ),
              )),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
              width: 60.w,
              child: Text(
                recentQueueList[index].name,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 10.sp),
              ))
        ],
      ),
    );
  }

  Widget buildTopPlayedItemList(Iterable<spot.Track> rPlayed) {
    final Iterable<spot.Track> firstThree = rPlayed.take(3);
    return Column(
      children: List.generate(
          firstThree.length,
          (int index) =>
              buildTopPlayedItem(firstThree.elementAt(index), index)),
    );
  }

  updateCount(count) {
    print("update called:");
    QueueNotifier().setMembersCount(count);
  }

  Widget buildRecentPlayedItemList(Iterable<spot.PlayHistory> rPlayed) {
    final Iterable<spot.PlayHistory> firstThree = rPlayed.take(3);
    return Column(
      children: List.generate(
          firstThree.length,
          (int index) =>
              buildRecentPlayedItem(firstThree.elementAt(index), index)),
    );
  }

  Widget buildTopPlayedItem(spot.Track item, int index) {
    return ListTile(
      onTap: () async {
        BaseHelper()
            .songsPLayed(context: context, uriId: item.uri.toString())
            .then((value) {
          print("song played with uri");
        });
        var songURL = item.uri.toString();

        await play(songURL);
      },
      contentPadding: EdgeInsets.zero,
      key: Key(item.id.toString()),
      leading: FutureBuilder<spot.Artist>(
        future: SpotifyApiService.getArtistDetails(
            item.artists!.first.id!), // async work
        builder: (BuildContext context, AsyncSnapshot<spot.Artist> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const SizedBox(
                height: 50,
                width: 50,
                child: Center(child: CircularProgressIndicator()),
              );

            // ignore: no_default_cases
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                          image: NetworkImage(
                              snapshot.data!.images!.first.url.toString()),
                          fit: BoxFit.cover),
                    ),
                    child: Align(
                      child: Image.asset(
                          '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}'),
                    ),
                  ),
                );
              }
          }
        },
      ),
      title: Text(
        item.name!,
        key: Key(index.toString() + item.id.toString()),
        style: TextStyle(
            color: AppColorConstants.roseWhite,
            fontWeight: FontWeight.w600,
            fontSize: 17),
      ),
      subtitle: Text(
        item.artists!.last.name!,
        key: Key("item" + index.toString()),
        style: TextStyle(color: AppColorConstants.paleSky, fontSize: 13),
      ),
    );
  }

  /// recently played items and friend list
  Widget buildRecentPlayedItem(spot.PlayHistory item, int index) {
    return ListTile(
      onTap: () async {
        BaseHelper()
            .songsPLayed(context: context, uriId: item.track!.uri.toString())
            .then((value) {
          print("song played with uri");
        });
        var songURL = item.track?.uri.toString();
        await play(songURL!);
      },
      contentPadding: EdgeInsets.zero,
      leading: FutureBuilder<spot.Artist>(
        future: SpotifyApiService.getArtistDetails(
            item.track!.artists!.first.id!), // async work
        builder: (BuildContext context, AsyncSnapshot<spot.Artist> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const SizedBox(
                height: 50,
                width: 50,
                child: Center(child: CircularProgressIndicator()),
              );

            // ignore: no_default_cases
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                          image: NetworkImage(
                              snapshot.data!.images!.first.url.toString()),
                          fit: BoxFit.cover),
                    ),
                    child: Align(
                      child: Image.asset(
                          '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}'),
                    ),
                  ),
                );
              }
          }
        },
      ),
      title: Text(
        item.track!.name!,
        key: Key(index.toString() + item.track!.id.toString()),
        style: TextStyle(
            color: AppColorConstants.roseWhite,
            fontWeight: FontWeight.w600,
            fontSize: 17),
      ),
      subtitle: Text(
        item.track!.artists!.last.name!,
        key: Key("item" + index.toString()),
        style: TextStyle(color: AppColorConstants.paleSky, fontSize: 13),
      ),
    );
  }

  Widget buildFriendList() {
    tempQueueID = widget.queue.id;
    print('friend object calling members: $tempQueueID');
    return FutureBuilder<APIStandardReturnFormat>(
      future: APIServices().getQueueMember('${tempQueueID}'), // async work
      builder: (BuildContext context,
          AsyncSnapshot<APIStandardReturnFormat> snapshot) {
        print('friend object calling 2');
        print('friend object calling 2 ${snapshot.connectionState}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const SizedBox(
              height: 50,
              width: 50,
              child: Center(child: CircularProgressIndicator()),
            );
          case ConnectionState.done:
            final dynamic jsonData = jsonDecode(snapshot.data!.successResponse);
            print("members data: $jsonData");
            updateCount(jsonData.length);

            final List<QueueMemberModel> members = <QueueMemberModel>[];
            final qMembers = (jsonData as List)
                .map((i) => QueueMemberModel.fromJson(i))
                .toList();
            members.addAll(qMembers);

            return Container(
                height: 120.h,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: qMembers.length,
                  itemBuilder: (BuildContext context, int index) {
                    print('my user id : ${userId}');
                    print("memner user id: ${qMembers[index].userId}");
                    //return buildFriendItem(qMembers[index], index);
                    return qMembers[index].userId.toString() ==
                            userId.toString()
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => MemberProfile(
                                                qMembers[index])));
                                  },
                                  child: qMembers[index].user?.image != null
                                      ? Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              // borderRadius: BorderRadius.circular(8),
                                              image: DecorationImage(
                                                //image: NetworkImage(friendList[index].profileImageUrl),
                                                image: NetworkImage(
                                                    "${BaseHelper().baseUrl}${qMembers[index].user.image}"),
                                                fit: BoxFit.fill,
                                              )),
                                        )
                                      : Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: const DecorationImage(
                                                //image: NetworkImage(friendList[index].profileImageUrl),
                                                image: AssetImage(
                                                    'assets/images/png/avatar14.png'),
                                                fit: BoxFit.fitHeight,
                                              )),
                                        ),
                                ),
                                SizedBox(
                                  height: 6.h,
                                ),
                                Text(qMembers[index].user.username,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600))
                              ],
                            ),
                          );
                  },
                ));
          // ignore: no_default_cases
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else if (snapshot.data!.status == 'error') {
              return Text('Error: ${snapshot.error}');
            } else {
              final dynamic jsonData =
                  jsonDecode(snapshot.data!.successResponse);
              final List<QueueMemberModel> members = <QueueMemberModel>[];
              final qMembers = (jsonData as List)
                  .map((i) => QueueMemberModel.fromJson(i))
                  .toList();
              members.addAll(qMembers);
              return Container(
                  height: 120.h,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: qMembers.length,
                    itemBuilder: (BuildContext context, int index) {
                      print('qMembers length : ${qMembers.length}');
                      //return buildFriendItem(qMembers[index], index);
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        MemberProfile(qMembers[index])));
                              },
                              child: qMembers[index].user?.image == null
                                  ? Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            //image: NetworkImage(friendList[index].profileImageUrl),
                                            image: NetworkImage(
                                                qMembers[index].user.image),
                                            fit: BoxFit.fitHeight,
                                          )),
                                    )
                                  : Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: const DecorationImage(
                                            //image: NetworkImage(friendList[index].profileImageUrl),
                                            image: AssetImage(
                                                'assets/images/png/avatar14.png'),
                                            fit: BoxFit.fitHeight,
                                          )),
                                    ),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            Text(qMembers[index].user.username,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600))
                          ],
                        ),
                      );
                    },
                  ));
            }
        }
      },
    );
  }

  Widget buildFriendItem(QueueMemberModel member, int index) {
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
          Text(member.user.username,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600))
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<RecentQueueModel>(
          'recentQueueList', recentQueueList))
      ..add(IterableProperty<RecentlyPlayedModel>(
          'topPlayedItems', topPlayedItems))
      ..add(IntProperty('selectedQueueIndex', selectedQueueIndex))
      ..add(IterableProperty<PeopleModel>('friendList', friendList));
  }

  Future<void> play(String uri) async {
    try {
      await SpotifySdk.play(spotifyUri: uri);
      SpotifySdk.seekTo(positionedMilliseconds: 0);
      // await SpotifySdk.play(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      print("platform exception: ${e.message}");
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
  }

  ///recent queues song list

  Widget buildTopQueuedItemList(Iterable<spot.Track> rPlayed) {
    final Iterable<spot.Track> firstThree = rPlayed.take(3);
    return Column(
      children: List.generate(
          widget.queue.queueData?.tracks?.total ?? 0,
          (int index) =>
              buildTopQueuedItem(firstThree.elementAt(index), index)),
    );
  }

  Widget buildTopQueuedItem(spot.Track item, int index) {
    return ListTile(
      onTap: () async {
        BaseHelper()
            .songsPLayed(context: context, uriId: item.uri.toString())
            .then((value) {
          print("song played with uri");
        });
        var songURL = item.uri.toString();
        await play(songURL);
      },
      contentPadding: EdgeInsets.zero,
      leading: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
                image: NetworkImage(
                    widget.queue?.queueData?.images?[index]?.url ?? 'Empty'),
                fit: BoxFit.cover),
          ),
          child: Align(
            child: Image.asset(
                '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}'),
          ),
        ),
      ),
      title: Text(
        widget.queue?.queueData?.owner?.displayName ?? 'Empty',
        style: TextStyle(
            color: AppColorConstants.roseWhite,
            fontWeight: FontWeight.w600,
            fontSize: 17),
      ),
      subtitle: Text(
        widget.queue?.queueData?.owner?.type ?? 'Empty',
        style: TextStyle(color: AppColorConstants.paleSky, fontSize: 13),
      ),
    );
    // return Container(
    //       height: 20,
    //       width: 20,
    //       color: Colors.red,
    //     );
  }

/*  Widget buildPeopleUI() => FutureBuilder<List<songQueues.GetQueueListSong>>(
    future: getPeopleList(),
    builder:
        (BuildContext context, AsyncSnapshot<List<songQueues.GetQueueListSong>> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return const Center(child: CircularProgressIndicator());
        case ConnectionState.done:
          if (snapshot.data!.isNotEmpty) {
            queueSongList = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Text(
                //   '${peopleList.length} ${AppTextConstants.friends}',
                //   style: TextStyle(
                //       fontWeight: FontWeight.w700,
                //       color: AppColorConstants.roseWhite,
                //       letterSpacing: 2,
                //       fontSize: 13.sp),
                // ),
                Expanded(child: buildPeopleList())
              ],
            );
          } else {
            if (hasError) {
              return TextHelper.anErrorOccurredTextDisplay();
            }
            return TextHelper.noAvailableDataTextDisplay();
          }
        case ConnectionState.active:
          {
            return TextHelper.stableTextDisplay('You are connected');
          }
        case ConnectionState.none:
          {
            return const SizedBox.shrink();
          }
      }

      // return Container();
    },
  );

  Future<List<songQueues.GetQueueListSong>> getPeopleList() async {
    if (queListSong.I) {
      final APIStandardReturnFormat result = await APIServices().getQueueListSong(widget.queue.id ?? 'empty');
      final List<PeopleModel> peoples = <PeopleModel>[];
      final List<AllUsers> allusers = <AllUsers>[];
      final dynamic jsonData = jsonDecode(result.successResponse);
      if (result.statusCode == 200) {
        for (final dynamic res in jsonData) {
          final AllUsers user = AllUsers.fromJson(res);
          //log(user.email.toString());
          allusers.add(user);
          peoples.add(PeopleModel(
              id: 0,
              id2: user.id.toString(),
              name: user.username.toString(),
              profileImageUrl: 'https://www.w3schools.com/howto/img_avatar.png',
              isSelected: false,
              isAdmin: false,
              totalTrackCount: user.trackCount!.toInt(),
              musicPlatformsUsed: []));
        }
      } else {
        // setState(() {
        //   hasError = true;
        // });
      }
      return peoples;
    } else {
      return peopleList;
    }
  }
  Widget buildPeopleList() => ListView.builder(
    padding: EdgeInsets.symmetric(horizontal: 27.w),
    itemCount: peopleList.length,
    itemBuilder: (BuildContext context, int index) {
      return buildPeopleItem(context, index);
    },
  );*/

  ///Build User Track List
  Widget buildTrackItem(BuildContext context, int index) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return AppColorConstants.roseWhite;
      }
      return AppColorConstants.artyClickPurple;
    }

    print(
        'object : ${userTrackList[index].trackdata?.track?.album?.images?[0].url}');
    return InkWell(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 22.h),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                          image: NetworkImage(
                              '${userTrackList[index].trackdata?.track?.album?.images?[2].url}'),
                          //'https://i.scdn.co/image/ab67616d00004851cd3f6c3c2f2aa9b76fe635b1'),
                          fit: BoxFit.cover),
                    ),
                    child: Align(
                      child: Image.asset(
                          '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}'),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              '${userTrackList[index].name}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: AppColorConstants.roseWhite,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            ),
                          ),
                          widget.queue.isAdmin == true
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    BaseHelper()
                                        .deleteTrack(
                                            widget.queue.id.toString(),
                                            userTrackList[index].id.toString(),
                                            context)
                                        .then((value) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    });
                                    AppRoutes.replace(
                                        context, QueueDetails(widget.queue));
                                    // membersCount();
                                    // print("deleted tracks: ${value}");
                                    _showToast(
                                        context, "Track Deleted Successfully");
                                  },
                                  child: Icon(Icons.delete, color: Colors.red),
                                )
                              : Container(
                                  height: 0,
                                  width: 0,
                                ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                          '${userTrackList[index].trackdata?.track?.artists?[0].name}',
                          style: TextStyle(
                              color: AppColorConstants.paleSky, fontSize: 13)),
                      // MusicPlatformUsed(
                      //     musicPlatforms: StaticDataService.getMusicPlatformsUsed())
                    ],
                  ),
                ),
              ],
            ),
          ]),
      onTap: () async {
        if (widget.queue.isMember == true || widget.queue.isAdmin == true) {
          BaseHelper()
              .songsPLayed(
                  context: context,
                  uriId: userTrackList[index].trackdata!.track!.id)
              .then((value) {
            print("song played with uri");
            // songsData.value = value;
          });
          var songURL = userTrackList[index].trackdata!.track!.uri.toString();
          await play(songURL);
        } else {}
      },
    );
  }

  Widget buildTrackUI() => FutureBuilder<List<UserTrackModel>>(
        future: getUserTrack(),
        builder: (BuildContext context,
            AsyncSnapshot<List<UserTrackModel>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.data!.isNotEmpty) {
                userTrackList = snapshot.data!;

                return builduserTrackList();
              } else {
                if (hasError) {
                  return TextHelper.anErrorOccurredTextDisplay();
                }
                return TextHelper.noAvailableDataTextDisplay();
              }
            case ConnectionState.active:
              {
                return TextHelper.stableTextDisplay('You are connected');
              }
            case ConnectionState.none:
              {
                return const SizedBox.shrink();
              }
          }

          // return Container();
        },
      );

  Widget builduserTrackList() => ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 27.w),
        itemCount: userTrackList.length >= 3 ? 3 : userTrackList.length,
        itemBuilder: (BuildContext context, int index) {
          return buildTrackItem(context, index);
        },
      );

  Widget buildTracksItem(int index) => isLoading == true
      ? Center(
          child: CircularProgressIndicator(),
        )
      : Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          SizedBox(height: 22.h),
          Row(
            children: <Widget>[
              Text("Burhan",
                  style: TextStyle(
                      color: AppColorConstants.roseWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      userTrackList[index]
                          .trackdata!
                          .track!
                          .album!
                          .name
                          .toString(),
                      style: TextStyle(
                          color: AppColorConstants.roseWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  SizedBox(height: 6.h),
                  Text('0 Tracks',
                      style: TextStyle(
                          color: AppColorConstants.paleSky, fontSize: 13)),
                  // MusicPlatformUsed(
                  //     musicPlatforms: StaticDataService.getMusicPlatformsUsed())
                ],
              ),
            ],
          ),
        ]);

  Future<List<UserTrackModel>> getUserTrack() async {
    if (userTrackList.isEmpty) {
      final APIStandardReturnFormat result =
          await APIServices().getQueueListSong(widget.queue.id ?? 'empty');
      final List<UserTrackModel> userTracks = <UserTrackModel>[];

      final dynamic jsonData = jsonDecode(result.successResponse);
      if (result.statusCode == 200) {
        for (final dynamic res in jsonData) {
          final UserTrackModel track = UserTrackModel.fromJson(res);
          //log(user.email.toString());
          userTracks.add(track);
        }
      } else {
        // setState(() {
        //   hasError = true;
        // });
      }
      return userTracks;
    } else {
      return userTrackList;
    }
  }
}
