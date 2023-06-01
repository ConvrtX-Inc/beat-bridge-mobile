import 'dart:convert';

import 'package:beatbridge/helpers/basehelper.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/spotify_api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify/spotify.dart' as spot;

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/users/new_queue_model.dart';
import 'package:beatbridge/utils/logout_helper.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SeeAllQueueData extends StatefulWidget {
  SeeAllQueueData({this.queueData});

  ValueNotifier<List<NewQueueModel>>? queueData;

  @override
  State<SeeAllQueueData> createState() => _SeeAllQueueDataState();
}

class _SeeAllQueueDataState extends State<SeeAllQueueData> {
  var userId;
  ValueNotifier<List<NewQueueModel>> queueData =
      ValueNotifier<List<NewQueueModel>>([]);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SpotifyApiService.getTopTracks();
    getUser();
    getQueue();
  }

  getQueue() {
    APIServices().recentQueue(userIdd: "0").then((value) {
      setState(() {
        queueData!.value = value;
      });
    });
  }

  getUser() async {
    await storage.read(key: 'userID').then((value) {
      setState(() {
        userId = value!;
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
              SizedBox(
                height: MediaQuery.of(context).size.height * .06,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColorConstants.roseWhite,
                    ),
                    onPressed: () {
                      print('gbrenk press back!');
                      Navigator.of(context).pop();
                    },
                  )),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  'All Queues',
                  style: TextStyle(
                      color: AppColorConstants.roseWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      fontFamily: 'Gilroy'),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.queueData!.value.length,
                  shrinkWrap: true,
                  // scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    if (widget.queueData!.value.first.queueData == null) {
                      return buildRecentQueueItem(
                        widget.queueData!.value[index],
                        index,
                      );
                    } else {
                      return buildRecentQueueItem(
                        widget.queueData!.value[index],
                        index,
                      );
                    }
                    // return buildRecentQueueItem(userQueues[index], index);
                  },
                ),

                //  buildRecentQueuesList(),
                // child: FutureBuilder<APIStandardReturnFormat>(
                //   //pass id perameters here
                //   future:
                //       APIServices().getUserQueues(userIdd: "0"), // async work
                //   builder: (BuildContext context,
                //       AsyncSnapshot<APIStandardReturnFormat> snapshot) {
                //     switch (snapshot.connectionState) {
                //       case ConnectionState.waiting:
                //         return const SizedBox(
                //           height: 50,
                //           width: 50,
                //           child: Center(
                //               child: Align(
                //                   alignment: Alignment.center,
                //                   child: CircularProgressIndicator())),
                //         );

                //       // ignore: no_default_cases
                //       default:
                //         if (snapshot.hasError)
                //           return Text('Error: ${snapshot.error}');
                //         else if (snapshot.data!.status == 'error') {
                //           return Text('Error: ${snapshot.error}');
                //         } else {
                //           // final QueueModel userQueues = QueueModel.fromJson(
                //           //     json.decode(snapshot.data!.successResponse));
                //           final dynamic jsonData =
                //               jsonDecode(snapshot.data!.successResponse);
                //           final List<NewQueueModel> userQueues =
                //               <NewQueueModel>[];
                //           final qs = (jsonData as List)
                //               .map((i) => NewQueueModel.fromJson(i))
                //               .toList();
                //           userQueues.addAll(qs);
                //           return SizedBox(
                //             height: 120.h,
                //             child: ListView.builder(
                //               itemCount: userQueues.length,
                //               shrinkWrap: true,
                //               itemBuilder: (BuildContext context, int index) {
                //                 if (userQueues.first.queueData == null) {
                //                   return buildRecentQueueItem(
                //                     userQueues[index],
                //                     index,
                //                   );
                //                 } else {
                //                   return buildRecentQueueItem(
                //                     userQueues[index],
                //                     index,
                //                   );
                //                 }
                //                 // return buildRecentQueueItem(userQueues[index], index);
                //               },
                //             ),
                //           );
                //         }
                //     }
                //   },
                // ),
              ),
            ],
          )),
    );
  }

  Widget buildRecentQueuesList() {
    return ValueListenableBuilder<List<NewQueueModel>>(
        valueListenable: queueData,
        builder: (BuildContext context, value, Widget? child) {
          // ignore: unnecessary_null_comparison
          // print("hedsadsallo: $value");
          if (value.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * .06,
              width: MediaQuery.of(context).size.width * .9,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height * .11,
              child: ListView.builder(
                itemCount: value.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  if (value.first.queueData == null) {
                    return buildRecentQueueItem(
                      value[index],
                      index,
                    );
                  } else {
                    return buildRecentQueueItem(
                      value[index],
                      index,
                    );
                  }
                  // return buildRecentQueueItem(userQueues[index], index);
                },
              ),
            );
          }
        });
  }
////hererre
  Widget buildRecentQueueItem(NewQueueModel queue, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            UserSingleton.instance.queueIndex = index;
          });
          Navigator.of(context).pushNamed('/queue-details', arguments: queue);
        },
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 60,
              width: 60,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColorConstants.mirage,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: ClipOval(
                      child: queue.platform == null
                          ? queue.image.toString().isNotEmpty ||
                          queue?.image != null
                          ? Image.network(
                          "https://beat.softwarealliancetest.tk${queue?.image}",
                          fit: BoxFit.fill,
                          height: 70.h)
                          : Image.network(
                          queue?.image ??
                              'https://www.w3schools.com/howto/img_avatar.png',
                          height: 70.h)
                          : Image.network(
                          queue.queueData!.images![0].url.toString(),
                          height: 70.h)
                    // child: Image.asset(recentQueueList[index].thumbnailUrl,
                    // height: 70.h),
                  ),
                  // child: ClipOval(
                  //     child: queue.image.toString().isNotEmpty ||
                  //         queue.image != null
                  //         ? Image.network(
                  //         "https://beat.softwarealliancetest.tk${queue?.image}",
                  //         fit: BoxFit.fill,
                  //         height: 70.h)
                  //         : Image.network(
                  //         queue.image ??
                  //             'https://www.w3schools.com/howto/img_avatar.png',
                  //         height: 70.h)
                  //   // queue.queueData != null
                  //   //     ? Image.network(
                  //   //         queue.queueData!.images![0].url.toString(),
                  //   //         height: 70.h)
                  //   //     : Image.network(
                  //   //         'https://www.w3schools.com/howto/img_avatar.png',
                  //   //         height: 70.h),
                  //   // child: Image.asset(recentQueueList[index].thumbnailUrl,
                  //   // height: 70.h),
                  // ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  queue.name.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
                Text(
                  // '${queue?.queueData?.tracks?.total}'  ,
                  'Songs',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> play(String uri) async {
    try {
      await SpotifySdk.play(spotifyUri: uri);
      SpotifySdk.seekTo(positionedMilliseconds: 0);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
  }
}
