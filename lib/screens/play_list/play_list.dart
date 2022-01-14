// ignore_for_file: use_key_in_widget_constructors, sort_constructors_first, diagnostic_describe_all_properties, public_member_api_docs, must_be_immutable, always_specify_types, curly_braces_in_flow_control_structures, unnecessary_lambdas

import 'dart:convert';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/controller/all_queues_controller.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/recent_queue_model.dart';
import 'package:beatbridge/models/spotify/play_list.dart';
import 'package:beatbridge/models/users/queue_model.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

///PlayList Screen
class PlayListScreen extends StatefulWidget {
  ///contructor
  const PlayListScreen({Key? key}) : super(key: key);

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
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
          SizedBox(height: 41.h),
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
        ]);
  }

  Widget buildQueueItemList(BuildContext context) {
    return FutureBuilder<APIStandardReturnFormat>(
      future: APIServices().getUserPlayList(),
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
              final List<PlayList> playList = <PlayList>[];
              final pl = (jsonData['items'] as List)
                  .map((i) => PlayList.fromJson(i))
                  .toList();
              playList.addAll(pl);

              return ListView.builder(
                itemCount: playList.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildQueueItem(context, playList[index], index);
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
