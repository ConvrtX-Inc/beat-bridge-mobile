import 'dart:convert';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/friends/friend_model.dart';
import 'package:beatbridge/models/people_model.dart';
import 'package:beatbridge/utils/helpers/text_helper.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/music_platforms/music_platform_used.dart';
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
  List<FriendModel> friendList = <FriendModel>[];
  bool hasError = false;


  @override
  void initState() {
    super.initState();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorConstants.mirage,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 27.w),
          child: Column(
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
                      style:
                          TextStyle(color: AppColorConstants.artyClickPurple),
                    ),
                  ),
                ]),
                Expanded(child: buildFriendsUI())
              ]),
        ));
  }

  Widget buildFriendsUI() => FutureBuilder<List<FriendModel>>(
        future: getFriendList(),
        builder:
            (BuildContext context, AsyncSnapshot<List<FriendModel>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.data!.isNotEmpty) {
                friendList = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${friendList.length} ${AppTextConstants.friends}',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColorConstants.roseWhite,
                          letterSpacing: 2,
                          fontSize: 13.sp),
                    ),
                   Expanded(child: buildFriendList())
                  ],
                );
              } else {
                if(hasError) {
                  return TextHelper.anErrorOccurredTextDisplay();
                }
                return TextHelper.noAvailableDataTextDisplay();
              }
          }
          return Container();
        },
      );

  Widget buildFriendList() => ListView.builder(
        itemCount: friendList.length,
        itemBuilder: (BuildContext context, int index) {
          return buildFriendItem(index);
        },
      );

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
                        image: friendList[index].profileImage != ''
                            ? AssetImage(friendList[index].profileImage)
                            : const AssetImage(
                                '${AssetsPathConstants.assetsPNGPath}/blank_profile_pic.png'),
                        fit: BoxFit.fitHeight,
                      )),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('User $index',
                    style: TextStyle(
                        color: AppColorConstants.roseWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                SizedBox(height: 6.h),
                Text('${friendList[index].tracks} Tracks',
                    style: TextStyle(
                        color: AppColorConstants.paleSky, fontSize: 13)),
                MusicPlatformUsed(
                    musicPlatforms: StaticDataService.getMusicPlatformsUsed())
              ],
            ),
          ],
        ),
      ]);


  Future<List<FriendModel>> getFriendList() async {
    final APIStandardReturnFormat result = await APIServices().getFriendList();
    final List<FriendModel> friends = <FriendModel>[];
    final dynamic jsonData = jsonDecode(result.successResponse);
    if (result.statusCode == 200) {
      for (final dynamic res in jsonData) {
        final FriendModel friend = FriendModel.fromJson(res);
        friends.add(friend);
      }
    }else{
      setState(() {
        hasError = true;
      });
    }
    return friends;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<FriendModel>('friendList', friendList))
      ..add(DiagnosticsProperty<bool>('hasError', hasError));
   }
}
