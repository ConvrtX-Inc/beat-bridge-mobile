import 'dart:convert';

import 'package:beatbridge/helpers/basehelper.dart';
import 'package:beatbridge/models/users/new_queue_model.dart';
import 'package:beatbridge/utils/services/spotify_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify/spotify.dart' as spot;

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/people_model.dart';
import 'package:beatbridge/models/users/queue_member_model.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/music/member_profile.dart';

class SeeAllMemeber extends StatefulWidget {
  final String qId;
  final NewQueueModel queue;
  SeeAllMemeber(
    this.qId,
    this.queue,
  );

  @override
  State<SeeAllMemeber> createState() => _SeeAllMemeberState();
}

class _SeeAllMemeberState extends State<SeeAllMemeber> {
  final List<PeopleModel> friendList =
      StaticDataService.getPeopleListMockData();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SpotifyApiService.getTopTracks();
    getMembers();
  }

  var qMembers, userId;
  getMembers() async {
    await storage.read(key: 'userID').then((value) {
      setState(() {
        userId = value!;
      });
    });
    APIServices().getQueueMember(widget.qId).then((value) {
      final dynamic jsonData = jsonDecode(value.successResponse);
      print("""jsonData........ ${value}""");
      print(jsonData);
      print("""jsonData""");
      setState(() {
        final List<QueueMemberModel> members = <QueueMemberModel>[];
        (jsonData as List).map((i) => QueueMemberModel.fromJson(i)).toList();
        qMembers = (jsonData as List)
            .map((i) => QueueMemberModel.fromJson(i))
            .toList();

        members.addAll(qMembers);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 12,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColorConstants.roseWhite,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Members',
                      style: TextStyle(
                          color: AppColorConstants.roseWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          fontFamily: 'Gilroy'),
                    ),
                    Text(
                      'Admin',
                      style: TextStyle(
                          color: AppColorConstants.roseWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          fontFamily: 'Gilroy'),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                  child: qMembers == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          height: 120.h,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: qMembers.length,
                            itemBuilder: (BuildContext context, int index) {
                              print('qMembers length : ${qMembers.length}');
                              //return buildFriendItem(qMembers[index], index);

                              return qMembers[index].userId.toString() ==
                                      userId.toString()
                                  ? Container(
                                      height: 0,
                                      width: 0,
                                    )
                                  : Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.w),
                                      child: ListTile(
                                        onTap: () async {},
                                        contentPadding: EdgeInsets.zero,
                                        leading: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MemberProfile(
                                                            qMembers[index])));
                                          },
                                          child: qMembers[index].user?.image !=
                                                  null
                                              ? Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .04,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .12,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      // borderRadius:
                                                      // BorderRadius.circular(
                                                      //     8),
                                                      image: DecorationImage(
                                                        //image: NetworkImage(friendList[index].profileImageUrl),
                                                        image: NetworkImage(
                                                            "${BaseHelper().baseUrl}${qMembers[index].user.image}"),
                                                        fit: BoxFit.fill,
                                                      )),
                                                )
                                              : Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      image:
                                                          const DecorationImage(
                                                        //image: NetworkImage(friendList[index].profileImageUrl),
                                                        image: AssetImage(
                                                            'assets/images/png/avatar14.png'),
                                                        fit: BoxFit.fitHeight,
                                                      )),
                                                ),
                                        ),
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              qMembers[index].user.username,
                                              style: TextStyle(
                                                  color: AppColorConstants
                                                      .roseWhite,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17),
                                            ),
                                            widget.queue.isAdmin == true
                                                ? Checkbox(
                                                    value:
                                                        qMembers[index].isAdmin,
                                                    activeColor: Colors.green,
                                                    focusColor: Colors.white,
                                                    side: BorderSide(
                                                        color: Colors.white),
                                                    checkColor: Colors.white,
                                                    onChanged: (value) async {
                                                      setState(() {
                                                        print(
                                                            "valueeeee: $value");
                                                        qMembers[index]
                                                            .isAdmin = value!;
                                                      });
                                                      if (value == true) {
                                                        await APIServices()
                                                            .updateAdmin(
                                                          widget.qId,
                                                          value!,
                                                          qMembers[index]
                                                              .id
                                                              .toString(),
                                                        )
                                                            .then((value) {
                                                          getMembers();
                                                          // setState(() {
                                                          //   qMembers[index].isAdmin =
                                                          //       true;
                                                          // });
                                                          print(
                                                              "making admin new api responae: ${value.successResponse}");
                                                        });
                                                      } else {
                                                        await APIServices()
                                                            .updateAdmin(
                                                          widget.qId,
                                                          value!,
                                                          qMembers[index]
                                                              .id
                                                              .toString(),
                                                        )
                                                            .then((value) {
                                                          getMembers();
                                                          // setState(() {
                                                          //   qMembers[index].isAdmin =
                                                          //       false;
                                                          // });
                                                          print(
                                                              "making admin new api responae: ${value.successResponse}");
                                                        });
                                                      }
                                                    })
                                                : Container(
                                                    height: 0,
                                                    width: 0,
                                                  )
                                          ],
                                        ),
                                        // subtitle: Text(
                                        //   qMembers[index].user.username,
                                        //   key: Key("item" + index.toString()),
                                        //   style: TextStyle(
                                        //       color: AppColorConstants.paleSky,
                                        //       fontSize: 13),
                                        // ),
                                      ),
                                    );
                            },
                          ))

                  // FutureBuilder<APIStandardReturnFormat>(
                  //   //future: APIServices().getQueueMember('b4554759-c28b-4241-9f93-a3ff0a8d7c80'), // async work
                  //   future:
                  //       APIServices().getQueueMember(widget.qId), // async work
                  //   builder: (BuildContext context,
                  //       AsyncSnapshot<APIStandardReturnFormat> snapshot) {
                  //     switch (snapshot.connectionState) {
                  //       case ConnectionState.waiting:
                  //         return const Align(
                  //           alignment: Alignment.center,
                  //           child: SizedBox(
                  //             height: 50,
                  //             width: 50,
                  //             child: Center(child: CircularProgressIndicator()),
                  //           ),
                  //         );

                  //       // ignore: no_default_cases
                  //       default:
                  //         if (snapshot.hasError)
                  //           return Text('Error: ${snapshot.error}');
                  //         else if (snapshot.data!.status == 'error') {
                  //           return Text('Error: ${snapshot.error}');
                  //         } else {
                  //           final dynamic jsonData =
                  //               jsonDecode(snapshot.data!.successResponse);
                  //           print("""jsonData""");
                  //           print(jsonData);
                  //           print("""jsonData""");
                  //           final List<QueueMemberModel> members =
                  //               <QueueMemberModel>[];

                  //           final qMembers = (jsonData as List)
                  //               .map((i) => QueueMemberModel.fromJson(i))
                  //               .toList();

                  //           members.addAll(qMembers);
                  //           // return Container();
                  //           print('"""""""');
                  //           print('$members');
                  //           print('"""""""');
                  //           return Container(
                  //               height: 120.h,
                  //               child: ListView.builder(
                  //                 shrinkWrap: true,
                  //                 itemCount: qMembers.length,
                  //                 itemBuilder: (BuildContext context, int index) {
                  //                   print('qMembers length : ${qMembers.length}');
                  //                   //return buildFriendItem(qMembers[index], index);
                  //                   return Padding(
                  //                     padding:
                  //                         EdgeInsets.symmetric(horizontal: 8.w),
                  //                     child: ListTile(
                  //                       onTap: () async {},
                  //                       contentPadding: EdgeInsets.zero,
                  //                       leading: InkWell(
                  //                         onTap: () {
                  //                           Navigator.of(context).push(
                  //                               MaterialPageRoute(
                  //                                   builder: (context) =>
                  //                                       MemberProfile(
                  //                                           qMembers[index])));
                  //                         },
                  //                         child: qMembers[index].user?.image !=
                  //                                 null
                  //                             ? Container(
                  //                                 height: MediaQuery.of(context)
                  //                                         .size
                  //                                         .height *
                  //                                     .04,
                  //                                 width: MediaQuery.of(context)
                  //                                         .size
                  //                                         .width *
                  //                                     .12,
                  //                                 decoration: BoxDecoration(
                  //                                     shape: BoxShape.circle,
                  //                                     // borderRadius:
                  //                                     // BorderRadius.circular(
                  //                                     //     8),
                  //                                     image: DecorationImage(
                  //                                       //image: NetworkImage(friendList[index].profileImageUrl),
                  //                                       image: NetworkImage(
                  //                                           "https://beat.softwarealliancetest.tk${qMembers[index].user.image}"),
                  //                                       fit: BoxFit.fill,
                  //                                     )),
                  //                               )
                  //                             : Container(
                  //                                 height: 50,
                  //                                 width: 50,
                  //                                 decoration: BoxDecoration(
                  //                                     borderRadius:
                  //                                         BorderRadius.circular(
                  //                                             8),
                  //                                     image:
                  //                                         const DecorationImage(
                  //                                       //image: NetworkImage(friendList[index].profileImageUrl),
                  //                                       image: AssetImage(
                  //                                           'assets/images/png/avatar14.png'),
                  //                                       fit: BoxFit.fitHeight,
                  //                                     )),
                  //                               ),
                  //                       ),
                  //                       title: Row(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.spaceBetween,
                  //                         children: [
                  //                           Text(
                  //                             qMembers[index].user.username,
                  //                             style: TextStyle(
                  //                                 color:
                  //                                     AppColorConstants.roseWhite,
                  //                                 fontWeight: FontWeight.w600,
                  //                                 fontSize: 17),
                  //                           ),
                  //                           Checkbox(
                  //                               value: qMembers[index].isAdmin,
                  //                               activeColor: Colors.green,
                  //                               focusColor: Colors.white,
                  //                               side: BorderSide(
                  //                                   color: Colors.white),
                  //                               checkColor: Colors.white,
                  //                               onChanged: (value) {
                  //                                 setState(() {
                  //                                   qMembers[index].isAdmin =
                  //                                       value!;
                  //                                 });
                  //                               })
                  //                         ],
                  //                       ),
                  //                       subtitle: Text(
                  //                         qMembers[index].user.username,
                  //                         key: Key("item" + index.toString()),
                  //                         style: TextStyle(
                  //                             color: AppColorConstants.paleSky,
                  //                             fontSize: 13),
                  //                       ),
                  //                     ),
                  //                   );
                  //                 },
                  //               ));
                  //         }
                  //     }
                  //   },
                  // ),

                  ),
            ],
          )),
    );
  }

  Widget buildFriendItem(QueueMemberModel member, int index) {
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
          Text(member.user.username,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600))
        ],
      ),
    );
  }
}
