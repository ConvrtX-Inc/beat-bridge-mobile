import 'dart:convert';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/friends/friend_model.dart';
import 'package:beatbridge/models/friends/new_friend_model.dart';
import 'package:beatbridge/models/people_model.dart';
import 'package:beatbridge/utils/helpers/text_helper.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/music_platforms/music_platform_used.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swipe_to/swipe_to.dart';

///Friend Screen
class FriendScreen extends StatefulWidget {
  ///Constructor
  const FriendScreen({Key? key}) : super(key: key);

  @override
  _FriendScreenState createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  List<NewFriendModel> friendList = <NewFriendModel>[];
  bool hasError = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ValueNotifier<List<NewFriendModel>> friendData =
      ValueNotifier<List<NewFriendModel>>([]);
  @override
  void initState() {
    super.initState();
    getFriendList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // key: _scaffoldKey,
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
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/friend_request');
                    },
                    child: Text(
                      'Friend Requests',
                      style:
                          TextStyle(color: AppColorConstants.artyClickPurple),
                    ),
                  ),
                ]),
                Expanded(child: buildFriendsUI())
              ]),
        ));
  }

  Widget buildFriendsUI() => ValueListenableBuilder<List<NewFriendModel>>(
      valueListenable: friendData,
      builder: (BuildContext context, value, Widget? child) {
        friendList = value;
        return value == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : friendData.value.length == 0
                ? Text(
                    'No friend found!',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColorConstants.roseWhite,
                        letterSpacing: 2,
                        fontSize: 13.sp),
                  )
                : Expanded(child: buildFriendList());
      });
  //  FutureBuilder<List<NewFriendModel>>(
  //       future: getFriendList(),
  //       builder: (BuildContext context,
  //           AsyncSnapshot<List<NewFriendModel>> snapshot) {
  //         switch (snapshot.connectionState) {
  //           case ConnectionState.waiting:
  //             return const Center(child: CircularProgressIndicator());
  //           case ConnectionState.done:
  //             if (snapshot.data!.isNotEmpty) {
  //               friendList = snapshot.data!;
  //               return Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //                   Text(
  //                     '${friendList.length} ${AppTextConstants.friends}',
  //                     style: TextStyle(
  //                         fontWeight: FontWeight.w700,
  //                         color: AppColorConstants.roseWhite,
  //                         letterSpacing: 2,
  //                         fontSize: 13.sp),
  //                   ),
  //                   Expanded(child: buildFriendList())
  //                 ],
  //               );
  //             } else {
  //               if (hasError) {
  //                 return TextHelper.anErrorOccurredTextDisplay();
  //               }
  //               return TextHelper.noAvailableDataTextDisplay();
  //             }
  //           case ConnectionState.active:
  //             {
  //               return TextHelper.stableTextDisplay('You are connected');
  //             }
  //           case ConnectionState.none:
  //             {
  //               return const SizedBox.shrink();
  //             }
  //         }

  //         // return Container();
  //       },
  //     );

  Widget buildFriendList() => ListView.builder(
        itemCount: friendList.length,
        itemBuilder: (BuildContext context, int index) {
          return buildFriendItem(index);
        },
      );

  Widget buildFriendItem(int index) => SwipeTo(
        onLeftSwipe: () {
          print("delete friend");
          APIServices()
              .removeFriend(friendList[index].id.toString())
              .then((value) async {
            // getFriendList();
            print("remove friend response status code: ${value.statusCode}");
            if (value.statusCode == 200) {
              // print("remove friend response: ${value.status}");
              getFriendList();
              // getFriendList();
              _showToast(context, 'Friend Removed');
              await Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => FriendScreen(
                          key: widget.key,
                        )),
              );
              _showToast(context, 'Friend Removed');
            } else {
              _showToast(context, "Something went wrong!");
            }
          });
          // saremoveFriendini
        },
        iconOnLeftSwipe: Icons.delete,
        iconColor: Colors.red,
        child: Container(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height * .08,
          decoration:
              BoxDecoration(border: Border.all(color: Colors.transparent)),
          child: Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:
                          friendList[index].fromUser!.image.toString().isEmpty
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
                                            "https://beat.softwarealliancetest.tk${friendList[index].fromUser!.image}"),
                                        fit: BoxFit.fitHeight,
                                      )),
                                )
                      // Container(
                      //   height: 60,
                      //   width: 60,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(8),
                      //       image: DecorationImage(
                      //         image: AssetImage(
                      //             '${AssetsPathConstants.assetsPNGPath}/blank_profile_pic.png'),
                      //         //     image: friendList[index].profileImage != ''
                      //         // ? AssetImage(friendList[index].profileImage)
                      //         // : const AssetImage(
                      //         //     '${AssetsPathConstants.assetsPNGPath}/blank_profile_pic.png'),
                      //         fit: BoxFit.fitHeight,
                      //       )),
                      // ),
                      )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Text(friendList[index].username,
                  Text(
                      friendList[index].fromUser != null
                          ? friendList[index].fromUser!.username.toString()
                          : '',
                      style: TextStyle(
                          color: AppColorConstants.roseWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  SizedBox(height: 6.h),
                  //Text('${friendList[index].tracks} Tracks',
                  Text('0 Tracks',
                      style: TextStyle(
                          color: AppColorConstants.paleSky, fontSize: 13)),
                  MusicPlatformUsed(
                      musicPlatforms: StaticDataService.getMusicPlatformsUsed())
                ],
              ),
            ],
          ),
        ),
      );

  Future<List<NewFriendModel>> getFriendList() async {
    friendData.value.clear();
    friendList.clear();
    final APIStandardReturnFormat result = await APIServices().getFriendList();
    final List<NewFriendModel> friends = <NewFriendModel>[];
    final dynamic jsonData = jsonDecode(result.successResponse);
    if (result.statusCode == 200) {
      for (final dynamic res in jsonData) {
        final NewFriendModel friend = NewFriendModel.fromJson(res);
        friends.add(friend);
      }
      setState(() {
        friendData.value = friends;
      });
    } else {
      setState(() {
        hasError = true;
      });
    }
    return friends;
  }

  void _showToast(BuildContext context, String message) {
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.grey,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
    // ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text(message), duration: const Duration(seconds: 1)));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<NewFriendModel>('friendList', friendList))
      ..add(DiagnosticsProperty<bool>('hasError', hasError));
  }
}
