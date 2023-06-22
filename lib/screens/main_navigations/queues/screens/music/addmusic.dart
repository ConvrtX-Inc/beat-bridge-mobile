import 'dart:convert';
import 'dart:developer';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/app_list.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/helpers/basehelper.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/music_platform_model.dart';
import 'package:beatbridge/models/people_model.dart';
import 'package:beatbridge/models/recently_played_model.dart';
import 'package:beatbridge/models/users/new_queue_model.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/models/users/user_track_model.dart';
import 'package:beatbridge/screens/main_navigations/make_queues/screens/make_queue_screen.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/add_music.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/queue_details.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/recent_queue.dart';
import 'package:beatbridge/utils/approutes.dart';
import 'package:beatbridge/utils/helpers/text_helper.dart';
import 'package:beatbridge/utils/preferences/shared_preferences.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/spotify_api_service.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spotify/spotify.dart' as spot;

///Step Two
class AddMusic extends StatefulWidget {
  NewQueueModel queue;
  List<UserTrackModel> userTrackList;

  AddMusic(this.queue, this.userTrackList);

  ///Constructor
  // const AddMusic({required this.onStepTwoDone, Key? key}) : super(key: key);

  ///Callback
  // final void Function() onStepTwoDone;

  @override
  _StepTwoState createState() => _StepTwoState();

  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   properties.add(ObjectFlagProperty<void Function()>.has(
  //       'onStepTwoDone', onStepTwoDone));
  // }
}

class _StepTwoState extends State<AddMusic> {
  bool hasError = false;
  var isLoading = false;
  bool _isAPICallInProgress = false;
  List<UserTrackModel> userTrackList = <UserTrackModel>[];
  List<String> userChecked = [];
  int trackLength = 554;

  List<MusicPlatformModel> musicPlatforms = <MusicPlatformModel>[];
  final List<PeopleModel> friendList =
      StaticDataService.getPeopleListMockData();
  final List<RecentlyPlayedModel> recentlyPlayedItems =
      StaticDataService.getRecentlyPlayedMockData();
  String selectedPlatform = '';
  bool value = false;
  var selectedIndexes = [];

  //late List<bool> _isChecked;

  showSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
        // ignore: prefer_const_constructors
        SnackBar(
            content: Text("Can't go back without completing Queue"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1)));
  }

  List<String> trackChecked = [];
  @override
  void initState() {
    super.initState();
    getMusicPlatforms();
    getSongs();
    //_isChecked = List<bool>.filled(trackLength, false);
  }

  getSongs() {
    getUserTrack().then((value) {
      setState(() {
        userTrackList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorConstants.mirage,
        body: userTrackList.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .04,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .03,
                        ),
                        InkWell(
                          onTap: () {
                            AppRoutes.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .04,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: SingleChildScrollView(
                            child: Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 11.w),
                                child: Row(
                                  children: [
                                    Text(AppTextConstants.letsAddMusic,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: AppColorConstants.roseWhite,
                                            fontSize: 22)),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      child: Image.asset(
                                        musicPlatforms[0].logoImagePath,
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text('Spotify',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: AppColorConstants.roseWhite,
                                            fontSize: 22)),
                                  ],
                                )),
                          ],
                        ))),
                    Expanded(child: buildTrackUI()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        isLoading == true
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 27.w, vertical: 16.h),
                                child: ButtonRoundedGradient(
                                  buttonText: AppTextConstants.continueTxt,
                                  isLoading: _isAPICallInProgress,
                                  buttonCallback: () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    ValueNotifier<List<NewQueueModel>>
                                        queueData =
                                        ValueNotifier<List<NewQueueModel>>([]);
                                    APIServices()
                                        .recentQueue(userIdd: "0")
                                        .then((value) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      setState(() {
                                        queueData.value = value;
                                        widget.queue = queueData.value[
                                            UserSingleton.instance.queueIndex];
                                      });
                                      AppRoutes.replace(
                                          context, QueueDetails(widget.queue));
                                    });
                                    // AppRoutes.pop(context);

                                    // if (userChecked.length > 0) {
                                    //   widget.onStepTwoDone();
                                    // } else {
                                    //   ScaffoldMessenger.of(context).showSnackBar(
                                    //       // ignore: prefer_const_constructors
                                    //       SnackBar(
                                    //           content:
                                    //               Text('Please select atleast 1 track'),
                                    //           backgroundColor: Colors.red,
                                    //           duration: const Duration(seconds: 1)));
                                    // }
                                  },
                                ),
                              ),
                      ],
                    )
                  ],
                ),
              ]));
  }

  void _onSelected(bool selected, String dataname) {
    if (selected == true) {
      setState(() {
        userChecked.add(dataname);
      });
    } else {
      setState(() {
        userChecked.remove(dataname);
      });
    }
    log('$userChecked');
  }

  Widget selectFromPlaylist() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11),
      child: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(AppTextConstants.selectFromPlaylist,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColorConstants.roseWhite.withOpacity(0.7),
                        fontSize: 22)),
                TextButton(
                    onPressed: () {},
                    child: Text(AppTextConstants.seeAll,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColorConstants.roseWhite,
                            fontSize: 13)))
              ]),
          Container(
            height: 120.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  for (int i = 0; i < friendList.length - 1; i++)
                    buildFriendItem(i),
                ]),
          ),
        ],
      ),
    );
  }

  Widget buildFriendItem(int index) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          children: <Widget>[
            // ignore: prefer_if_elements_to_conditional_expressions
            friendList[index].profileImageUrl.toString().isEmpty
                ? Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage(friendList[index].profileImageUrl),
                          fit: BoxFit.fitHeight,
                        )))
                : Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(
                              "${BaseHelper().baseUrl}${friendList[index].profileImageUrl}"),
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

  Widget buildMusicSource() {
    int index = 0;
    return Padding(
        padding: EdgeInsets.all(0.w),
        child: Row(
          children: [
            Text(AppTextConstants.letsAddMusic,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColorConstants.roseWhite,
                    fontSize: 22)),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Image.asset(
                musicPlatforms[index].logoImagePath,
                width: 24,
                height: 24,
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
                child: Text(
                  musicPlatforms[index].name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: AppColorConstants.roseWhite,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                )),
          ],
        ));
  }

  Future<void> getMusicPlatforms() async {
    final String musicsString =
        SharedPreferencesRepository.getString('musicSource');
    if (musicsString == '') {
      final List<MusicPlatformModel> musicSourceList =
          AppListConstants().musicSourceList;
      final String value = MusicPlatformModel.encode(musicSourceList);
      SharedPreferencesRepository.putString('musicSource', value);
      setState(() {
        musicPlatforms = musicSourceList;
      });
    } else {
      setState(() {
        musicPlatforms = MusicPlatformModel.decode(musicsString);
        musicPlatforms = musicPlatforms
            .where((MusicPlatformModel musicSource) => musicSource.isSelected)
            .toList();
      });
    }
  }

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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
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
                Text(
                  '${userTrackList[index].name}',
                  style: TextStyle(
                      color: AppColorConstants.roseWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
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
          const Spacer(),
          Transform.scale(
              scale: 1.5,
              child: Checkbox(
                  value: userChecked.contains(userTrackList[index].id),
                  onChanged: (bool? value) async {
                    if (userChecked.contains(index)) {
                      print("object removed : ");
                      selectedIndexes.remove(index);
                    } else {
                      bool checkSong = false;
                      for (int i = 0; i < widget.userTrackList.length; i++) {
                        if (widget.userTrackList[i].uri.toString() ==
                            userTrackList[index].uri.toString()) {
                          checkSong = true;
                          break;
                        } else {
                          checkSong = false;
                        }
                      }
                      if (checkSong == true) {
                        _showToast(context, "Songs Already in Queue!");
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //         backgroundColor: Colors.green,
                        //         content: Text('Songs Already in Queue!'),
                        //         duration: Duration(seconds: 2)));
                      } else {
                        if (userChecked.contains(userTrackList[index].id)) {
                          selectedIndexes.remove(index);
                          BaseHelper()
                              .deleteTrack(widget.queue.id.toString(),
                                  userTrackList[index].id.toString(), context)
                              .then((value) {
                            setState(() {
                              print("user track delete: $value");
                              // isLoading = false;
                            });
                          });
                        } else {
                          var tempQueueID = widget.queue.id;
                          if (widget.userTrackList
                              .contains(userTrackList[index]))
                            final String? tempQueueID = widget.queue.id;
                          print("object added : $tempQueueID");
                          selectedIndexes.add(index);
                          final UserTrackModel userTracModel = UserTrackModel(
                            id: userTrackList[index].id,
                            name: userTrackList[index].name,
                            totalPlayCount: userTrackList[index].totalPlayCount,
                            uri: userTrackList[index].uri,
                            platform: userTrackList[index].platform,
                            queueId: tempQueueID,
                            userId: userTrackList[index].userId,
                            trackdata: userTrackList[index].trackdata,
                            owner: userTrackList[index].owner,
                            createdDate: userTrackList[index].createdDate,
                            updatedDate: userTrackList[index].updatedDate,
                            deletedDate: userTrackList[index].deletedDate,
                          );

                          print(
                              'object queueId : ${userTrackList[index].queueId}');
                          print(
                              'object userId: ${userTrackList[index].userId}');
                          _onSelected(value!, userTrackList[index].id ?? '0');
                          final APIStandardReturnFormat result =
                              await APIServices().userTrackData(userTracModel);
                          _showToast(context, "Song Added in Queue!");
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(
                          //         backgroundColor: Colors.green,
                          //         content: Text('Songs Added in Queue'),
                          //         duration: Duration(seconds: 2)));
                        }
                      }
                    }
                  },
                  checkColor: AppColorConstants.rubberDuckyYellow,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  side: MaterialStateBorderSide.resolveWith(
                    (Set<MaterialState> states) => BorderSide(
                      width: 2,
                      color: AppColorConstants.paleSky,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))))
        ],
      ),
    ]);
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

  Widget buildTrackUI() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Text(
          //   '${userTrackList.length} ${AppTextConstants.friends}',
          //   style: TextStyle(
          //       fontWeight: FontWeight.w700,
          //       color: AppColorConstants.roseWhite,
          //       letterSpacing: 2,
          //       fontSize: 13.sp),
          // ),
          Expanded(child: builduserTrackList())
        ],
      );

  // FutureBuilder<List<UserTrackModel>>(
  //       future: getUserTrack(),
  //       builder: (BuildContext context,
  //           AsyncSnapshot<List<UserTrackModel>> snapshot) {
  //         switch (snapshot.connectionState) {
  //           case ConnectionState.waiting:
  //             return const Center(child: CircularProgressIndicator());
  //           case ConnectionState.done:
  //             if (snapshot.data!.isNotEmpty) {
  //               userTrackList = snapshot.data!;

  //               return Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //                   // Text(
  //                   //   '${userTrackList.length} ${AppTextConstants.friends}',
  //                   //   style: TextStyle(
  //                   //       fontWeight: FontWeight.w700,
  //                   //       color: AppColorConstants.roseWhite,
  //                   //       letterSpacing: 2,
  //                   //       fontSize: 13.sp),
  //                   // ),
  //                   Expanded(child: builduserTrackList())
  //                 ],
  //               );
  //             } else {
  //               if (hasError) {
  //                 return TextHelper.anErrorOccurredTextDisplay();
  //               }
  //               return TextHelper.noAvailableDataTextDisplay();
  //             }
  //           case ConnectionState.active:
  //             {
  //               return TextHelper.stableTextDisplay('You are connected');
  //             }
  //           case ConnectionState.none:
  //             {
  //               return const SizedBox.shrink();
  //             }
  //         }

  //         // return Container();
  //       },
  //     );

  Widget builduserTrackList() => ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 27.w),
        itemCount: userTrackList.length,
        itemBuilder: (BuildContext context, int index) {
          for (int i = 0; i < widget.userTrackList.length; i++) {
            if (widget.userTrackList[i].uri.toString() ==
                userTrackList[index].uri.toString()) {
              userChecked.add(userTrackList[index].id ?? '0');
              // _onSelected(true!, userTrackList[index].id ?? '0');
              // break;
            } else {}
          }
          return buildTrackItem(context, index);
        },
      );

  Widget buildTracksItem(int index) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        SizedBox(height: 22.h),
        Row(
          children: <Widget>[
            Text("Burhan",
                style: TextStyle(
                    color: AppColorConstants.roseWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
            // Padding(
            //     padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
            //     child: Container(
            //       height: 60,
            //       width: 60,
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(8),
            //           image: DecorationImage(
            //             image: AssetImage(userTrackList[index].profileImageUrl),
            //             fit: BoxFit.fitHeight,
            //           )),
            //     )),
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
          await APIServices().getAllUserTrackAgainstUserId();
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<MusicPlatformModel>(
          'musicPlatforms', musicPlatforms))
      ..add(StringProperty('selectedPlatform', selectedPlatform));
  }
}

// import 'dart:convert';
// import 'dart:developer';

// import 'package:beatbridge/constants/app_constants.dart';
// import 'package:beatbridge/constants/app_list.dart';
// import 'package:beatbridge/constants/asset_path.dart';
// import 'package:beatbridge/models/apis/api_standard_return.dart';
// import 'package:beatbridge/models/music_platform_model.dart';
// import 'package:beatbridge/models/people_model.dart';
// import 'package:beatbridge/models/recently_played_model.dart';
// import 'package:beatbridge/models/users/new_queue_model.dart';
// import 'package:beatbridge/models/users/user_track_model.dart';
// import 'package:beatbridge/screens/main_navigations/make_queues/screens/make_queue_screen.dart';
// import 'package:beatbridge/screens/main_navigations/queues/screens/recent_queue.dart';
// import 'package:beatbridge/utils/approutes.dart';
// import 'package:beatbridge/utils/helpers/text_helper.dart';
// import 'package:beatbridge/utils/preferences/shared_preferences.dart';
// import 'package:beatbridge/utils/services/rest_api_service.dart';
// import 'package:beatbridge/utils/services/spotify_api_service.dart';
// import 'package:beatbridge/utils/services/static_data_service.dart';
// import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:spotify/spotify.dart' as spot;

// ///Step Two
// class AddMusic extends StatefulWidget {
//   final NewQueueModel queue;

//   AddMusic(this.queue);

//   ///Constructor
//   // const AddMusic({required this.onStepTwoDone, Key? key}) : super(key: key);

//   ///Callback
//   // final void Function() onStepTwoDone;

//   @override
//   _StepTwoState createState() => _StepTwoState();

//   // @override
//   // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//   //   super.debugFillProperties(properties);
//   //   properties.add(ObjectFlagProperty<void Function()>.has(
//   //       'onStepTwoDone', onStepTwoDone));
//   // }
// }

// class _StepTwoState extends State<AddMusic> {
//   bool hasError = false;
//   bool _isAPICallInProgress = false;
//   var selectedIndexes = [];
//   List<UserTrackModel> userTrackList = <UserTrackModel>[];
//   List<String> userChecked = [];
//   List<MusicPlatformModel> musicPlatforms = <MusicPlatformModel>[];
//   // final List<PeopleModel> friendList =
//   //     StaticDataService.getuserTrackListMockData();
//   final List<RecentlyPlayedModel> recentlyPlayedItems =
//       StaticDataService.getRecentlyPlayedMockData();
//   String selectedPlatform = '';

//   @override
//   void initState() {
//     super.initState();
//     //getMusicPlatforms();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: AppColorConstants.mirage,
//         body: Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           child: // for (int i = 0; i < musicPlatforms.length; i++)
//               Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       SizedBox(
//                         height: 20.h,
//                       ),
//                       Row(
//                         children: [
//                           Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 10.w),
//                               child: IconButton(
//                                 icon: Icon(
//                                   Icons.arrow_back_ios,
//                                   color: AppColorConstants.roseWhite,
//                                 ),
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                 },
//                               )),
//                         ],
//                       ),
//                       // Padding(
//                       //   padding: EdgeInsets.symmetric(horizontal: 11.w),
//                       //   child: buildMusicSource(),
//                       // ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(11, 15, 0, 0),
//                         child: Divider(color: AppColorConstants.paleSky),
//                       ),
//                       // SizedBox(
//                       //     height: 350,
//                       //     child: ListView.builder(
//                       //         padding: EdgeInsets.symmetric(horizontal: 27.w),
//                       //         itemCount: recentlyPlayedItems.length,
//                       //         shrinkWrap: true,
//                       //         itemBuilder: (BuildContext context, int index) {
//                       //           return Column(
//                       //             crossAxisAlignment:
//                       //                 CrossAxisAlignment.stretch,
//                       //             children: <Widget>[
//                       //               buildRecentlyPlayedItem(context, index),
//                       //             ],
//                       //           );
//                       //         })),
//                       buildPeopleUI(),

//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(11, 15, 0, 0),
//                         child: Divider(color: AppColorConstants.paleSky),
//                       ),
//                       //selectFromPlaylist()
//                       SizedBox(
//                         height: 10.h,
//                       ),

//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 27.w, vertical: 16.h),
//                         child: ButtonRoundedGradient(
//                           buttonText: AppTextConstants.continueTxt,
//                           buttonCallback: () async {
//                             // Navigator.of(context).pop();
//                             AppRoutes.makeFirst(context, RecentQueues());
//                             // await Navigator.pushAndRemoveUntil(
//                             //     context,
//                             //     MaterialPageRoute(
//                             //         builder: (BuildContext context) =>
//                             //             RecentQueues()),
//                             //     (Route<dynamic> route) => false);
//                             // if (userChecked.length > 0) {
//                             //   widget.onStepTwoDone();
//                             // } else {
//                             //   ScaffoldMessenger.of(context).showSnackBar(
//                             //       // ignore: prefer_const_constructors
//                             //       SnackBar(
//                             //           content: Text('Please select atleast 1 track'),
//                             //           backgroundColor: Colors.red,
//                             //           duration: const Duration(seconds: 1)));
//                             // }
//                           },
//                         ),
//                       ),
//                     ],
//                   )),
//         ));
//   }

//   Widget buildPeopleItem(BuildContext context, int index) {
//     Color getColor(Set<MaterialState> states) {
//       const Set<MaterialState> interactiveStates = <MaterialState>{
//         MaterialState.pressed,
//         MaterialState.hovered,
//         MaterialState.focused,
//       };
//       if (states.any(interactiveStates.contains)) {
//         return AppColorConstants.roseWhite;
//       }
//       return AppColorConstants.artyClickPurple;
//     }

//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
//         Widget>[
//       SizedBox(height: 22.h),
//       Row(
//         children: <Widget>[
//           // Padding(
//           //     padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
//           //     child: Container(
//           //       height: 50,
//           //       width: 50,
//           //       decoration: BoxDecoration(
//           //           borderRadius: BorderRadius.circular(8),
//           //           image: DecorationImage(
//           //             //image: AssetImage(userTrackList[index].profileImageUrl),
//           //             // ignore: unnecessary_new
//           //             image: new NetworkImage(
//           //                 userTrackList[index].trackData!.track!.album!.images![0].url),
//           //             fit: BoxFit.fitHeight,
//           //           )),
//           //     )),
//           Container(
//             width: MediaQuery.of(context).size.width * .6,
//             // height: MediaQuery.of(context).size.h,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(userTrackList[index].trackdata!.track!.name.toString(),
//                     style: TextStyle(
//                         color: AppColorConstants.roseWhite,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14)),
//                 SizedBox(height: 6.h),
//                 Text('0 Tracks',
//                     style: TextStyle(
//                         color: AppColorConstants.paleSky, fontSize: 13)),
//                 // MusicPlatformUsed(
//                 //     musicPlatforms: StaticDataService.getMusicPlatformsUsed())
//               ],
//             ),
//           ),
//           const Spacer(),
//           Transform.scale(
//               scale: 1.5,
//               child: Checkbox(
//                   value: userChecked.contains(userTrackList[index].id),
//                   onChanged: (bool? value) async {
//                     if (userChecked.contains(index)) {
//                       print("object removed : ");
//                       selectedIndexes.remove(index);
//                     } else {
//                       final String? tempQueueID = widget.queue.id;
//                       // await storage.read(key: 'tempQueueID');
//                       print("object added : $tempQueueID");
//                       selectedIndexes.add(index);
//                       final UserTrackModel userTracModel = UserTrackModel(
//                         id: userTrackList[index].id,
//                         name: userTrackList[index].name,
//                         totalPlayCount: userTrackList[index].totalPlayCount,
//                         uri: userTrackList[index].uri,
//                         platform: userTrackList[index].platform,
//                         queueId: tempQueueID,
//                         userId: userTrackList[index].userId,
//                         trackdata: userTrackList[index].trackdata,
//                         owner: userTrackList[index].owner,
//                         createdDate: userTrackList[index].createdDate,
//                         updatedDate: userTrackList[index].updatedDate,
//                         deletedDate: userTrackList[index].deletedDate,
//                       );

//                       print('object queueId : ${userTrackList[index].queueId}');
//                       print('object userId: ${userTrackList[index].userId}');

//                       _onSelected(value!, userTrackList[index].id ?? '0');

//                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                           backgroundColor: Colors.green,
//                           content: Text('Songs Added in Queue'),
//                           duration: Duration(seconds: 2)));

//                       final APIStandardReturnFormat result =
//                           await APIServices().userTrackData(userTracModel);
//                       // setState(() {
//                       //   _isAPICallInProgress = true;
//                       // });
//                       // // if (value!) {
//                       // log(userTrackList[index].isSelected.toString());
//                       // setState(() {
//                       //   userTrackList[index].isSelected = value!;
//                       // });
//                       // log(userTrackList[index].isSelected.toString());
//                       // // if (userTrackList[index].isSelected) {
//                       // await APIServices().addFriends(userTrackList[index].id2);
//                       // final String? tempQueueID =
//                       //     await storage.read(key: 'tempQueueID');
//                       // await APIServices().addQueueMember(tempQueueID, false);

//                       // _onSelected(value!, userTrackList[index].id2);
//                       // // ScaffoldMessenger.of(context).showSnackBar(
//                       // //     // ignore: prefer_const_constructors
//                       // //     SnackBar(
//                       // //         content: Text('Queue Member Added'),
//                       // //         duration: const Duration(seconds: 1)));
//                       // // } else {
//                       // //   // ScaffoldMessenger.of(context).showSnackBar(
//                       // //   //     // ignore: prefer_const_constructors
//                       // //   //     SnackBar(
//                       // //   //         content: Text('Queue Member Removed'),
//                       // //   //         duration: const Duration(seconds: 1)));
//                       // // }
//                       // // }
//                       // setState(() {
//                       //   _isAPICallInProgress = false;
//                       // });
//                     }
//                     ;
//                     checkColor:
//                     AppColorConstants.rubberDuckyYellow;
//                     fillColor:
//                     MaterialStateProperty.resolveWith(getColor);
//                     side:
//                     MaterialStateBorderSide.resolveWith(
//                       (Set<MaterialState> states) => BorderSide(
//                         width: 2,
//                         color: AppColorConstants.paleSky,
//                       ),
//                     );
//                     shape:
//                     RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5));
//                   }))
//         ],
//       ),
//     ]);
//   }

//   Widget buildPeopleUI() => FutureBuilder<List<UserTrackModel>>(
//         future: getUserTrack(),
//         builder: (BuildContext context,
//             AsyncSnapshot<List<UserTrackModel>> snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.waiting:
//               return const Center(child: CircularProgressIndicator());
//             case ConnectionState.done:
//               if (snapshot.data!.isNotEmpty) {
//                 userTrackList = snapshot.data!;
//                 return Expanded(child: builduserTrackList());
//               } else {
//                 if (hasError) {
//                   return TextHelper.anErrorOccurredTextDisplay();
//                 }
//                 return TextHelper.noAvailableDataTextDisplay();
//               }
//             case ConnectionState.active:
//               {
//                 return TextHelper.stableTextDisplay('You are connected');
//               }
//             case ConnectionState.none:
//               {
//                 return const SizedBox.shrink();
//               }
//           }

//           // return Container();
//         },
//       );

//   Widget builduserTrackList() => ListView.builder(
//         padding: EdgeInsets.symmetric(horizontal: 27.w),
//         itemCount: userTrackList.length,
//         itemBuilder: (BuildContext context, int index) {
//           return buildPeopleItem(context, index);
//         },
//       );

//   Widget buildPeoplesItem(int index) =>
//       Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
//         SizedBox(height: 22.h),
//         Row(
//           children: <Widget>[
//             Text("Burhan",
//                 style: TextStyle(
//                     color: AppColorConstants.roseWhite,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14)),
//             // Padding(
//             //     padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
//             //     child: Container(
//             //       height: 60,
//             //       width: 60,
//             //       decoration: BoxDecoration(
//             //           borderRadius: BorderRadius.circular(8),
//             //           image: DecorationImage(
//             //             image: AssetImage(userTrackList[index].profileImageUrl),
//             //             fit: BoxFit.fitHeight,
//             //           )),
//             //     )),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                     userTrackList[index]
//                         .trackdata!
//                         .track!
//                         .album!
//                         .name
//                         .toString(),
//                     style: TextStyle(
//                         color: AppColorConstants.roseWhite,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14)),
//                 SizedBox(height: 6.h),
//                 Text('0 Tracks',
//                     style: TextStyle(
//                         color: AppColorConstants.paleSky, fontSize: 13)),
//                 // MusicPlatformUsed(
//                 //     musicPlatforms: StaticDataService.getMusicPlatformsUsed())
//               ],
//             ),
//           ],
//         ),
//       ]);

//   Future<List<UserTrackModel>> getUserTrack() async {
//     if (userTrackList.isEmpty) {
//       final APIStandardReturnFormat result =
//           await APIServices().getAllUserTrackAgainstUserId();
//       final List<UserTrackModel> userTracks = <UserTrackModel>[];

//       final dynamic jsonData = jsonDecode(result.successResponse);
//       if (result.statusCode == 200) {
//         for (final dynamic res in jsonData) {
//           final UserTrackModel track = UserTrackModel.fromJson(res);
//           //log(user.email.toString());
//           userTracks.add(track);
//         }
//       } else {
//         // setState(() {
//         //   hasError = true;
//         // });
//       }
//       return userTracks;
//     } else {
//       return userTrackList;
//     }
//   }

//   void _onSelected(bool selected, String dataName) {
//     if (selected == true) {
//       setState(() {
//         userChecked.add(dataName);
//       });
//     } else {
//       setState(() {
//         userChecked.remove(dataName);
//       });
//     }
//   }

//   // Widget buildRecentPlayedItemList(Iterable<spot.PlayHistory> rPlayed) {
//   //   final Iterable<spot.PlayHistory> firstThree = rPlayed.take(10);
//   //   return Column(
//   //     children: List.generate(
//   //         firstThree.length,
//   //         (int index) =>
//   //             buildRecentPlayedItem(firstThree.elementAt(index), index)),
//   //   );
//   // }

//   // Widget buildRecentPlayedItem(spot.PlayHistory item, int index) {
//   //   Color getColor(Set<MaterialState> states) {
//   //     const Set<MaterialState> interactiveStates = <MaterialState>{
//   //       MaterialState.pressed,
//   //       MaterialState.hovered,
//   //       MaterialState.focused,
//   //     };
//   //     if (states.any(interactiveStates.contains)) {
//   //       return AppColorConstants.roseWhite;
//   //     }
//   //     return AppColorConstants.artyClickPurple;
//   //   }

//   //   log(userChecked.toString());
//   //   log(userChecked.length.toString());

//   //   return StatefulBuilder(
//   //     builder: (BuildContext context, StateSetter setState) {
//   //       return CheckboxListTile(
//   //         contentPadding: EdgeInsets.zero,
//   //         key: Key(item.track!.id.toString()),
//   //         title: ListTile(
//   //           contentPadding: EdgeInsets.zero,
//   //           key: Key(item.track!.id.toString()),
//   //           leading: FutureBuilder<spot.Artist>(
//   //             future: SpotifyApiService.getArtistDetails(
//   //                 item.track!.artists!.first.id!), // async work
//   //             builder:
//   //                 (BuildContext context, AsyncSnapshot<spot.Artist> snapshot) {
//   //               switch (snapshot.connectionState) {
//   //                 case ConnectionState.waiting:
//   //                   return const SizedBox(
//   //                     height: 50,
//   //                     width: 50,
//   //                     child: Center(child: CircularProgressIndicator()),
//   //                   );

//   //                 // ignore: no_default_cases
//   //                 default:
//   //                   if (snapshot.hasError) {
//   //                     return Text('Error: ${snapshot.error}');
//   //                   } else {
//   //                     return Padding(
//   //                       padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
//   //                       child: Container(
//   //                         height: 50,
//   //                         width: 50,
//   //                         decoration: BoxDecoration(
//   //                           borderRadius: BorderRadius.circular(8),
//   //                           image: DecorationImage(
//   //                               image: NetworkImage(snapshot
//   //                                   .data!.images!.first.url
//   //                                   .toString()),
//   //                               fit: BoxFit.cover),
//   //                         ),
//   //                         child: Align(
//   //                           child: Image.asset(
//   //                               '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}'),
//   //                         ),
//   //                       ),
//   //                     );
//   //                   }
//   //               }
//   //             },
//   //           ),
//   //           title: Text(
//   //             item.track!.name!,
//   //             key: Key(index.toString() + item.track!.id.toString()),
//   //             style: TextStyle(
//   //                 color: AppColorConstants.roseWhite,
//   //                 fontWeight: FontWeight.w600,
//   //                 fontSize: 17),
//   //           ),
//   //           subtitle: Text(
//   //             item.track!.artists!.last.name!,
//   //             key: Key("item" + index.toString()),
//   //             style: TextStyle(color: AppColorConstants.paleSky, fontSize: 13),
//   //           ),
//   //         ),
//   //         value: userChecked.contains(item.track!.id.toString()),
//   //         onChanged: (bool? value) {
//   //           //setState(() => userChecked = userChecked.add(dataName));
//   //           _onSelected(value!, item.track!.id.toString());
//   //         },
//   //         checkColor: Colors.white,
//   //         activeColor: AppColorConstants.artyClickPurple,
//   //       );
//   //     },
//   //   );

//   //   // return CheckboxListTile(
//   //   //   contentPadding: EdgeInsets.zero,
//   //   //   key: Key(item.track!.id.toString()),
//   //   //   title: ListTile(
//   //   //     contentPadding: EdgeInsets.zero,
//   //   //     key: Key(item.track!.id.toString()),
//   //   //     leading: FutureBuilder<spot.Artist>(
//   //   //       future: SpotifyApiService.getArtistDetails(
//   //   //           item.track!.artists!.first.id!), // async work
//   //   //       builder: (BuildContext context, AsyncSnapshot<spot.Artist> snapshot) {
//   //   //         switch (snapshot.connectionState) {
//   //   //           case ConnectionState.waiting:
//   //   //             return const SizedBox(
//   //   //               height: 50,
//   //   //               width: 50,
//   //   //               child: Center(child: CircularProgressIndicator()),
//   //   //             );

//   //   //           // ignore: no_default_cases
//   //   //           default:
//   //   //             if (snapshot.hasError) {
//   //   //               return Text('Error: ${snapshot.error}');
//   //   //             } else {
//   //   //               return Padding(
//   //   //                 padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
//   //   //                 child: Container(
//   //   //                   height: 50,
//   //   //                   width: 50,
//   //   //                   decoration: BoxDecoration(
//   //   //                     borderRadius: BorderRadius.circular(8),
//   //   //                     image: DecorationImage(
//   //   //                         image: NetworkImage(
//   //   //                             snapshot.data!.images!.first.url.toString()),
//   //   //                         fit: BoxFit.cover),
//   //   //                   ),
//   //   //                   child: Align(
//   //   //                     child: Image.asset(
//   //   //                         '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}'),
//   //   //                   ),
//   //   //                 ),
//   //   //               );
//   //   //             }
//   //   //         }
//   //   //       },
//   //   //     ),
//   //   //     title: Text(
//   //   //       item.track!.name!,
//   //   //       key: Key(index.toString() + item.track!.id.toString()),
//   //   //       style: TextStyle(
//   //   //           color: AppColorConstants.roseWhite,
//   //   //           fontWeight: FontWeight.w600,
//   //   //           fontSize: 17),
//   //   //     ),
//   //   //     subtitle: Text(
//   //   //       item.track!.artists!.last.name!,
//   //   //       key: Key("item" + index.toString()),
//   //   //       style: TextStyle(color: AppColorConstants.paleSky, fontSize: 13),
//   //   //     ),
//   //   //   ),
//   //   //   value: userChecked.contains(item.track!.id.toString()),
//   //   //   onChanged: (bool? value) {
//   //   //     _onSelected(value!, item.track!.id.toString());
//   //   //   },
//   //   //   checkColor: Colors.white,
//   //   //   activeColor: AppColorConstants.artyClickPurple,
//   //   // );
//   // }

//   // Widget selectFromPlaylist() {
//   //   return Padding(
//   //     padding: const EdgeInsets.symmetric(horizontal: 11),
//   //     child: Column(
//   //       children: [
//   //         Row(
//   //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //             children: <Widget>[
//   //               Text(AppTextConstants.selectFromPlaylist,
//   //                   style: TextStyle(
//   //                       fontWeight: FontWeight.bold,
//   //                       color: AppColorConstants.roseWhite.withOpacity(0.7),
//   //                       fontSize: 22)),
//   //               TextButton(
//   //                   onPressed: () {},
//   //                   child: Text(AppTextConstants.seeAll,
//   //                       style: TextStyle(
//   //                           fontWeight: FontWeight.bold,
//   //                           color: AppColorConstants.roseWhite,
//   //                           fontSize: 13)))
//   //             ]),
//   //         Container(
//   //           height: 120.h,
//   //           padding: EdgeInsets.symmetric(horizontal: 10.w),
//   //           child: ListView(
//   //               shrinkWrap: true,
//   //               scrollDirection: Axis.horizontal,
//   //               children: <Widget>[
//   //                 for (int i = 0; i < friendList.length - 1; i++)
//   //                   buildFriendItem(i),
//   //               ]),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   // Widget buildFriendItem(int index) {
//   //   return Padding(
//   //       padding: EdgeInsets.symmetric(horizontal: 8.w),
//   //       child: Column(
//   //         children: <Widget>[
//   //           Container(
//   //             height: 50,
//   //             width: 50,
//   //             decoration: BoxDecoration(
//   //                 borderRadius: BorderRadius.circular(8),
//   //                 image: DecorationImage(
//   //                   image: AssetImage(friendList[index].profileImageUrl),
//   //                   fit: BoxFit.fitHeight,
//   //                 )),
//   //           ),
//   //           SizedBox(
//   //             height: 6.h,
//   //           ),
//   //           Text(friendList[index].name,
//   //               textAlign: TextAlign.center,
//   //               style: TextStyle(
//   //                   color: Colors.white,
//   //                   fontSize: 10.sp,
//   //                   fontWeight: FontWeight.w600))
//   //         ],
//   //       ));
//   // }

//   // Widget buildTopPlayedItemList(Iterable<spot.Track> rPlayed) {
//   //   final Iterable<spot.Track> firstFour = rPlayed.take(4);
//   //   //*scrollable top played items*//
//   //   // return ListView.builder(
//   //   //   shrinkWrap: true,
//   //   //   key: const Key('topList'),
//   //   //   itemCount: firstFour.length,
//   //   //   itemBuilder: (BuildContext context, int index) {
//   //   //     // return Text(rPlayed.elementAt(index).id.toString());
//   //   //     return buildTopPlayedItem(firstFour.elementAt(index), index);
//   //   //   },
//   //   // );
//   //   return Column(
//   //     children: List.generate(firstFour.length,
//   //         (int index) => buildTopPlayedItem(firstFour.elementAt(index), index)),
//   //   );
//   // }

//   // Widget buildTopPlayedItem(spot.Track item, int index) {
//   //   return ListTile(
//   //     contentPadding: EdgeInsets.zero,
//   //     key: Key(item.id.toString()),
//   //     leading: FutureBuilder<spot.Artist>(
//   //       future: SpotifyApiService.getArtistDetails(
//   //           item.artists!.first.id!), // async work
//   //       builder: (BuildContext context, AsyncSnapshot<spot.Artist> snapshot) {
//   //         switch (snapshot.connectionState) {
//   //           case ConnectionState.waiting:
//   //             return const SizedBox(
//   //               height: 50,
//   //               width: 50,
//   //               child: Center(child: CircularProgressIndicator()),
//   //             );

//   //           // ignore: no_default_cases
//   //           default:
//   //             if (snapshot.hasError)
//   //               return Text('Error: ${snapshot.error}');
//   //             else
//   //               return Padding(
//   //                 padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
//   //                 child: Container(
//   //                   height: 50,
//   //                   width: 50,
//   //                   decoration: BoxDecoration(
//   //                     borderRadius: BorderRadius.circular(8),
//   //                     image: DecorationImage(
//   //                         image: NetworkImage(
//   //                             snapshot.data!.images!.first.url.toString()),
//   //                         fit: BoxFit.cover),
//   //                   ),
//   //                   child: Align(
//   //                     child: Image.asset(
//   //                         '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}'),
//   //                   ),
//   //                 ),
//   //               );
//   //         }
//   //       },
//   //     ),
//   //     title: Text(
//   //       item.name!,
//   //       key: Key(index.toString() + item.id.toString()),
//   //       style: TextStyle(
//   //           color: AppColorConstants.roseWhite,
//   //           fontWeight: FontWeight.w600,
//   //           fontSize: 17),
//   //     ),
//   //     subtitle: Text(
//   //       item.artists!.last.name!,
//   //       key: Key("item" + index.toString()),
//   //       style: TextStyle(color: AppColorConstants.paleSky, fontSize: 13),
//   //     ),
//   //   );
//   // }

//   // Widget buildRecentlyPlayedItem(BuildContext context, int index) {
//   //   Color getColor(Set<MaterialState> states) {
//   //     const Set<MaterialState> interactiveStates = <MaterialState>{
//   //       MaterialState.pressed,
//   //       MaterialState.hovered,
//   //       MaterialState.focused,
//   //     };
//   //     if (states.any(interactiveStates.contains)) {
//   //       return AppColorConstants.roseWhite;
//   //     }
//   //     return AppColorConstants.artyClickPurple;
//   //   }

//   //   return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
//   //       Widget>[
//   //     SizedBox(height: 24.h),
//   //     Row(
//   //       children: <Widget>[
//   //         Padding(
//   //             padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
//   //             child: Container(
//   //                 height: 50,
//   //                 width: 50,
//   //                 decoration: BoxDecoration(
//   //                     borderRadius: BorderRadius.circular(8),
//   //                     image: DecorationImage(
//   //                       image:
//   //                           AssetImage(recentlyPlayedItems[index].songImageUrl),
//   //                       fit: BoxFit.fitHeight,
//   //                     )),
//   //                 child: Align(
//   //                     child: Image.asset(
//   //                         '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}')))),
//   //         Column(
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: <Widget>[
//   //             Text(recentlyPlayedItems[index].songTitle,
//   //                 style: TextStyle(
//   //                     color: AppColorConstants.roseWhite,
//   //                     fontWeight: FontWeight.w600,
//   //                     fontSize: 17)),
//   //             SizedBox(height: 8.h),
//   //             Text(recentlyPlayedItems[index].artistName,
//   //                 style:
//   //                     TextStyle(color: AppColorConstants.paleSky, fontSize: 13))
//   //           ],
//   //         ),
//   //         const Spacer(),
//   //         Transform.scale(
//   //             scale: 1.5,
//   //             child: Checkbox(
//   //                 value: recentlyPlayedItems[index].isSelected,
//   //                 onChanged: (bool? value) {
//   //                   setState(() {
//   //                     recentlyPlayedItems[index].isSelected = value!;
//   //                   });
//   //                 },
//   //                 checkColor: AppColorConstants.rubberDuckyYellow,
//   //                 fillColor: MaterialStateProperty.resolveWith(getColor),
//   //                 side: MaterialStateBorderSide.resolveWith(
//   //                   (Set<MaterialState> states) => BorderSide(
//   //                     width: 2,
//   //                     color: AppColorConstants.paleSky,
//   //                   ),
//   //                 ),
//   //                 shape: RoundedRectangleBorder(
//   //                     borderRadius: BorderRadius.circular(5))))
//   //       ],
//   //     )
//   //   ]);
//   // }

//   // Widget buildMusicSource() {
//   //   int index = 0;
//   //   return Padding(
//   //       padding: EdgeInsets.all(0.w),
//   //       child: Row(
//   //         children: [
//   //           Text(AppTextConstants.letsAddMusic,
//   //               style: TextStyle(
//   //                   fontWeight: FontWeight.w600,
//   //                   color: AppColorConstants.roseWhite,
//   //                   fontSize: 22)),
//   //           Padding(
//   //             padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
//   //             child: Image.asset(
//   //               musicPlatforms[index].logoImagePath,
//   //               width: 24,
//   //               height: 24,
//   //             ),
//   //           ),
//   //           Padding(
//   //               padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
//   //               child: Text(
//   //                 musicPlatforms[index].name,
//   //                 textAlign: TextAlign.left,
//   //                 style: TextStyle(
//   //                     color: AppColorConstants.roseWhite,
//   //                     fontSize: 22,
//   //                     fontWeight: FontWeight.w600),
//   //               )),
//   //         ],
//   //       ));
//   // }

//   // Future<void> getMusicPlatforms() async {
//   //   final String musicsString =
//   //       SharedPreferencesRepository.getString('musicSource');
//   //   if (musicsString == '') {
//   //     final List<MusicPlatformModel> musicSourceList =
//   //         AppListConstants().musicSourceList;
//   //     final String value = MusicPlatformModel.encode(musicSourceList);
//   //     SharedPreferencesRepository.putString('musicSource', value);
//   //     setState(() {
//   //       musicPlatforms = musicSourceList;
//   //     });
//   //   } else {
//   //     setState(() {
//   //       musicPlatforms = MusicPlatformModel.decode(musicsString);
//   //       musicPlatforms = musicPlatforms
//   //           .where((MusicPlatformModel musicSource) => musicSource.isSelected)
//   //           .toList();
//   //     });
//   //   }
//   // }

//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties
//       ..add(IterableProperty<MusicPlatformModel>(
//           'musicPlatforms', musicPlatforms))
//       ..add(StringProperty('selectedPlatform', selectedPlatform));
//   }
// }
