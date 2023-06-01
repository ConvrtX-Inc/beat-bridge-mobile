import 'dart:convert';
import 'dart:developer';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/app_list.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/music_platform_model.dart';
import 'package:beatbridge/models/people_model.dart';
import 'package:beatbridge/models/recently_played_model.dart';
import 'package:beatbridge/models/users/user_track_model.dart';
import 'package:beatbridge/screens/main_navigations/make_queues/screens/make_queue_screen.dart';
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
import 'package:spotify/spotify.dart' as spot;

///Step Two
class StepTwo extends StatefulWidget {
  ///Constructor
  const StepTwo({required this.onStepTwoDone, Key? key}) : super(key: key);

  ///Callback
  final void Function() onStepTwoDone;

  @override
  _StepTwoState createState() => _StepTwoState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<void Function()>.has(
        'onStepTwoDone', onStepTwoDone));
  }
}

class _StepTwoState extends State<StepTwo> {
  bool hasError = false;
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
    return WillPopScope(
      onWillPop: () async => await showSnack(),
      child: Scaffold(
          backgroundColor: AppColorConstants.mirage,
          body: userTrackList.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: SingleChildScrollView(
                              child: Column(
                            children: <Widget>[
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 11.w),
                                  child: Row(
                                    children: [
                                      Text(AppTextConstants.letsAddMusic,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  AppColorConstants.roseWhite,
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
                                              color:
                                                  AppColorConstants.roseWhite,
                                              fontSize: 22)),
                                    ],
                                  )),
                            ],
                          ))),
                      Expanded(child: buildTrackUI()),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 27.w, vertical: 16.h),
                            child: ButtonRoundedGradient(
                              buttonText: AppTextConstants.continueTxt,
                              isLoading: _isAPICallInProgress,
                              buttonCallback: () {
                                if (userChecked.length > 0) {
                                  widget.onStepTwoDone();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      // ignore: prefer_const_constructors
                                      SnackBar(
                                          content: Text(
                                              'Please select atleast 1 track'),
                                          backgroundColor: Colors.red,
                                          duration:
                                              const Duration(seconds: 1)));
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ])),
    );
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
                              "https://beat.softwarealliancetest.tk${friendList[index].profileImageUrl}"),
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
                      final String? tempQueueID =
                          await storage.read(key: 'tempQueueID');
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

                      print('object queueId : ${userTrackList[index].queueId}');
                      print('object userId: ${userTrackList[index].userId}');

                      _onSelected(value!, userTrackList[index].id ?? '0');

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Songs Added in Queue'),
                          duration: Duration(seconds: 2)));

                      final APIStandardReturnFormat result =
                          await APIServices().userTrackData(userTracModel);
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
