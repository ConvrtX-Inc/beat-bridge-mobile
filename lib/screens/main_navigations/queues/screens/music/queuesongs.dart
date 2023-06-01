import 'dart:convert';

import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/helpers/basehelper.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/users/new_queue_model.dart';
import 'package:beatbridge/models/users/user_track_model.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/queue_details.dart';
import 'package:beatbridge/utils/approutes.dart';
import 'package:beatbridge/utils/helpers/text_helper.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../../../../../constants/app_constants.dart';

class AllQueueSongs extends StatefulWidget {
  final NewQueueModel queue;

  AllQueueSongs(this.queue);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AllQueueSongs();
  }
}

class _AllQueueSongs extends State<AllQueueSongs> {
  var width, height;
  bool hasError = false;
  List<UserTrackModel> userTrackList = <UserTrackModel>[];
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Container(
        width: width,
        height: height,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .06,
            ),
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppColorConstants.roseWhite,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )),
              ],
            ),
            SizedBox(
              height: height * .02,
            ),
            buildTrackUI()
          ],
        ),
      ),
    );
  }

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

  Widget buildTrackUI() => FutureBuilder<List<UserTrackModel>>(
        future: getUserTrack(),
        builder: (BuildContext context,
            AsyncSnapshot<List<UserTrackModel>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                  width: width,
                  height: height * .75,
                  child: const Center(child: CircularProgressIndicator()));
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
  Widget builduserTrackList() => Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 27.w),
          itemCount: userTrackList.length,
          itemBuilder: (BuildContext context, int index) {
            return buildTrackItem(context, index);
          },
        ),
      );
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
                                    // setState(() {
                                    //   isLoading = true;
                                    // });
                                    BaseHelper()
                                        .deleteTrack(
                                            widget.queue.id.toString(),
                                            userTrackList[index].id.toString(),
                                            context)
                                        .then((value) {
                                      AppRoutes.replace(
                                          context, QueueDetails(widget.queue));
                                      // getUserTrack();
                                      // membersCount();
                                      print("deleted tracks: ${value}");

                                      // _showToast(
                                      //     context, "Track Deleted Successfully");
                                    });
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
        // await play(userTrackList[index].trackdata!.track!.uri.toString());
      },
    );
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
  }

  Future<void> play(String uri) async {
    try {
      await SpotifySdk.play(spotifyUri: uri);
      SpotifySdk.seekTo(positionedMilliseconds: 0);
      // await SpotifySdk.play(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }
}
