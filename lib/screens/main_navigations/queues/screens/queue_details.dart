import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/people_model.dart';
import 'package:beatbridge/models/recent_queue_model.dart';
import 'package:beatbridge/models/recently_played_model.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

///Queue Details
class QueueDetails extends StatefulWidget {
  ///Constructor
  const QueueDetails({Key? key}) : super(key: key);

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Created by : Eric',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                      ),
                    ),
                    Text(
                      'Karaoke at Eric’s',
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
              child: buildTopPlayedItemList()),
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
              child: buildTopPlayedItemList()),
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

  Widget buildTopPlayedItemList() {
    return Column(
        children: topPlayedItems.map((RecentlyPlayedModel item) {
      final int index = topPlayedItems.indexOf(item);
      return buildTopPlayedItem(index);
    }).toList());
  }

  Widget buildTopPlayedItem(int index) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 24.h),
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
                            image:
                                AssetImage(topPlayedItems[index].songImageUrl),
                            fit: BoxFit.fitHeight,
                          )),
                      child: Align(
                          child: Image.asset(
                              '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}')))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(topPlayedItems[index].songTitle,
                      style: TextStyle(
                          color: AppColorConstants.roseWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 17)),
                  SizedBox(height: 8.h),
                  Text(topPlayedItems[index].artistName,
                      style: TextStyle(
                          color: AppColorConstants.paleSky, fontSize: 13))
                ],
              ),
            ],
          )
        ]);
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
