import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/models/people_model.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_outlined_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///Near you Screen
class NearYouScreen extends StatefulWidget {
  ///Constructor
  const NearYouScreen({Key? key}) : super(key: key);

  @override
  _NearYouScreenState createState() => _NearYouScreenState();
}

class _NearYouScreenState extends State<NearYouScreen> {
  final List<PeopleModel> peopleList =
  StaticDataService.getPeopleListMockData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorConstants.mirage,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 27.w),
          child: buildFriendsNearYouUI(),
        ));
  }

  Widget buildFriendsNearYouUI() {
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

            Text(
              AppTextConstants.nearYou,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColorConstants.roseWhite,
                  fontSize: 30.sp),
            ),
          SizedBox(height: 16.h),
          Text(
            '123 ${AppTextConstants.people}',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColorConstants.roseWhite,
                letterSpacing: 2,
                fontSize: 13.sp),
          ),
          Expanded(child: buildFriendNearYouList())
        ]);
  }

  Widget buildFriendNearYouList() {
    return ListView.builder(
      itemCount: peopleList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildFriendNearYouItem(index);
      },
    );
  }

  Widget buildFriendNearYouItem(int index) =>
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
            const Spacer(),
            SizedBox(
              width: 105.w,
              child: AppOutlinedButton(btnText: AppTextConstants.addFriend,btnCallback: (){
                debugPrint('Add Friend');
              })
            )
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
