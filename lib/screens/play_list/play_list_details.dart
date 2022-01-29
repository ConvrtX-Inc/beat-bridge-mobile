// ignore_for_file: use_key_in_widget_constructors, sort_constructors_first, diagnostic_describe_all_properties, public_member_api_docs, must_be_immutable, always_specify_types, curly_braces_in_flow_control_structures, unnecessary_lambdas, prefer_const_constructors_in_immutables

import 'dart:convert';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/recent_queue_model.dart';
import 'package:beatbridge/models/spotify/play_list.dart';
import 'package:beatbridge/models/spotify/track.dart';
import 'package:beatbridge/screens/play_music/play_music.dart';

import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/spotify_api_service.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify/spotify.dart' as spot;

///PlayList Screen
class PlayListDetailsScreen extends StatefulWidget {
  ///contructor
  final PlayList playList;

  PlayListDetailsScreen(this.playList);

  @override
  State<PlayListDetailsScreen> createState() => _PlayListDetailsScreenState();
}

class _PlayListDetailsScreenState extends State<PlayListDetailsScreen> {
  final List<RecentQueueModel> queueList = StaticDataService.getRecentQueues();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: buildAllQueuesUI(context),
      ),
    );
  }

  Widget buildAllQueuesUI(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 22.h),
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
                    widget.playList.name!,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColorConstants.roseWhite,
                        fontSize: 22),
                  ),
                  SizedBox(height: 10.h),
                  Text('${widget.playList.tracks!.total} Songs',
                      style: TextStyle(
                          color: AppColorConstants.paleSky, fontSize: 13)),
                ],
              )),
          SizedBox(height: 26.h),
          Expanded(child: buildQueueItemList(context))
        ]);
  }

  Widget buildQueueItemList(BuildContext context) {
    return FutureBuilder<APIStandardReturnFormat>(
      future: APIServices().getTracksInPlayList(widget.playList.id!),
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
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) {
                return PlayMusicScreen(track, playListItems, widget.playList);
              },
              settings: const RouteSettings(
                name: '/play-music',
              ),
            ));
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
