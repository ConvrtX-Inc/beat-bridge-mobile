// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// //import 'dart:html';

// import 'package:beatbridge/constants/app_constants.dart';
// import 'package:beatbridge/models/apis/api_standard_return.dart';
// import 'package:beatbridge/utils/services/rest_api_service.dart';
// import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:image_picker/image_picker.dart';

// ///Step Six
// class StepSix extends StatefulWidget {
//   ///Constructor
//   const StepSix({required this.onStepSixDone, Key? key}) : super(key: key);

//   ///Callback
//   final void Function() onStepSixDone;
//   @override
//   _StepSixState createState() => _StepSixState();
//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(ObjectFlagProperty<void Function()>.has(
//         'onStepSixDone', onStepSixDone));
//   }
// }

// class _StepSixState extends State<StepSix> {
//   final TextEditingController queueNameTxtController = TextEditingController();

//   /// Variables
//   ImagePicker picker = ImagePicker();
//   XFile? image;
//   File? f = null;
//   @override
//   void dispose() {
//     // Clean up the controller when the widget is disposed.
//     queueNameTxtController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColorConstants.mirage,
//       body: SingleChildScrollView(
//           child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 11.w),
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           SizedBox(
//                             height: 100.h,
//                           ),
//                           InkWell(
//                             onTap: () async {
//                               log('Picker');
//                               image = await picker.pickImage(
//                                   source: ImageSource.gallery);
//                               setState(() {
//                                 f = File(image!.path);
//                               });

//                               //log(b64);
//                             },
//                             child: Center(
//                               child: f == null
//                                   ? Image.asset('assets/images/placeholder.png',
//                                       width: 194, height: 174)
//                                   : Image.file(f!, width: 194, height: 174),
//                             ),
//                           ),
                       
//                           SizedBox(height: 60.h),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 50),
//                             child: ButtonRoundedGradient(
//                                 buttonText: AppTextConstants.allDone,
//                                 buttonCallback: () async {
//                                   const FlutterSecureStorage storage =
//                                       FlutterSecureStorage();
//                                   final bytes = f!.readAsBytesSync();
//                                   final String b64 = base64Encode(bytes);
//                                   final String? tempQueueID =
//                                       await storage.read(key: 'tempQueueID');
//                                   final APIStandardReturnFormat result1 =
//                                       await APIServices().updateUserQueueImage(
//                                           tempQueueID!, b64);

                                
//                                 }),
//                           )
//                         ]),
//                   )
//                 ],
//               )
//               )
//               ),
//     );
//   }

//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(DiagnosticsProperty<TextEditingController>(
//         'queueNameTxtController', queueNameTxtController));
//   }
// }
