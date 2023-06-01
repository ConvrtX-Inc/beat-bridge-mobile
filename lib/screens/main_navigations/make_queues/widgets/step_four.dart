import 'dart:convert';
import 'dart:developer';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/friends/new_friend_model.dart';
import 'package:beatbridge/models/people_model.dart';
import 'package:beatbridge/models/users/all_users_model.dart';
import 'package:beatbridge/utils/helpers/text_helper.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:beatbridge/widgets/buttons/app_outlined_button.dart';
import 'package:beatbridge/widgets/music_platforms/music_platform_used.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

const FlutterSecureStorage storage = FlutterSecureStorage();

///Step four
class StepFour extends StatefulWidget {
  ///Constructor
  const StepFour({required this.onStepFourDone, Key? key}) : super(key: key);

  ///Callback for step four
  final void Function() onStepFourDone;

  @override
  _StepFourState createState() => _StepFourState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<void Function()>.has(
        'onStepFourDone', onStepFourDone));
  }
}

class _StepFourState extends State<StepFour> {
  bool _isAPICallInProgress = false;
  List<NewFriendModel> friendList = <NewFriendModel>[];
  List<PeopleModel> peopleList = <PeopleModel>[];
  List<String> userChecked = [];
  bool hasError = false;

  showSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
        // ignore: prefer_const_constructors
        SnackBar(
            content: Text("Can't go back without completing Queue"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1)));
  }

  Widget buildFriendsUI() => Column(
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

  // FutureBuilder<List<NewFriendModel>>(
  //       future: getFriendList(),
  //       builder: (BuildContext context,
  //           AsyncSnapshot<List<NewFriendModel>> snapshot) {
  //         switch (snapshot.connectionState) {
  //           case ConnectionState.waiting:
  //             return const Center(child: CircularProgressIndicator());
  //           case ConnectionState.done:
  //             if (snapshot.data!.isNotEmpty) {
  //               friendList = snapshot.data!;
  //               return   } else {
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

  Widget buildFriendList() => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .55,
        child: ListView.builder(
          itemCount: friendList.length,
          itemBuilder: (BuildContext context, int index) {
            return buildFriendItem(index);
          },
        ),
      );
  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 1)));
  }

  Widget buildFriendItem(int index) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return AppColorConstants.roseWhite;
      }
      return AppColorConstants.artyClickPurple;
    }

    return Container(
      // width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .15,
      decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
      child: Row(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 10.h, 0),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: friendList[index].fromUser!.image.toString().isEmpty
                      ? Container(
                          margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height * .06),
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
                          margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height * .06),
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
          Container(
            width: MediaQuery.of(context).size.width * .67,
            height: MediaQuery.of(context).size.height * .15,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Text(friendList[index].username,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        friendList[index].fromUser != null
                            ? friendList[index].fromUser!.username.toString()
                            : '',
                        style: TextStyle(
                            color: AppColorConstants.roseWhite,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                    Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                            value: friendList[index].isSelected,
                            onChanged: (bool? value) async {
                              setState(() {
                                _isAPICallInProgress = true;
                                // friendList[index].isSelected= value;
                              });
                              print("calling make admin: ");
                              // if (value!) {
                              // log(friendList[index].isSelected.toString());
                              setState(() {
                                friendList[index].isSelected = value;
                                friendList[index].isAdmin = false;
                              });
                              log(friendList[index].isSelected.toString());
                              // if (peopleList[index].isSelected) {
                              // await APIServices()
                              //     .addFriends(friendList[index].id.toString());
                              final String? tempQueueID =
                                  await storage.read(key: 'tempQueueID');
                              print("friend id: ${friendList[index].id}");
                              print("the checkbox value is $value ");
                              if (value! == false) {
                                print("already a member");
                                await APIServices()
                                    .deleteQueueMember(
                                        friendList[index].memberId.toString())
                                    .then((value) {
                                  setState(() {
                                    _isAPICallInProgress = false;
                                    // friendList[index].isSelected= value;
                                  });
                                  // var jsons =
                                  //     json.decode(value.successResponse);

                                  // print(
                                  // "REMOVE MEMBER RESPONSE IS: ${jsons}");
                                  // print(
                                  //     "id used to send while making admin: ${jsons['id']}");
                                  // setState(() {
                                  //   friendList[index].memberId = jsons['id'];
                                  // });
                                });
                              } else {
                                print("not a member");
                                await APIServices()
                                    .addQueueMember(tempQueueID, false,
                                        friendList[index].fromUserId.toString())
                                    .then((value) {
                                  var jsons =
                                      json.decode(value.successResponse);
                                  print(
                                      "step four add member response: ${jsons}");
                                  print(
                                      "id used to send while making admin: ${jsons['id']}");
                                  setState(() {
                                    friendList[index].memberId = jsons['id'];
                                  });
                                });
                              }

                              _onSelected(
                                  value!, friendList[index].id.toString());
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //     // ignore: prefer_const_constructors
                              //     SnackBar(
                              //         content: Text('Queue Member Added'),
                              //         duration: const Duration(seconds: 1)));
                              // } else {
                              //   // ScaffoldMessenger.of(context).showSnackBar(
                              //   //     // ignore: prefer_const_constructors
                              //   //     SnackBar(
                              //   //         content: Text('Queue Member Removed'),
                              //   //         duration: const Duration(seconds: 1)));
                              // }
                              // }
                              setState(() {
                                _isAPICallInProgress = false;
                              });
                            },
                            checkColor: AppColorConstants.rubberDuckyYellow,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            side: MaterialStateBorderSide.resolveWith(
                              (Set<MaterialState> states) => BorderSide(
                                width: 2,
                                color: AppColorConstants.paleSky,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)))),
                  ],
                ),
                // const Spacer(),
                if (friendList[index].isSelected == true)
                  friendList[index].isAdmin == true
                      ? Container(
                          width: 0,
                          height: 0,
                        )
                      : AppOutlinedButton(
                          btnCallback: () async {
                            debugPrint('Make admin pressed');

                            final String? tempQueueID =
                                await storage.read(key: 'tempQueueID');
                            await APIServices()
                                .makeAdmin(
                              tempQueueID,
                              true,
                              "",
                              friendList[index].memberId.toString(),
                            )
                                .then((value) {
                              setState(() {
                                friendList[index].isAdmin = true;
                              });
                              print(
                                  "making admin new api responae: ${value.successResponse}");
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                // ignore: prefer_const_constructors
                                SnackBar(
                                    content:
                                        Text('User updated as Queue Admin'),
                                    duration: const Duration(seconds: 1)));
                          },
                          btnText: AppTextConstants.makeAdmin)

                //Text('${friendList[index].tracks} Tracks',
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFriendList();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await showSnack(),
      child: Scaffold(
          backgroundColor: AppColorConstants.mirage,
          body: Stack(children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(MediaQuery.of(context).size.height * .03),
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                // enablePullUp: true,
                onRefresh: () async {
                  getFriendList();
                  await Future.delayed(Duration(milliseconds: 1000));
                  _refreshController.refreshCompleted();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppTextConstants.addFriends,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColorConstants.roseWhite,
                                  fontSize: 22)),
                          Text("Admin",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColorConstants.roseWhite,
                                  fontSize: 22)),
                        ],
                      ),
                    ),
                    // Expanded(
                    //     child: ListView.builder(
                    //         padding: EdgeInsets.symmetric(horizontal: 27.w),
                    //         itemCount: peopleList.length,
                    //         itemBuilder: (BuildContext ctx, int index) {
                    //           return Column(
                    //             crossAxisAlignment: CrossAxisAlignment.stretch,
                    //             children: <Widget>[
                    //               buildPeopleItem(context, index),
                    //             ],
                    //           );
                    //         })),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    Expanded(child: buildFriendsUI()
                        // buildPeopleUI()

                        ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 27.w, vertical: 16.h),
                          child: ButtonRoundedGradient(
                            buttonText: AppTextConstants.continueTxt,
                            isLoading: _isAPICallInProgress,
                            buttonCallback: () {
                              // setState(() {
                              //   _isAPICallInProgress = true;
                              // });
                              //log(userChecked.length.toString());
                              if (userChecked.length > 0) {
                                widget.onStepFourDone();
                              } else {
                                _showToast(
                                    context, "Please select atleast 1 member!");
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //     // ignore: prefer_const_constructors
                                //     SnackBar(
                                //         content:
                                //             Text('Please select atleast 1 member'),
                                //         backgroundColor: Colors.red,
                                //         duration: const Duration(seconds: 1)));
                              }
                              // setState(() {
                              //   _isAPICallInProgress = false;
                              // });
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ])),
    );
  }

  Future<List<NewFriendModel>> getFriendList() async {
    final APIStandardReturnFormat result = await APIServices().getFriendList();
    final List<NewFriendModel> friends = <NewFriendModel>[];
    friendList.clear();
    final dynamic jsonData = jsonDecode(result.successResponse);
    print("friendsssssssssss: ${jsonData}");
    if (result.statusCode == 200) {
      for (final dynamic res in jsonData) {
        final NewFriendModel friend = NewFriendModel.fromJson(res);
        setState(() {
          friends.add(friend);
          friendList.add(friend);
        });
      }
      // friendList.addAll(friends?);
    } else {
      setState(() {
        hasError = true;
      });
    }
    return friends;
  }

  Widget buildPeopleItem(BuildContext context, int index) {
    // print("people profile: ${peopleList[index].profileImageUrl}");
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return AppColorConstants.roseWhite;
      }
      return AppColorConstants.artyClickPurple;
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 22.h),
          Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
                  child: peopleList[index].profileImageUrl == null ||
                          peopleList[index].profileImageUrl.toString().isEmpty
                      ? Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/images/png/avatar1.png"),
                                // image: NetworkImage(

                                //     "https://beat.softwarealliancetest.tk${peopleList[index].profileImageUrl}"),
                                fit: BoxFit.fitHeight,
                              )),
                        )
                      : Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                //image: AssetImage(peopleList[index].profileImageUrl),
                                image: NetworkImage(
                                    "https://beat.softwarealliancetest.tk${peopleList[index].profileImageUrl}"),
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
                  MusicPlatformUsed(
                      musicPlatforms: StaticDataService.getMusicPlatformsUsed())
                ],
              ),
              const Spacer(),
              Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                      value: peopleList[index].isSelected,
                      onChanged: (bool? value) async {
                        setState(() {
                          _isAPICallInProgress = true;
                        });
                        print("calling make admin: ");
                        // if (value!) {
                        log(peopleList[index].isSelected.toString());
                        setState(() {
                          peopleList[index].isSelected = value!;
                        });
                        log(peopleList[index].isSelected.toString());
                        // if (peopleList[index].isSelected) {
                        await APIServices().addFriends(peopleList[index].id2);
                        final String? tempQueueID =
                            await storage.read(key: 'tempQueueID');
                        await APIServices().addQueueMember(tempQueueID, false,
                            peopleList[index].id2.toString());

                        _onSelected(value!, peopleList[index].id.toString());
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //     // ignore: prefer_const_constructors
                        //     SnackBar(
                        //         content: Text('Queue Member Added'),
                        //         duration: const Duration(seconds: 1)));
                        // } else {
                        //   // ScaffoldMessenger.of(context).showSnackBar(
                        //   //     // ignore: prefer_const_constructors
                        //   //     SnackBar(
                        //   //         content: Text('Queue Member Removed'),
                        //   //         duration: const Duration(seconds: 1)));
                        // }
                        // }
                        setState(() {
                          _isAPICallInProgress = false;
                        });
                      },
                      checkColor: AppColorConstants.rubberDuckyYellow,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      side: MaterialStateBorderSide.resolveWith(
                        (Set<MaterialState> states) => BorderSide(
                          width: 2,
                          color: AppColorConstants.paleSky,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))))
            ],
          ),
          if (peopleList[index].isSelected)
            AppOutlinedButton(
                btnCallback: () async {
                  debugPrint('Make admin pressed');

                  final String? tempQueueID =
                      await storage.read(key: 'tempQueueID');
                  await APIServices().addQueueMember(
                      tempQueueID, true, peopleList[index].id.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                      // ignore: prefer_const_constructors
                      SnackBar(
                          content: Text('User updated as Queue Admin'),
                          duration: const Duration(seconds: 1)));
                },
                btnText: AppTextConstants.makeAdmin)
        ]);
  }

  Widget buildPeopleUI() => FutureBuilder<List<PeopleModel>>(
        future: getPeopleList(),
        builder:
            (BuildContext context, AsyncSnapshot<List<PeopleModel>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.data!.isNotEmpty) {
                peopleList = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Text(
                    //   '${peopleList.length} ${AppTextConstants.friends}',
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.w700,
                    //       color: AppColorConstants.roseWhite,
                    //       letterSpacing: 2,
                    //       fontSize: 13.sp),
                    // ),
                    Expanded(child: buildPeopleList())
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
        },
      );

  Widget buildPeopleList() => ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 27.w),
        itemCount: peopleList.length,
        itemBuilder: (BuildContext context, int index) {
          return buildPeopleItem(context, index);
        },
      );

  Widget buildPeoplesItem(int index) =>
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
                // MusicPlatformUsed(
                //     musicPlatforms: StaticDataService.getMusicPlatformsUsed())
              ],
            ),
          ],
        ),
      ]);

  Future<List<PeopleModel>> getPeopleList() async {
    if (peopleList.isEmpty) {
      final APIStandardReturnFormat result = await APIServices().getAllUsers();
      final List<PeopleModel> peoples = <PeopleModel>[];
      final List<AllUsers> allusers = <AllUsers>[];
      final dynamic jsonData = jsonDecode(result.successResponse);
      if (result.statusCode == 200) {
        print("peoples jsondata: $jsonData");
        for (final dynamic res in jsonData) {
          final AllUsers user = AllUsers.fromJson(res);
          //log(user.email.toString());
          allusers.add(user);
          peoples.add(PeopleModel(
              id: 0,
              id2: user.id.toString(),
              name: user.username.toString(),
              profileImageUrl: '${user.profileImage}',
              isSelected: false,
              isAdmin: false,
              totalTrackCount: user.trackCount!.toInt(),
              musicPlatformsUsed: []));
        }
      } else {
        // setState(() {
        //   hasError = true;
        // });
      }
      return peoples;
    } else {
      return peopleList;
    }
  }

  void _onSelected(bool selected, String dataName) {
    if (selected == true) {
      setState(() {
        userChecked.add(dataName);
      });
    } else {
      setState(() {
        userChecked.remove(dataName);
      });
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<PeopleModel>('peopleList', peopleList));
  }
}
