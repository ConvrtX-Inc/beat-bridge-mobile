import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/models/people_model.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///Friend Screen
class FriendScreen extends StatefulWidget {
  ///Constructor
  const FriendScreen({Key? key}) : super(key: key);

  @override
  _FriendScreenState createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  final List<PeopleModel> peopleList =
      StaticDataService.getPeopleListMockData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorConstants.mirage,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 27.w),
          child: buildFriendsUI(),
        ));
  }

  Widget buildFriendsUI() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 41.h),
          IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColorConstants.roseWhite,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          SizedBox(height: 26.h),
          Row(children: <Widget>[
            Text(
              AppTextConstants.friends,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColorConstants.roseWhite,
                  fontSize: 30.sp),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/near_you');
              },
              child: Text(
                AppTextConstants.findFriends,
                style: TextStyle(color: AppColorConstants.artyClickPurple),
              ),
            ),
          ]),
          Text(
            '54 ${AppTextConstants.friends}',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColorConstants.roseWhite,
                letterSpacing: 2,
                fontSize: 13.sp),
          ),
          Expanded(child: buildFriendList())
        ]);
  }

  Widget buildFriendList() {
    return ListView.builder(
      itemCount: peopleList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildFriendItem(index);
      },
    );
  }

  Widget buildFriendItem(int index) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        SizedBox(height: 22.h),
        Row(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage(peopleList[index].profileImageUrl),
                        fit: BoxFit.fitHeight,
                      )),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(peopleList[index].name,
                    style: TextStyle(
                        color: AppColorConstants.roseWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                SizedBox(height: 6.h),
                Text('${peopleList[index].totalTrackCount} Tracks',
                    style: TextStyle(
                        color: AppColorConstants.paleSky, fontSize: 13)),
                buildMusicPlatformsUsedRow(context, index)
              ],
            ),
          ],
        ),
      ]);

  Widget buildMusicPlatformsUsedRow(BuildContext context, int index) {
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          for (int i = 0; i < peopleList[index].musicPlatformsUsed.length; i++)
            Padding(padding: EdgeInsets.symmetric(horizontal: 2.w), child:Image(
                image: AssetImage(
                    peopleList[index].musicPlatformsUsed[i].logoImageUrl),
                height: 20,
                width: 20)),

        ],
      )
    ]);
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<PeopleModel>('peopleList', peopleList));
  }
}
