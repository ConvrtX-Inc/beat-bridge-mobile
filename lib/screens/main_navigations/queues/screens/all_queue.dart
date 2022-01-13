// ignore_for_file: use_key_in_widget_constructors, sort_constructors_first, diagnostic_describe_all_properties, public_member_api_docs, must_be_immutable, always_specify_types, curly_braces_in_flow_control_structures, unnecessary_lambdas

import 'dart:convert';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/controller/all_queues_controller.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/recent_queue_model.dart';
import 'package:beatbridge/models/users/queue_model.dart';
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
  final BuildContext context;
  AllQueueScreen(this.context);
  final allQueuesController = Get.put(AllQueuesController());

  @override
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
            return const SizedBox(
              height: 50,
              width: 50,
              child: Center(child: CircularProgressIndicator()),
            );

          // ignore: no_default_cases
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else if (snapshot.data!.status == 'error') {
              return Text('Error: ${snapshot.error}');
            } else {
              // final QueueModel userQueues = QueueModel.fromJson(
              //     json.decode(snapshot.data!.successResponse));
              final dynamic jsonData =
                  jsonDecode(snapshot.data!.successResponse);
              final List<QueueModel> userQueues = <QueueModel>[];
              final qs = (jsonData as List)
                  .map((i) => QueueModel.fromJson(i))
                  .toList();
              userQueues.addAll(qs);
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 11.w),
                itemCount: userQueues.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildQueueItem(context, userQueues[index], index);
                },
              );
            }
        }
      },
    );
  }

  Widget buildQueueItem(BuildContext context, QueueModel queue, int index) {
    final DateTime parseDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(queue.createdDate);
    final DateTime inputDate = DateTime.parse(parseDate.toString());
    final DateFormat outputFormat = DateFormat('h:mm:a  | dd/mm/yy');
    final String outputDate = outputFormat.format(inputDate);
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

    return GetBuilder<AllQueuesController>(builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 24.h),
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
                            image: AssetImage(queueList[index].thumbnailUrl),
                            fit: BoxFit.fitHeight,
                          )),
                      child: Align(
                          child: Image.asset(
                              '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}')))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(queue.name,
                      style: TextStyle(
                          color: AppColorConstants.roseWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp)),
                  SizedBox(height: 8.h),
                  Text('${queueList[index].totalSongs} Songs',
                      style: TextStyle(
                          color: AppColorConstants.paleSky, fontSize: 13)),
                  SizedBox(height: 8.h),
                  buildMusicPlatformsUsedRow(context, index)
                ],
              ),
              const Spacer(),
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  value: index.toString() == controller.selected.toString(),
                  onChanged: (bool? value) {
                    allQueuesController.setSelected(index.toString());
                    // setState(() {
                    //   // queueList[index].isSelected = value!;
                    //   selectedQueueIndex = index;
                    // });
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
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Created by: ${queue.creator.username}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp),
              ),
              Text(
                outputDate,
                style: TextStyle(
                    color: AppColorConstants.paleSky,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    fontSize: 14.sp),
              )
            ],
          ),
          SizedBox(height: 16.h),
          Divider(
            color: AppColorConstants.paleSky,
          )
        ],
      );
    });
  }

  Widget buildMusicPlatformsUsedRow(BuildContext context, int index) {
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          for (int i = 0; i < queueList[index].musicPlatformsUsed.length; i++)
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Image(
                    image: AssetImage(
                        queueList[index].musicPlatformsUsed[i].logoImagePath),
                    height: 18,
                    width: 18)),
        ],
      )
    ]);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<RecentQueueModel>('queueList', queueList))
      ..add(IntProperty('selectedQueueIndex', selectedQueueIndex));
  }
}
