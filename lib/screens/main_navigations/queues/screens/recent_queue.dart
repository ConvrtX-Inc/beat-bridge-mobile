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
          SizedBox(
            height: 22.h,
          ),
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
          Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 11.w,
              ),
              child: buildTopPlayedItemList()),
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
              buttonCallback: (){
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
            for (int i = 0; i < friendList.length-1; i++) buildFriendItem(i),
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
            SizedBox(height: 6.h,),
            Text(friendList[index].name,textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 10.sp,fontWeight: FontWeight.w600))
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
