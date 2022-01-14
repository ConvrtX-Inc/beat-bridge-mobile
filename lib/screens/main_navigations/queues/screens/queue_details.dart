// ignore_for_file: diagnostic_describe_all_properties, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, sort_constructors_first, public_member_api_docs

import 'dart:convert';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/apis/response_to_user.dart';
import 'package:beatbridge/models/people_model.dart';
import 'package:beatbridge/models/recent_queue_model.dart';
import 'package:beatbridge/models/recently_played_model.dart';
import 'package:beatbridge/models/users/queue_member_model.dart';
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

///Queue Details
class QueueDetails extends StatefulWidget {
  ///Constructor
  final QueueModel queue;

  QueueDetails(this.queue);

  @override
  _QueueDetailsState createState() => _QueueDetailsState();
}

class _QueueDetailsState extends State<QueueDetails> {
  final List<RecentQueueModel> recentQueueList =
      StaticDataService.getRecentQueues();

  final List<RecentlyPlayedModel> topPlayedItems =
      StaticDataService.getRecentlyPlayedMockData();

  final List<PeopleModel> friendList =
      StaticDataService.getPeopleListMockData();
  int selectedQueueIndex = 1;

  @override
  void initState() {
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
                    child: SvgPicture.asset(
                        '${AssetsPathConstants.assetsSVGPath}/menu.svg')),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r), // <-- Radius
                  ),
                ),
                onPressed: () {},
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
                        const Text('Join Queue', textAlign: TextAlign.center),
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
                Image.asset(
                  '${AssetsPathConstants.assetsPNGPath}/circular_mic.png',
                  height: 132.h,
                  width: 132.w,
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Created by : ${widget.queue.creator.username}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                        ),
                      ),
                      Text(
                        widget.queue.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800),
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Songs : ',
                                style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    fontSize: 15.sp,
                                    color: Colors.grey)),
                            TextSpan(
                                text: '40',
                                style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    fontSize: 15.sp,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
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
                                text: '08',
                                style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    fontSize: 15.sp,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Times Played : ',
                                style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    fontSize: 15.sp,
                                    color: Colors.grey)),
                            TextSpan(
                                text: '65',
                                style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    fontSize: 15.sp,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 36.h),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 11.w),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(AppTextConstants.mostPlayed,
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
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 11.w,
            ),
            // child: buildTopPlayedItemList(),
            child: FutureBuilder<Iterable<spot.Track>>(
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
                      return buildTopPlayedItemList(recentPlayed.data!);
                      // return Text(recentPlayed.data!.first.track!.name!);
                    }
                  // ignore: no_default_cases
                  default:
                    return const Text('Unhandle State');
                }
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
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(AppTextConstants.allSongs,
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
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 11.w,
            ),
            // child: buildTopPlayedItemList(),
            child: FutureBuilder<Iterable<spot.PlayHistory>>(
              future: SpotifyApiService.getRecentPlayed(),
              builder: (BuildContext context,
                  AsyncSnapshot<Iterable<spot.PlayHistory>> recentPlayed) {
                switch (recentPlayed.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.done:
                    if (recentPlayed.hasError) {
                      return Text(recentPlayed.error.toString());
                    } else {
                      return buildRecentPlayedItemList(recentPlayed.data!);
                      // return Text(recentPlayed.data!.first.track!.name!);
                    }
                  // ignore: no_default_cases
                  default:
                    return const Text('Unhandle State');
                }
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
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(AppTextConstants.members,
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
          SizedBox(height: 20.h),
          buildFriendList()
        ]);
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

  Widget buildRecentPlayedItem(spot.PlayHistory item, int index) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      key: Key(item.track!.id.toString()),
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
    return FutureBuilder<APIStandardReturnFormat>(
      future: APIServices().getQueueMember(widget.queue.id), // async work
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
              final dynamic jsonData =
                  jsonDecode(snapshot.data!.successResponse);
              final List<QueueMemberModel> members = <QueueMemberModel>[];
              final qMembers = (jsonData as List)
                  .map((i) => QueueMemberModel.fromJson(i))
                  .toList();
              members.addAll(qMembers);
              // return Container();
              return Container(
                height: 120.h,
                child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for (int i = 0; i < qMembers.length; i++)
                        buildFriendItem(qMembers[i], i),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Column(
                          children: <Widget>[
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
                                '${qMembers.length}+',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w800),
                              )),
                            ),
                          ],
                        ),
                      )
                    ]),
              );
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
}
