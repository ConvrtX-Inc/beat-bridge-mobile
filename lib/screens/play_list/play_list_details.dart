// ignore_for_file: use_key_in_widget_constructors, sort_constructors_first, diagnostic_describe_all_properties, public_member_api_docs, must_be_immutable, always_specify_types, curly_braces_in_flow_control_structures, unnecessary_lambdas, prefer_const_constructors_in_immutables

import 'dart:convert';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/helpers/basehelper.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/recent_queue_model.dart';
import 'package:beatbridge/models/songsmodel.dart';
import 'package:beatbridge/models/spotify/play_list.dart';
import 'package:beatbridge/models/spotify/track.dart';
import 'package:beatbridge/models/users/new_queue_model.dart';
import 'package:beatbridge/screens/play_music/play_music.dart';

import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/spotify_api_service.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify/spotify.dart' as spot;
import 'package:spotify_sdk/spotify_sdk.dart';

///PlayList Screen
class PlayListDetailsScreen extends StatefulWidget {
  ///contructor
  // final PlayList playList;
  final NewQueueModel queue;

  PlayListDetailsScreen(this.queue);

  // PlayListDetailsScreen(this.playList);

  @override
  State<PlayListDetailsScreen> createState() => _PlayListDetailsScreenState();
}

class _PlayListDetailsScreenState extends State<PlayListDetailsScreen> {
  final List<RecentQueueModel> queueList = StaticDataService.getRecentQueues();
  ValueNotifier<List<SongsData>> songsData = ValueNotifier<List<SongsData>>([]);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserSongs();
  }

  getUserSongs() {
    print("other user id: ${widget.queue.id}");
    BaseHelper()
        .getUserSongs(context: context, queueId: widget.queue.id, isUser: false)
        .then((value) {
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

  Widget buildAllQueuesUI(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
            child: Column(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.queue.name!,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColorConstants.roseWhite,
                            fontSize: 22),
                      ),
                      SizedBox(height: 10.h),
                      // Text('${widget.queue..tracks!.total} Songs',
                      //     style: TextStyle(
                      //         color: AppColorConstants.paleSky, fontSize: 13)),
                    ],
                  )),
              SizedBox(height: 26.h),
              // Expanded(child: buildQueueItemList(context))
            ])),
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
                        child: Text(
                      "Loading songs.......",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                );
              } else {
                return SliverList(
                    delegate: SliverChildBuilderDelegate((context, int index) {
                  return newSongsWidget(value[index], index);
                }, childCount: value.length));
                // Container(
                //   width: MediaQuery.of(context).size.width * .9,
                //   height: MediaQuery.of(context).size.height * .25,
                //   child:
                //   ),
                // ListView.builder(
                //   itemBuilder: (context, index) {
                //     return newSongsWidget(value[index], index);
                //   },
                //   itemCount: value.length >= 3 ? 3 : value.length,
                // )
                // );
              }
            }),
      ],
    );
    ;
  }

  Widget buildQueueItemList(BuildContext context) {
    return FutureBuilder<APIStandardReturnFormat>(
      future: APIServices().getTracksInPlayList(widget.queue.id!),
      builder: (BuildContext context,
          AsyncSnapshot<APIStandardReturnFormat> response) {
        switch (response.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            if (response.hasError) {
              return Text(response.error.toString());
            } else {
              final dynamic jsonData =
                  jsonDecode(response.data!.successResponse);
              final List<PlayListTrack> playList = <PlayListTrack>[];
              final pl = (jsonData['items'] as List)
                  .map((i) => PlayListTrack.fromJson(i))
                  .toList();
              playList.addAll(pl);

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 11.w),
                itemCount: playList.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildQueueItem(
                      context, playList[index], playList, index);
                },
              );
            }
          // ignore: no_default_cases
          default:
            return const Text('Unhandle State');
        }
      },
    );
  }

  Widget buildQueueItem(BuildContext context, PlayListTrack track,
      List<PlayListTrack> playListItems, int index) {
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
      children: <Widget>[
        SizedBox(height: 24.h),
        ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () {
            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (_) {
            //     return PlayMusicScreen(track, playListItems, widget.playList);
            //   },
            //   settings: const RouteSettings(
            //     name: '/play-music',
            //   ),
            // ));
          },
          leading: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                  image: NetworkImage(
                      track.track!.album!.images!.first.url.toString()),
                  fit: BoxFit.cover),
            ),
            child: Align(
              child: Image.asset(
                  '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}'),
            ),
          ),
          title: Text(
            track.track!.name!,
            style: TextStyle(
                color: AppColorConstants.roseWhite,
                fontWeight: FontWeight.w600,
                fontSize: 18.sp),
          ),
          subtitle: Text(
            track.track!.artists!.first.name!,
            style: TextStyle(color: AppColorConstants.paleSky, fontSize: 13),
          ),
        ),
        SizedBox(height: 24.h),
        Divider(
          color: AppColorConstants.paleSky,
        )
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<RecentQueueModel>('queueList', queueList));
  }
}
