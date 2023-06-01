import 'dart:convert';
import 'dart:developer';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/people_model.dart';
import 'package:beatbridge/models/users/all_users_model.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:beatbridge/widgets/buttons/app_outlined_button.dart';
import 'package:beatbridge/widgets/music_platforms/music_platform_used.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  final List<PeopleModel> peopleList =
      StaticDataService.getPeopleListMockData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorConstants.mirage,
        body: Stack(children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 11.w),
                          child: Column(children: <Widget>[
                            Text(AppTextConstants.addFriends,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColorConstants.roseWhite,
                                    fontSize: 22)),
                            SizedBox(height: 26.h),
                          ])),
                    ],
                  ))),
              Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 27.w),
                      itemCount: peopleList.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            buildPeopleItem(context, index),
                            // buildFriendList()
                          ],
                        );
                      })),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 27.w, vertical: 16.h),
                    child: ButtonRoundedGradient(
                      buttonText: AppTextConstants.continueTxt,
                      buttonCallback: () {
                        widget.onStepFourDone();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ]));
  }

  Widget buildPeopleItem(BuildContext context, int index) {
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
                  child: peopleList[index].profileImageUrl.toString().isEmpty
                      ? Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage(
                                    peopleList[index].profileImageUrl),
                                fit: BoxFit.fitHeight,
                              )))
                      : Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
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
                      onChanged: (bool? value) {
                        setState(() {
                          peopleList[index].isSelected = value!;
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
                btnCallback: () {
                  debugPrint('Make admin pressed');
                },
                btnText: AppTextConstants.makeAdmin)
        ]);
  }

  Widget buildPeopleList() {
    return FutureBuilder<APIStandardReturnFormat>(
      future: APIServices().getAllUsers(), // async work
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
            //log(jsonDecode(snapshot.toString()));
            if (snapshot.hasError)
              return Text('Error1: ${snapshot.error}');
            else if (snapshot.data!.status == 'error') {
              return Text('Error2: ${snapshot.error}');
            } else {
              final dynamic jsonData =
                  jsonDecode(snapshot.data!.successResponse);

              final List<PeopleModel> members = <PeopleModel>[];
              final List<AllUsers> allusers = <AllUsers>[];
              for (final dynamic res in jsonData) {
                final AllUsers user = AllUsers.fromJson(res);
                //log(user.email.toString());
                allusers.add(user);
                members.add(PeopleModel(
                    id: 0,
                    id2: user.id.toString(),
                    name: user.username.toString(),
                    profileImageUrl:
                        'https://www.w3schools.com/howto/img_avatar.png',
                    isSelected: false,
                    isAdmin: false,
                    totalTrackCount: user.trackCount!.toInt(),
                    musicPlatformsUsed: []));
              }
              log(members.length.toString());

              return Container();
            }
        }
      },
    );
  }

  // Widget buildFriendList() {
  //   return FutureBuilder<APIStandardReturnFormat>(
  //     future: APIServices().getAllUsers(), // async work
  //     builder: (BuildContext context,
  //         AsyncSnapshot<APIStandardReturnFormat> snapshot) {
  //       switch (snapshot.connectionState) {
  //         case ConnectionState.waiting:
  //           return const SizedBox(
  //             height: 50,
  //             width: 50,
  //             child: Center(child: CircularProgressIndicator()),
  //           );

  //         // ignore: no_default_cases
  //         default:
  //           //log(jsonDecode(snapshot.toString()));
  //           if (snapshot.hasError)
  //             return Text('Error1: ${snapshot.error}');
  //           else if (snapshot.data!.status == 'error') {
  //             return Text('Error2: ${snapshot.error}');
  //           } else {
  //             final dynamic jsonData =
  //                 jsonDecode(snapshot.data!.successResponse);

  //             final List<PeopleModel> members = <PeopleModel>[];
  //             final List<AllUsers> allusers = <AllUsers>[];
  //             for (final dynamic res in jsonData) {
  //               final AllUsers user = AllUsers.fromJson(res);
  //               //log(user.email.toString());
  //               allusers.add(user);
  //               members.add(PeopleModel(
  //                   id: 0,
  //                   id2: user.id.toString(),
  //                   name: user.username.toString(),
  //                   profileImageUrl:
  //                       'https://www.w3schools.com/howto/img_avatar.png',
  //                   isSelected: false,
  //                   isAdmin: false,
  //                   totalTrackCount: user.trackCount!.toInt(),
  //                   musicPlatformsUsed: []));
  //             }
  //             log(members.length.toString());

  //             //return Container();
  //             return Container(
  //               height: 120.h,
  //               child: ListView(
  //                   shrinkWrap: true,
  //                   scrollDirection: Axis.horizontal,
  //                   children: <Widget>[
  //                     for (int i = 0; i < members.length; i++)
  //                       buildFriendItem(members[i], i),
  //                     Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: 8.w),
  //                       child: Column(
  //                         children: <Widget>[
  //                           Container(
  //                             height: 50,
  //                             width: 50,
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(8),
  //                               gradient: LinearGradient(
  //                                 begin: const Alignment(-0.5, 0),
  //                                 colors: <Color>[
  //                                   AppColorConstants.artyClickPurple,
  //                                   AppColorConstants.lemon
  //                                 ],
  //                               ),
  //                             ),
  //                             child: Center(
  //                                 child: Text(
  //                               '${members.length}+',
  //                               style: TextStyle(
  //                                   color: Colors.white,
  //                                   fontSize: 22.sp,
  //                                   fontWeight: FontWeight.w800),
  //                             )),
  //                           ),
  //                         ],
  //                       ),
  //                     )
  //                   ]),
  //             );
  //           }
  //       }
  //     },
  //   );
  // }

  // Widget buildFriendItem(QueueMemberModel member, int index) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 8.w),
  //     child: Column(
  //       children: <Widget>[
  //         Container(
  //           height: 50,
  //           width: 50,
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(8),
  //               image: DecorationImage(
  //                 image: AssetImage(friendList[index].profileImageUrl),
  //                 fit: BoxFit.fitHeight,
  //               )),
  //         ),
  //         SizedBox(
  //           height: 6.h,
  //         ),
  //         Text(member.user.username,
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 10.sp,
  //                 fontWeight: FontWeight.w600))
  //       ],
  //     ),
  //   );
  // }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<PeopleModel>('peopleList', peopleList));
  }
}
