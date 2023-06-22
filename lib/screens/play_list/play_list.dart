// ignore_for_file: use_key_in_widget_constructors, sort_constructors_first, diagnostic_describe_all_properties, public_member_api_docs, must_be_immutable, always_specify_types, curly_braces_in_flow_control_structures, unnecessary_lambdas

import 'dart:convert';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/controller/all_queues_controller.dart';
import 'package:beatbridge/helpers/basehelper.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/recent_queue_model.dart';
import 'package:beatbridge/models/songsmodel.dart';
import 'package:beatbridge/models/spotify/play_list.dart';
import 'package:beatbridge/models/users/new_queue_model.dart';
import 'package:beatbridge/models/users/queue_model.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/screens/play_list/play_list_details.dart';
import 'package:beatbridge/utils/approutes.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

///PlayList Screen
class PlayListScreen extends StatefulWidget {
  ///contructor
  const PlayListScreen({Key? key}) : super(key: key);

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  final List<RecentQueueModel> queueList = StaticDataService.getRecentQueues();
  ValueNotifier<List<SongsData>> songsData = ValueNotifier<List<SongsData>>([]);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUserSongs();
    getQueue();
  }

  ValueNotifier<List<NewQueueModel>> queueData =
      ValueNotifier<List<NewQueueModel>>([]);
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

  getUserSongs() {
    // print("other user id: ${widget.memberData.user.id}");
    BaseHelper().getUserSongs(context: context, isUser: true).then((value) {
      setState(() {
        songsData.value = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: buildAllQueuesUI(context),
        ),
      ),
    );
  }

  Widget buildAllQueuesUI(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 28.h),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.w),
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColorConstants.roseWhite,
            ),
          ),
        ),
        SizedBox(height: 36.h),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.w),
            child: Text(
              AppTextConstants.playList,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColorConstants.roseWhite,
                  fontSize: 22),
            )),
        SizedBox(height: 26.h),
        Expanded(child: buildQueueItemList(context))
        // ValueListenableBuilder<List<SongsData>>(
        //     valueListenable: songsData,
        //     builder: (BuildContext context, value, Widget? child) {
        //       // ignore: unnecessary_null_comparison
        //       // print("hedsadsallo: $value");
        //       if (value.isEmpty) {
        //         return SizedBox(
        //           // height: MediaQuery.of(context).size.height * .06,
        //           width: MediaQuery.of(context).size.width * .9,
        //           // child: Center(
        //           //   child: CircularProgressIndicator(),
        //           // ),
        //         );
        //       } else {
        //         return Expanded(child: buildQueueItemList(context));
        //         // Container(
        //         //   width: MediaQuery.of(context).size.width * .9,
        //         //   height: MediaQuery.of(context).size.height * .25,
        //         //   child:
        //         //   ),
        //         // ListView.builder(
        //         //   itemBuilder: (context, index) {
        //         //     return newSongsWidget(value[index], index);
        //         //   },
        //         //   itemCount: value.length >= 3 ? 3 : value.length,
        //         // )
        //         // );
        //       }
        //     })
      ],
    );
  }

  // Widget buildQueueItemList(BuildContext context) {
  //   return ValueListenableBuilder<List<SongsData>>(
  //       valueListenable: songsData,
  //       builder: (BuildContext context, value, Widget? child) {
  //         // ignore: unnecessary_null_comparison
  //         // print("hedsadsallo: $value");
  //         if (value.isEmpty) {
  //           return SliverToBoxAdapter(
  //             child: SizedBox(
  //               // height: MediaQuery.of(context).size.height * .06,
  //               width: MediaQuery.of(context).size.width * .9,
  //               child: Center(
  //                 child: CircularProgressIndicator(
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),
  //           );
  //         } else {
  //           return SliverList(
  //               delegate: SliverChildBuilderDelegate((context, int index) {
  //             return newSongsWidget(value[index], index);
  //           }, childCount: value.length));
  //           // Container(
  //           //   width: MediaQuery.of(context).size.width * .9,
  //           //   height: MediaQuery.of(context).size.height * .25,
  //           //   child:
  //           //   ),
  //           // ListView.builder(
  //           //   itemBuilder: (context, index) {
  //           //     return newSongsWidget(value[index], index);
  //           //   },
  //           //   itemCount: value.length >= 3 ? 3 : value.length,
  //           // )
  //           // );
  //         }
  //       });
  //   // FutureBuilder<APIStandardReturnFormat>(
  //   //   future: APIServices().getUserPlayList(),
  //   //   builder: (BuildContext context,
  //   //       AsyncSnapshot<APIStandardReturnFormat> response) {
  //   //     switch (response.connectionState) {
  //   //       case ConnectionState.waiting:
  //   //         return const Center(
  //   //           child: CircularProgressIndicator(),
  //   //         );
  //   //       case ConnectionState.done:
  //   //         if (response.hasError) {
  //   //           return Text(response.error.toString());
  //   //         } else {
  //   //           final dynamic jsonData =
  //   //               jsonDecode(response.data!.successResponse);
  //   //           final List<PlayList> playList = <PlayList>[];
  //   //           final pl = (jsonData['items'] as List)
  //   //               .map((i) => PlayList.fromJson(i))
  //   //               .toList();
  //   //           playList.addAll(pl);

  //   //           return ListView.builder(
  //   //             itemCount: playList.length,
  //   //             itemBuilder: (BuildContext context, int index) {
  //   //               return buildQueueItem(context, playList[index], index);
  //   //             },
  //   //           );
  //   //         }
  //   //       // ignore: no_default_cases
  //   //       default:
  //   //         return const Text('Unhandle State');
  //   //     }
  //   //   },
  //   // );
  // }

  Future<void> play(String uri) async {
    try {
      await SpotifySdk.play(spotifyUri: uri);
      SpotifySdk.seekTo(positionedMilliseconds: 0);
      // await SpotifySdk.play(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      // setStatus(e.code, message: e.message);
    } on MissingPluginException {
      // setStatus('not implemented');
    }
  }

  Widget buildQueueItemList(BuildContext context) {
    return FutureBuilder<APIStandardReturnFormat>(
      future: APIServices().getUserQueues(userIdd: "0"), // async work
      builder: (BuildContext context,
          AsyncSnapshot<APIStandardReturnFormat> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 50,
                width: 50,
                child: Center(child: CircularProgressIndicator()),
              ),
            );

          // ignore: no_default_cases
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else if (snapshot.data!.status == 'error') {
              return Text('Error: ${snapshot.error}');
            } else {
              // final QueueModel userQueues = QueueModel.fromJson(
              //     json.decode(snapshot.data!.successResponse));
              final dynamic jsonData =
                  jsonDecode(snapshot.data!.successResponse);
              final List<NewQueueModel> userQueues = <NewQueueModel>[];
              final qs = (jsonData as List)
                  .map((i) => NewQueueModel.fromJson(i))
                  .toList();
              // for (int i = 0; i < qs.length; i++) {
              //   for (int j = i + 1; j < qs.length; j++) {
              //     if (qs[j].queueData == null) {
              //     } else {
              //       if (qs[i].queueData!.id.toString() ==
              //           qs[j].queueData!.id.toString()) {
              //         qs.removeAt(j);
              //       }
              //       else{

              //       }
              //     }
              //   }
              // }
              userQueues.addAll(qs);
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 11.w),
                itemCount: userQueues.length,
                itemBuilder: (BuildContext context, int index) {
                  print('userQueues : ${userQueues.length}' '''''');

                  // return buildQueueItem(context, userQueues[index], index);
                  return InkWell(
                    onTap: () {
                      UserSingleton.instance.queueIndex = index;
                      AppRoutes.push(
                          context, PlayListDetailsScreen(userQueues[index]));
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) =>
                      //         QueueDetails(userQueues[index])));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 24.h),
                        Row(
                          children: <Widget>[
                            if (userQueues[index].platform == null)
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: NetworkImage(userQueues[index]
                                                      .platform ==
                                                  null
                                              ? "${BaseHelper().baseUrl}${userQueues[index].image}"
                                              : userQueues[index]
                                                      .queueData
                                                      ?.images?[index]
                                                      .url ??
                                                  'null'),
                                          fit: BoxFit.fitHeight,
                                        )),
                                  ))
                            else
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: NetworkImage(userQueues[index]
                                                  .queueData
                                                  ?.images?[0]
                                                  .url ??
                                              'null'),
                                          fit: BoxFit.fitHeight,
                                        )),
                                  )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                if (userQueues[index].platform == null)
                                  Text('${userQueues[index].name}',
                                      style: TextStyle(
                                          color: AppColorConstants.roseWhite,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.sp))
                                else
                                  Text('${userQueues[index].queueData?.name}',
                                      style: TextStyle(
                                          color: AppColorConstants.roseWhite,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.sp)),
                                SizedBox(height: 8.h),
                                if (userQueues[index].queueData?.name != null)
                                  Text('${userQueues[index].queueData?.name}',
                                      style: TextStyle(
                                          color: AppColorConstants.paleSky,
                                          fontSize: 13))
                                else
                                  Text('',
                                      style: TextStyle(
                                          color: AppColorConstants.paleSky,
                                          fontSize: 13)),
                                SizedBox(height: 8.h),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            if (userQueues[index].platform == null)
                              Text(
                                'Created by: ${userQueues[index].createdBy}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.sp),
                              )
                            else
                              Text(
                                'Created by: ${userQueues[index].queueData?.owner?.displayName}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.sp),
                              ),
                            Flexible(
                              child: Text(
                                '${userQueues[index].createdDate?.substring(0, 10)}',
                                style: TextStyle(
                                    color: AppColorConstants.paleSky,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    fontSize: 14.sp),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(),
                        SizedBox(height: 16.h),
                        Divider(
                          color: AppColorConstants.paleSky,
                        ),
                      ],
                    ),
                  );
                },
              );
            }
        }
      },
    );
  }

  Widget newSongsWidget(SongsData songsResult, int index) {
    // print(
    //     "image url: ${songsResult.tracksData!.tracks!.album!.images![0].url}");
    return ListTile(
      onTap: () async {
        BaseHelper()
            .songsPLayed(context: context, uriId: songsResult.uri.toString())
            .then((value) {
          print("song played with uri");
        });
        var songName = songsResult.name.toString();
        var songURL = songsResult.uri.toString();
        await play(songURL);
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
    );
  }

  Widget buildQueueItem(BuildContext context, PlayList playlist, int index) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 14.h),
        ListTile(
          onTap: () {
            Navigator.of(context)
                .pushNamed('/play-list-details', arguments: playlist);
          },
          leading: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                  image: NetworkImage(playlist.images!.first.url.toString()),
                  fit: BoxFit.cover),
            ),
          ),
          title: Text(
            playlist.name!,
            style: TextStyle(
                color: AppColorConstants.roseWhite,
                fontWeight: FontWeight.w600,
                fontSize: 18.sp),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${playlist.tracks!.total} Songs',
                  style: TextStyle(
                      color: AppColorConstants.paleSky, fontSize: 13)),
              SizedBox(height: 8.h),
              buildMusicPlatformsUsedRow(context, index)
            ],
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: AppColorConstants.paleSky,
            size: 18.h,
          ),
        ),
        SizedBox(height: 14.h),
        Divider(
          color: AppColorConstants.paleSky,
        ),
      ],
    );

    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: <Widget>[
    //     SizedBox(height: 24.h),
    //     Row(
    //       children: <Widget>[
    //         Padding(
    //             padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
    //             child: Container(
    //                 height: 60,
    //                 width: 60,
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(8),
    //                   image: DecorationImage(
    //                       image: NetworkImage(
    //                           playlist.images!.first.url.toString()),
    //                       fit: BoxFit.cover),
    //                 ),
    //                 child: Align(
    //                     child: Image.asset(
    //                         '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}')))),
    //         Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: <Widget>[
    //             Text(playlist.name!,
    //                 style: TextStyle(
    //                     color: AppColorConstants.roseWhite,
    //                     fontWeight: FontWeight.w600,
    //                     fontSize: 18.sp)),
    //             SizedBox(height: 8.h),
    //             Text('${playlist.tracks!.total} Songs',
    //                 style: TextStyle(
    //                     color: AppColorConstants.paleSky, fontSize: 13)),
    //             SizedBox(height: 8.h),
    //             buildMusicPlatformsUsedRow(context, index)
    //           ],
    //         ),
    //         const Spacer(),
    //         Transform.scale(
    //             scale: 1.5,
    //             child: Icon(
    //               Icons.chevron_right,
    //               color: AppColorConstants.paleSky,
    //               size: 18.h,
    //             ),)
    //       ],
    //     ),
    //     SizedBox(height: 14.h),
    //     SizedBox(height: 16.h),
    //     Divider(
    //       color: AppColorConstants.paleSky,
    //     )
    //   ],
    // );
  }

  Widget buildMusicPlatformsUsedRow(BuildContext context, int index) {
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Image.asset(
              '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.spotifyLogoImage}',
              height: 18.h,
              width: 18.w,
            ),
          ),
        ],
      )
    ]);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<RecentQueueModel>('queueList', queueList));
  }
}
