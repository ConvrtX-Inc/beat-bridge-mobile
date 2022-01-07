import 'dart:convert';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/friends/near_you_model.dart';
import 'package:beatbridge/models/people_model.dart';
import 'package:beatbridge/utils/helpers/text_helper.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_outlined_button.dart';
import 'package:beatbridge/widgets/music_platforms/music_platform_used.dart';
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
  @override
  void initState() {
    super.initState();
    getFriendsNearYou();
  }

  List<NearYouModel> friendsNearYou = <NearYouModel>[];
  bool hasError = false;
  bool isAPICallInProgress = false;
  late int selectedFriendIndex;

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
                Text(
                  AppTextConstants.nearYou,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColorConstants.roseWhite,
                      fontSize: 30.sp),
                ),
                SizedBox(height: 16.h),
                Expanded(child: buildFriendsNearYouUI())
              ]),
        ));
  }


  Widget buildFriendsNearYouUI() => FutureBuilder<List<NearYouModel>>(
    future: getFriendsNearYou(),
      builder: (BuildContext context, AsyncSnapshot<List<NearYouModel>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.data!.isNotEmpty) {
              friendsNearYou = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${friendsNearYou.length} ${AppTextConstants.people}',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColorConstants.roseWhite,
                        letterSpacing: 2,
                        fontSize: 13.sp),
                  ),
                  Expanded(child: buildFriendNearYouList())
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
      });

  Widget buildFriendNearYouList() {
    return ListView.builder(
      itemCount: friendsNearYou.length,
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
                        image: friendsNearYou[index].profileImage != ''
                            ? AssetImage(friendsNearYou[index].profileImage)
                            : const AssetImage(
                                '${AssetsPathConstants.assetsPNGPath}/blank_profile_pic.png'),
                        fit: BoxFit.fitHeight,
                      )),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(friendsNearYou[index].username,
                    style: TextStyle(
                        color: AppColorConstants.roseWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                SizedBox(height: 6.h),
                Text('${friendsNearYou[index].totalTracks} Tracks',
                    style: TextStyle(
                        color: AppColorConstants.paleSky, fontSize: 13)),
                MusicPlatformUsed(
                    musicPlatforms: StaticDataService.getMusicPlatformsUsed())
              ],
            ),
            const Spacer(),
            SizedBox(
                width: 110.w,
                child: AppOutlinedButton(
                    key: UniqueKey(),
                    btnText: AppTextConstants.addFriend,
                    isLoading:
                        isAPICallInProgress && selectedFriendIndex == index,
                    btnCallback: () {
                      debugPrint('Add Friend ${friendsNearYou[index].email}');
                      addFriend(index);
                    }))
          ],
        ),
      ]);

  Future<List<NearYouModel>> getFriendsNearYou() async {
    final APIStandardReturnFormat result =
        await APIServices().findFriendsNearYou();

    final List<NearYouModel> friends = <NearYouModel>[];
    final Map<String, dynamic> jsonData = jsonDecode(result.successResponse);
    final Map<String, dynamic> response = jsonData['response'];
    final Map<String, dynamic> data = response['data'];
    final dynamic details = data['details'];

    if (result.statusCode == 200) {
      for (final dynamic res in details) {
        final NearYouModel friend = NearYouModel.fromJson(res);
        friends.add(friend);
      }
    } else {
      setState(() {
        hasError = true;
      });
    }

    return friends;
  }

  Future<void> addFriend(int index) async {
    setState(() {
      isAPICallInProgress = !isAPICallInProgress;
      selectedFriendIndex = index;
    });

    final APIStandardReturnFormat result =
        await APIServices().addFriend(friendsNearYou[index].email);
    if (result.statusCode == 200) {
      _showToast(context, AppTextConstants.friendRequestSent);

      setState(() {
        friendsNearYou.remove(friendsNearYou[index]);
        isAPICallInProgress = false;
      });
    } else {
      setState(() {
        isAPICallInProgress = false;
        hasError = true;
      });

      _showToast(context, AppTextConstants.anErrorOccurred);
    }
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 1)));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
       ..add(IterableProperty<NearYouModel>('friendsNearYou', friendsNearYou))
       ..add(DiagnosticsProperty<bool>('hasError', hasError))
      ..add(
          DiagnosticsProperty<bool>('isAPICallInProgress', isAPICallInProgress))
      ..add(IntProperty('selectedFriendIndex', selectedFriendIndex));
  }
}
