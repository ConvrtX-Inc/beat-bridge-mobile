// ignore_for_file: use_key_in_widget_constructors, sort_constructors_first, diagnostic_describe_all_properties, public_member_api_docs, must_be_immutable, always_specify_types, curly_braces_in_flow_control_structures, unnecessary_lambdas

import 'dart:convert';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/controller/all_queues_controller.dart';
import 'package:beatbridge/helpers/basehelper.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/recent_queue_model.dart';
import 'package:beatbridge/models/users/new_queue_model.dart';
import 'package:beatbridge/models/users/queue_model.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/queue_details.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

///All Queue Screen
class AllQueueScreen extends StatelessWidget {
  ///contructor
  // final BuildContext context;
  AllQueueScreen();

  final allQueuesController = Get.put(AllQueuesController());
  final List<RecentQueueModel> queueList = StaticDataService.getRecentQueues();
  int selectedQueueIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: buildAllQueuesUI(context),
      ),
    );
  }

  Widget buildAllQueuesUI(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 41.h),
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
          SizedBox(height: 36.h),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 11.w),
              child: Text(
                AppTextConstants.allQueues,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColorConstants.roseWhite,
                    fontSize: 22),
              )),
          SizedBox(height: 26.h),
          Expanded(child: buildQueueItemList(context))
        ]);
  }

  Widget buildQueueItemList(BuildContext context) {
    return FutureBuilder<APIStandardReturnFormat>(
      future: APIServices().getUserQueues(), // async work
      builder: (BuildContext context,
          AsyncSnapshot<APIStandardReturnFormat> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 50,
                width: 50,
                child: Center(child: CircularProgressIndicator()),
              ),
            );

          // ignore: no_default_cases
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else if (snapshot.data == null) {
              return Text('Error: ${snapshot.error}');
            } else {
              // final QueueModel userQueues = QueueModel.fromJson(
              //     json.decode(snapshot.data!.successResponse));
              final dynamic jsonData =
                  jsonDecode(snapshot.data!.successResponse);
              final List<NewQueueModel> userQueues = <NewQueueModel>[];
              final qs = (jsonData as List)
                  .map((i) => NewQueueModel.fromJson(i))
                  .toList();
              // for (int i = 0; i < qs.length; i++) {
              //   for (int j = i + 1; j < qs.length; j++) {
              //     if (qs[j].queueData == null) {
              //     } else {
              //       if (qs[i].queueData!.id.toString() ==
              //           qs[j].queueData!.id.toString()) {
              //         qs.removeAt(j);
              //       }
              //       else{

              //       }
              //     }
              //   }
              // }
              userQueues.addAll(qs);
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 11.w),
                itemCount: userQueues.length,
                itemBuilder: (BuildContext context, int index) {
                  print('userQueues : ${userQueues.length}' '''''');

                  // return buildQueueItem(context, userQueues[index], index);
                  return InkWell(
                    onTap: () {
                      UserSingleton.instance.queueIndex = index;
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              QueueDetails(userQueues[index])));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 24.h),
                        Row(
                          children: <Widget>[
                            if (userQueues[index].platform == null)
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(userQueues[index]
                                                  .platform ==
                                              null
                                          ? "${BaseHelper().baseUrl}${userQueues[index].image}"
                                          : userQueues[index]
                                                  .queueData
                                                  ?.images?[index]
                                                  .url ??
                                              'null'),
                                      fit: BoxFit.fitHeight,
                                    ),
                                    // image: DecorationImage(
                                    //   image: NetworkImage(
                                    //       '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}'
                                    //   ),
                                    //   fit: BoxFit.fitHeight,
                                    // ),
                                  ),
                                ),
                              )
                            else
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(userQueues[index]
                                                .queueData
                                                ?.images?[0]
                                                .url ??
                                            'null'),
                                        fit: BoxFit.fitHeight,
                                      )),
                                ),
                              ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                if (userQueues[index].platform == null)
                                  Text('${userQueues[index].name}',
                                      style: TextStyle(
                                          color: AppColorConstants.roseWhite,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.sp))
                                else
                                  Text('${userQueues[index].queueData?.name}',
                                      style: TextStyle(
                                          color: AppColorConstants.roseWhite,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.sp)),
                                SizedBox(height: 8.h),
                                // if (userQueues[index].queueData?.name != null)
                                //   Text('${userQueues[index].queueData?.name}',
                                //       style: TextStyle(
                                //           color: AppColorConstants.paleSky,
                                //           fontSize: 13))
                                // else
                                //   Text('',
                                //       style: TextStyle(
                                //           color: AppColorConstants.paleSky,
                                //           fontSize: 13)),
                                // SizedBox(height: 8.h),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            if (userQueues[index].platform == null)
                              userQueues[index].user == null
                                  ? Text(
                                      'Created by: ${userQueues[index].createdBy}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.sp),
                                    )
                                  : Text(
                                      'Created by: ${userQueues[index].user!.username}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.sp),
                                    )
                            else
                              Text(
                                'Created by: ${userQueues[index].queueData?.owner?.displayName}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.sp),
                              ),
                            Flexible(
                              child: Text(
                                '${userQueues[index].createdDate?.substring(0, 10)}',
                                style: TextStyle(
                                    color: AppColorConstants.paleSky,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    fontSize: 14.sp),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(),
                        SizedBox(height: 16.h),
                        Divider(
                          color: AppColorConstants.paleSky,
                        ),
                      ],
                    ),
                  );
                },
              );
            }
        }
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<RecentQueueModel>('queueList', queueList))
      ..add(IntProperty('selectedQueueIndex', selectedQueueIndex));
  }
}
//Container(
//                 padding: const EdgeInsets.all(6),
//                 child: ClipOval(
//                     child: queue.platform == null
//                         ? queue.image.toString().isNotEmpty ||
//                                 queue?.image != null
//                             ? Image.network(
//                                 "https://beat.softwarealliancetest.tk${queue?.image}",
//                                 fit: BoxFit.fill,
//                                 height: 70.h)
//                             : Image.network(
//                                 queue?.image ??
//                                     'https://www.w3schools.com/howto/img_avatar.png',
//                                 height: 70.h)
//                         : Image.network(
//                             queue.queueData!.images![0].url.toString(),
//                             height: 70.h)
//                     // child: Image.asset(recentQueueList[index].thumbnailUrl,
//                     // height: 70.h),
//                     ),
//               ),