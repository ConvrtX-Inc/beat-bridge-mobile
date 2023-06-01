import 'dart:convert';
import 'dart:developer';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/friends/friend_request_model.dart';
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
class FriendRequestScreen extends StatefulWidget {
  ///Constructor
  const FriendRequestScreen({Key? key}) : super(key: key);

  @override
  _FriendRequestScreenState createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  @override
  void initState() {
    super.initState();
    getFriendsNearYou();
  }

  List<FriendRequestModel> friendsNearYou = <FriendRequestModel>[];
  bool hasError = false;
  bool isAPICallInProgress = false;
  late int selectedFriendIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorConstants.mirage,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 23.w),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 41.h),
                IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColorConstants.roseWhite,
                      size: 15.w,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                SizedBox(height: 26.h),
                Text(
                  'Friend Requests',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColorConstants.roseWhite,
                      fontFamily: 'Gilroy-Bold',
                      fontSize: 22.sp),
                ),
                SizedBox(height: 16.h),
                Expanded(child: buildFriendsNearYouUI())
              ]),
        ));
  }

  Widget buildFriendsNearYouUI() => FutureBuilder<List<FriendRequestModel>>(
      future: getFriendsNearYou(),
      builder: (BuildContext context,
          AsyncSnapshot<List<FriendRequestModel>> snapshot) {
        log('snapshot.hasData.toString()');
        log(snapshot.hasData.toString());
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());

          case ConnectionState.done:
            if (snapshot.hasData) {
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
              if (hasError) {
                return TextHelper.anErrorOccurredTextDisplay();
              }
              return TextHelper.noAvailableDataTextDisplay();
            }
          case ConnectionState.active:
            {
              return TextHelper.stableTextDisplay('You are connected');
            }
          case ConnectionState.none:
            {
              return const SizedBox.shrink();
            }
        }

        // return Container();
      });

  Widget buildFriendNearYouList() {
    return ListView.builder(
      itemCount: friendsNearYou.length,
      itemBuilder: (BuildContext context, int index) {
        print("friends image: ${friendsNearYou[index].image}");
        return buildFriendNearYouItem(index);
      },
    );
  }

  Widget buildFriendNearYouItem(int index) => Container(
        width: MediaQuery.of(context).size.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          SizedBox(height: 22.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
                  child: friendsNearYou[index].image.toString().isEmpty
                      ? Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage(
                                    '${AssetsPathConstants.assetsPNGPath}/blank_profile_pic.png'),
                                fit: BoxFit.fitHeight,
                              )),
                        )
                      : Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://beat.softwarealliancetest.tk${friendsNearYou[index].image}"),
                                fit: BoxFit.fitHeight,
                              )),
                        )),
              Container(
                width: MediaQuery.of(context).size.width * .23,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(friendsNearYou[index].username.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AppColorConstants.roseWhite,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                    SizedBox(height: 6.h),
                    //Todo:
                    Text(
                        // '0 Tracks',
                        '${friendsNearYou[index].totalTracks} Tracks',
                        style: TextStyle(
                            color: AppColorConstants.paleSky, fontSize: 13)),
                    MusicPlatformUsed(
                        musicPlatforms:
                            StaticDataService.getMusicPlatformsUsed())
                  ],
                ),
              ),
              // const Spacer(),
              SizedBox(
                  width: MediaQuery.of(context).size.width * .227,
                  child: AppOutlinedButton(
                      key: UniqueKey(),
                      btnText: 'Accept',
                      isLoading:
                          isAPICallInProgress && selectedFriendIndex == index,
                      btnCallback: () async {
                        debugPrint('Add Friend ${friendsNearYou[index].email}');
                        await updatedRequest(index, true);
                        //addFriend(index);
                      })),
              SizedBox(
                  width: MediaQuery.of(context).size.width * .227,
                  child: AppOutlinedButton(
                      key: UniqueKey(),
                      btnText: 'Decline',
                      btnColor: Color.fromRGBO(193, 19, 19, 0.29),
                      btnOutlineColor: Colors.red,
                      isLoading:
                          isAPICallInProgress && selectedFriendIndex == index,
                      btnCallback: () async {
                        debugPrint(
                            'Remove Friend ${friendsNearYou[index].email}');
                        await updatedRequest(index, false);
                      }))
            ],
          ),
        ]),
      );

  Future<List<FriendRequestModel>> getFriendsNearYou() async {
    final APIStandardReturnFormat result =
        await APIServices().getFriendRequest();
    log('getFriendRequest: ${result.successResponse}');
    final List<FriendRequestModel> friends = <FriendRequestModel>[];
    final dynamic jsonData = json.decode(result.successResponse);
    // log(jsonData.length);
    // print("friend request length: ${jsonData.length}");
    //final Map<String, dynamic> response = jsonData['response'];
    //final Map<String, dynamic> data = response['data'];
    //final dynamic details = data['details'];
    //final FriendRequestModel friend = FriendRequestModel.fromJson(jsonData);
    //friends.add(friend);

    if (result.statusCode == 200) {
      for (final dynamic res in jsonData) {
        final FriendRequestModel friend = FriendRequestModel.fromJson(res);
        // print("index data: $friend");
        friends.add(friend);
      }
    } else {
      setState(() {
        hasError = true;
      });
    }
    print("my friend requeat finalised: ${friends}");
    return friends;
  }

  Future<void> updatedRequest(int index, bool isAccepting) async {
    setState(() {
      isAPICallInProgress = !isAPICallInProgress;
      selectedFriendIndex = index;
    });

    if (isAccepting) {
      final APIStandardReturnFormat result = await APIServices()
          .confirmFriend(friendsNearYou[index].id.toString());

      if (result.statusCode == 200) {
        _showToast(context, 'Friend Accepted');

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
    } else {
      final APIStandardReturnFormat result = await APIServices()
          .declineFriend(friendsNearYou[index].connection!.id.toString());

      if (result.statusCode == 200) {
        _showToast(context, 'Friend Declined');

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
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 1)));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<FriendRequestModel>(
          'friendsNearYou', friendsNearYou))
      ..add(DiagnosticsProperty<bool>('hasError', hasError))
      ..add(
          DiagnosticsProperty<bool>('isAPICallInProgress', isAPICallInProgress))
      ..add(IntProperty('selectedFriendIndex', selectedFriendIndex));
  }
}
