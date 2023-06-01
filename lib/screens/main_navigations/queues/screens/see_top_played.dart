import 'package:beatbridge/models/songsmodel.dart';
import 'package:beatbridge/utils/services/spotify_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify/spotify.dart' as spot;
import 'package:spotify_sdk/spotify_sdk.dart';

import '../../../../constants/app_constants.dart';
import '../../../../constants/asset_path.dart';
import '../../../../models/recently_played_model.dart';

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
import 'package:logger/logger.dart';
// import 'package:music_kit/music_kit.dart';
import 'package:playify/playify.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:spotify/spotify.dart' as spot;
import 'package:spotify_sdk/models/crossfade_state.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart' as sindu_player_state;
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:volume_controller/volume_controller.dart';

import '../../../../widgets/buttons/white_button.dart';

class SeeAllTopPlayed extends StatefulWidget {
  final ValueNotifier<List<SongsData>> songsData;
  SeeAllTopPlayed(this.songsData);

  @override
  State<SeeAllTopPlayed> createState() => _SeeAllTopPlayedState();
}

class _SeeAllTopPlayedState extends State<SeeAllTopPlayed> {
  var songURL;
  var songName;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SpotifyApiService.getTopTracks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * .03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 12,
              ),
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
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  'All Top Played Songs',
                  style: TextStyle(
                      color: AppColorConstants.roseWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      fontFamily: 'Gilroy'),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) {
                  return newSongsWidget(widget.songsData.value[index], index);
                },
                itemCount: widget.songsData.value.length,
              )
                  // FutureBuilder<Iterable<spot.Track>>(
                  //   future: SpotifyApiService.getTopTracks(),
                  //   builder: (BuildContext context,
                  //       AsyncSnapshot<Iterable<spot.Track>> recentPlayed) {
                  //     if (recentPlayed.hasData) {
                  //       return ListView.separated(
                  //           separatorBuilder: (context, index) => SizedBox(
                  //                 height: 10,
                  //               ),
                  //           itemCount: 10,
                  //           itemBuilder: (context, index) {
                  //             return Padding(
                  //                 padding: EdgeInsets.symmetric(
                  //                   horizontal: 11.w,
                  //                 ),
                  //                 child:
                  //                     buildTopPlayedItemList(recentPlayed.data!));
                  //           });
                  //     }
                  //     return const Center(child: CircularProgressIndicator());
                  //   },
                  // ),

                  ),
            ],
          )),
    );
  }
  final List<RecentlyPlayedModel> topPlayedItems =
  StaticDataService.getRecentlyPlayedMockData();

  Widget newSongsWidget(SongsData songsResult, int index) {
    return ListTile(
      onTap: () async {
        songName = songsResult.name.toString();
        songURL = songsResult.uri.toString();
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

  Widget buildTopPlayedItemList(Iterable<spot.Track> rPlayed) {
    print('object ${rPlayed.length}');
    return Column(
      // FIRST SPRINT DISABLED ITEM BELOW

      children: List.generate(rPlayed.length,
          (int index) => buildTopPlayedItem(rPlayed.elementAt(index), index)),

      // FIRST SPRINT DISABLED ITEM up
    );
  }

  Widget buildTopPlayedItem(spot.Track item, int index) {
    return ListTile(
      onTap: () async {
        songName = item.name.toString();
        songURL = item.uri.toString();
        await play(songURL).then((value) {
          print("song played: ");
        }).catchError((onError) {
          print("i got werror while playing: $onError");
        });
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
                              snapshot?.data?.images?.first?.url.toString() ??
                                  "Empty"),
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
        item.name ?? "null",
        key: Key(index.toString() + item.id.toString()),
        style: TextStyle(
            color: AppColorConstants.roseWhite,
            fontWeight: FontWeight.w600,
            fontSize: 17),
      ),
      subtitle: Text(
        item.artists?.last.name ?? "empty",
        key: Key("item" + index.toString()),
        style: TextStyle(color: AppColorConstants.paleSky, fontSize: 13),
      ),
    );
  }

  Future<void> play(String uri) async {
    try {
      await SpotifySdk.play(spotifyUri: uri);
      SpotifySdk.seekTo(positionedMilliseconds: 0);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
  }
}
