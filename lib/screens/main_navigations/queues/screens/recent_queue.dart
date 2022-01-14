// ignore_for_file: curly_braces_in_flow_control_structures, always_specify_types, unnecessary_lambdas

import 'dart:convert';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/people_model.dart';
import 'package:beatbridge/models/recent_queue_model.dart';
import 'package:beatbridge/models/recently_played_model.dart';
import 'package:beatbridge/models/spotify/play_list.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/models/users/queue_model.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/spotify_api_service.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/spotify.dart' as spot;
// import 'package:spotify/spotify.dart';

///Recent Queues
class RecentQueues extends StatefulWidget {
  ///Constructor
  const RecentQueues({Key? key}) : super(key: key);

  @override
  _RecentQueuesState createState() => _RecentQueuesState();
}

class _RecentQueuesState extends State<RecentQueues> {
  final List<RecentQueueModel> recentQueueList =
      StaticDataService.getRecentQueues();

  final List<RecentlyPlayedModel> topPlayedItems =
      StaticDataService.getRecentlyPlayedMockData();

  final List<PeopleModel> friendList =
      StaticDataService.getPeopleListMockData();
  int selectedQueueIndex = 1;
  List<String> errorMessages = <String>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    debugPrint('friends ${friendList.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(child: buildRecentQueuesUI()),
      ),
    );
  }

  Widget buildRecentQueuesUI() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 41.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: InkWell(
                onTap: () {
                  debugPrint('should open profile...');
                  Navigator.of(context).pushNamed('/profile-settings');
                },
                child: SvgPicture.asset(
                    '${AssetsPathConstants.assetsSVGPath}/menu.svg')),
          ),
          SizedBox(height: 36.h),
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
          SizedBox(
            height: 12.h,
          ),
          buildRecentQueuesList(),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 11.w),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(AppTextConstants.topPlayed,
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
                  ])),
          FutureBuilder<String>(
            future: SpotifyApiService.getAuthenticationToken(), // async work
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  print('spotify token ${snapshot.data}');

                  return FutureBuilder<Iterable<spot.Track>>(
                    future: SpotifyApiService.getTopTracks(),
                    builder: (BuildContext context,
                        AsyncSnapshot<Iterable<spot.Track>> recentPlayed) {
                      switch (recentPlayed.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        case ConnectionState.done:
                          if (recentPlayed.hasError) {
                            return Text(recentPlayed.error.toString());
                          } else {
                            return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 11.w,
                                ),
                                child:
                                    buildTopPlayedItemList(recentPlayed.data!));
                          }
                        // ignore: no_default_cases
                        default:
                          return const Text('Unhandle State');
                      }
                    },
                  );
                // ignore: no_default_cases
                default:
                  return snapshot.hasError
                      ? Center(child: Text('Error: ${snapshot.error}'))
                      : Container();
              }
            },
          ),
          SizedBox(height: 28.h),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 11.w,
            ),
            child: ButtonRoundedGradient(
              buttonText: AppTextConstants.startNewQueue,
              buttonCallback: () {
                Navigator.of(context).pushNamed('/make_your_queue_screen');
              },
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 11.w,
            ),
            child: ButtonAppRoundedButton(
              buttonText: AppTextConstants.joinNearbyQueue,
              buttonCallback: () {
                Navigator.of(context).pushNamed('/all_queues');
              },
            ),
          ),
          SizedBox(height: 20.h),
          Divider(
            color: AppColorConstants.paleSky,
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.w),
            child: Text(AppTextConstants.followYourFriends,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColorConstants.roseWhite,
                    fontSize: 22)),
          ),
          SizedBox(height: 20.h),
          buildFriendList()
        ]);
  }

  Widget buildRecentQueuesList() {
    return FutureBuilder<APIStandardReturnFormat>(
      future: APIServices().getUserQueues(), // async work
      builder: (BuildContext context,
          AsyncSnapshot<APIStandardReturnFormat> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const SizedBox(
              height: 50,
              width: 50,
              child: Center(child: CircularProgressIndicator()),
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
              final List<QueueModel> userQueues = <QueueModel>[];
              final qs = (jsonData as List)
                  .map((i) => QueueModel.fromJson(i))
                  .toList();
              userQueues.addAll(qs);
              return SizedBox(
                height: 120.h,
                child: ListView.builder(
                  itemCount: userQueues.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return buildRecentQueueItem(userQueues[index], index);
                  },
                ),
              );
            }
        }
      },
    );
  }

  Widget buildRecentQueueItem(QueueModel queue, int index) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
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
                  child: Image.asset(recentQueueList[index].thumbnailUrl,
                      height: 70.h),
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
              queue.name,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 10.sp),
            ))
      ],
    );
  }

  Widget buildTopPlayedItemList(Iterable<spot.Track> rPlayed) {
    final Iterable<spot.Track> firstFour = rPlayed.take(4);
    //*scrollable top played items*//
    // return ListView.builder(
    //   shrinkWrap: true,
    //   key: const Key('topList'),
    //   itemCount: firstFour.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     // return Text(rPlayed.elementAt(index).id.toString());
    //     return buildTopPlayedItem(firstFour.elementAt(index), index);
    //   },
    // );
    return Column(
      children: List.generate(firstFour.length,
          (int index) => buildTopPlayedItem(firstFour.elementAt(index), index)),
    );
  }

  Widget buildTopPlayedItem(spot.Track item, int index) {
    return ListTile(
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
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
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
                child: Column(children: <Widget>[
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: const Alignment(-0.5, 0),
                        colors: <Color>[
                          AppColorConstants.artyClickPurple,
                          AppColorConstants.lemon
                        ],
                      ),
                    ),
                    child: Center(
                        child: Text(
                      '8+',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800),
                    )),
                  ),
                ]))
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
}
