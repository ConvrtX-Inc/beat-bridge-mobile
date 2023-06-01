import 'dart:convert';
import 'dart:developer';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/models/add_queue_model.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/friends/new_friend_model.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/spotify_api_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../models/users/user_track_model.dart';
import '../../../../utils/logout_helper.dart';

///Step One
class StepOne extends StatefulWidget {
  ///Constructor
  const StepOne({required this.onStepOneDone, Key? key}) : super(key: key);

  ///Callback
  final void Function(String queueName) onStepOneDone;

  @override
  _StepOneState createState() => _StepOneState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<void Function(String queueName)>.has(
        'onStepOneDone', onStepOneDone));
  }
}

class _StepOneState extends State<StepOne> {
  bool _isAPICallInProgress = false;
  final TextEditingController queueNameTxtController = TextEditingController();
  late List<UserTrackModel> userTrackList = <UserTrackModel>[];
  int trackLength = 0;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getFriendList();
    trackLength = userTrackList.length;
    print('user length :${userTrackList.length}');
    print('track length :$trackLength');
  }

  var friendsLength = 0;
  Future<List<NewFriendModel>> getFriendList() async {
    final APIStandardReturnFormat result = await APIServices().getFriendList();
    final List<NewFriendModel> friends = <NewFriendModel>[];
    // friendList.clear();
    final dynamic jsonData = jsonDecode(result.successResponse);
    print("friendsssssssssss: ${jsonData}");
    if (result.statusCode == 200) {
      for (final dynamic res in jsonData) {
        final NewFriendModel friend = NewFriendModel.fromJson(res);
        setState(() {
          friends.add(friend);
        });
        setState(() {
          friendsLength = friends.length;
        });
      }
      // friendList.addAll(friends?);
    } else {
      setState(() {
        // hasError = true;
      });
    }
    return friends;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    queueNameTxtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 11.w),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 20.h,
                          ),
                          TextField(
                            controller: queueNameTxtController,
                            decoration: InputDecoration(
                                hintText: AppTextConstants.egBeatBridgeFavorite,
                                hintStyle: TextStyle(
                                  color: AppColorConstants.roseWhite
                                      .withOpacity(0.55),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColorConstants.roseWhite
                                            .withOpacity(0.55))),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red.withOpacity(0.55)))),
                            style:
                                TextStyle(color: AppColorConstants.roseWhite),
                          ),
                          SizedBox(height: 60.h),
                          ButtonRoundedGradient(
                            buttonText: AppTextConstants.continueTxt,
                            isLoading: _isAPICallInProgress,
                            buttonCallback: () async {
                              if (queueNameTxtController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    // ignore: prefer_const_constructors
                                    SnackBar(
                                        content: const Text(
                                            'Type Queue Name To Proceed!'),
                                        backgroundColor: Colors.red,
                                        duration: const Duration(seconds: 1)));
                              } else if (friendsLength == 0) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Please first add friends before making queue thank you!",
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor: Colors.grey,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                setState(() {
                                  _isAPICallInProgress = true;
                                  UserSingleton.instance.queueName =
                                      queueNameTxtController.text;
                                });
                                const FlutterSecureStorage storage =
                                    FlutterSecureStorage();
                                final String? userID =
                                    await storage.read(key: 'userID');

                                var _body = <String, dynamic>{
                                  'user_id': userID,
                                  'name': queueNameTxtController.text,
                                };
                                var bytes = json.encode(_body);
                                //Call User-Queue API
                                log('step one');
                                log(queueNameTxtController.text);

                                final APIStandardReturnFormat result =
                                    await APIServices().addQueue(bytes);
                                print(
                                    "step one response: ${result.successResponse}");
                                if (result.statusCode == 201) {
                                  log(result.statusCode.toString());
                                  final AddQueueModel queue =
                                      AddQueueModel.fromJson(
                                          json.decode(result.successResponse));
                                  log(queue.name.toString());
                                  await storage.write(
                                      key: 'tempQueueID', value: queue.id);

                                  if (queueNameTxtController.text != '') {
                                    //Step Two
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    widget.onStepOneDone(
                                        queueNameTxtController.text);
                                  } else {
                                    //Todo: Fix
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //     // ignore: prefer_const_constructors
                                    //     SnackBar(
                                    //         content: const Text(
                                    //             'Type Queue name to proceed!'),
                                    //         backgroundColor: Colors.red,
                                    //         duration:
                                    //             const Duration(seconds: 1)));
                                  }

                                  if (queueNameTxtController.text == '') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        // ignore: prefer_const_constructors
                                        SnackBar(
                                            content: const Text(
                                                'Type Queue Name To Proceed!'),
                                            backgroundColor: Colors.red,
                                            duration:
                                                const Duration(seconds: 1)));
                                  }
                                }

                                if (result.statusCode == 422) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      // ignore: prefer_const_constructors
                                      SnackBar(
                                          content: const Text(
                                              'Queue Name Already Exists!'),
                                          backgroundColor: Colors.red,
                                          duration:
                                              const Duration(seconds: 1)));
                                }

                                setState(() {
                                  _isAPICallInProgress = false;
                                });
                              }
                            },
                          )
                        ]),
                  )
                ],
              ))),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>(
        'queueNameTxtController', queueNameTxtController));
    properties
        .add(IterableProperty<UserTrackModel>('userTrackList', userTrackList));
  }
}
