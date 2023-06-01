import 'dart:convert';
import 'dart:developer';
import 'dart:io';
//import 'dart:html';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/recent_queue.dart';
import 'package:beatbridge/utils/approutes.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

///Step Six
class StepSix extends StatefulWidget {
  ///Constructor
  const StepSix({required this.onStepSixDone, Key? key}) : super(key: key);

  ///Callback
  final void Function() onStepSixDone;
  @override
  _StepSixState createState() => _StepSixState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<void Function()>.has(
        'onStepSixDone', onStepSixDone));
  }
}

class _StepSixState extends State<StepSix> {
  final TextEditingController queueNameTxtController = TextEditingController();

  /// Variables
  ImagePicker picker = ImagePicker();
  XFile? image;
  File? f = null;
  bool APIcalling = false;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    queueNameTxtController.dispose();
    super.dispose();
  }

  showSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
        // ignore: prefer_const_constructors
        SnackBar(
            content: Text("Can't go back without completing Queue"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1)));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await showSnack(),
      child: Scaffold(
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
                              height: 100.h,
                            ),
                            InkWell(
                              onTap: () async {
                                log('Picker');
                                image = await picker.pickImage(
                                    source: ImageSource.gallery);
                                setState(() {
                                  f = File(image!.path);
                                });
                              },
                              child: Center(
                                child: f == null
                                    ? Image.asset(
                                        'assets/images/placeholder.png',
                                        width: 194,
                                        height: 174)
                                    : ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        child: Image.file(
                                          f!,
                                          width: 194,
                                          height: 174,
                                          fit: BoxFit.cover,
                                        )),
                              ),
                            ),
                            // TextField(

                            //   controller: queueNameTxtController,
                            //   decoration: InputDecoration(
                            //       hintText: AppTextConstants.egBeatBridgeFavorite,
                            //       hintStyle: TextStyle(
                            //         color:
                            //             AppColorConstants.roseWhite.withOpacity(0.55),
                            //       ),
                            //       enabledBorder: UnderlineInputBorder(
                            //           borderSide: BorderSide(
                            //               color: AppColorConstants.roseWhite
                            //                   .withOpacity(0.55))),
                            //                   errorBorder: UnderlineInputBorder(
                            //           borderSide: BorderSide(
                            //               color: Colors.red
                            //                   .withOpacity(0.55)))
                            //                   ),

                            //   style:TextStyle(color: AppColorConstants.roseWhite),
                            // ),
                            SizedBox(height: 60.h),
                            Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: ButtonRoundedGradient(
                                  buttonText: AppTextConstants.allDone,
                                  isLoading: APIcalling,
                                  buttonCallback: () async {
                                    if (f != null) {
                                      const FlutterSecureStorage storage =
                                          FlutterSecureStorage();
                                      setState(() {
                                        APIcalling = true;
                                      });
                                      final bytes =
                                          File(f!.path).readAsBytesSync();
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      var img64 = base64Encode(bytes);
                                      print("my base 64 is: $img64");
                                      //log(b64);

                                      final String? tempQueueID = await storage
                                          .read(key: 'tempQueueID');

                                      final APIStandardReturnFormat result =
                                          await APIServices()
                                              .updateUserQueueImage(
                                                  tempQueueID!, img64);
                                      AppRoutes.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              // ignore: prefer_const_constructors
                                              SnackBar(
                                                  content: Text(
                                                      'Queue created successfully'),
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 0, 165, 82),
                                                  duration: const Duration(
                                                      seconds: 2)));

                                      // widget.onStepSixDone();
                                      // AppRoutes.makeFirst(
                                      //     context, RecentQueues());

                                      // await Navigator.pushReplacement(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         const RecentQueues(),
                                      //   ),
                                      // );
                                    } else {
                                      setState(() {
                                        APIcalling = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              // ignore: prefer_const_constructors
                                              SnackBar(
                                                  content: Text(
                                                      'Please add Queue Image to continue'),
                                                  backgroundColor: Colors.red,
                                                  duration: const Duration(
                                                      seconds: 1)));
                                    }
                                  }),
                            )
                          ]),
                    )
                  ],
                ))),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>(
        'queueNameTxtController', queueNameTxtController));
  }
}
