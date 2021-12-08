import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/models/music_platform_model.dart';
import 'package:beatbridge/screens/main_navigations/make_queues/widgets/step_five.dart';
import 'package:beatbridge/screens/main_navigations/make_queues/widgets/step_four.dart';
import 'package:beatbridge/screens/main_navigations/make_queues/widgets/step_one.dart';
import 'package:beatbridge/screens/main_navigations/make_queues/widgets/step_three.dart';
import 'package:beatbridge/screens/main_navigations/make_queues/widgets/step_two.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///Make your queue
class MakeYourQueueScreen extends StatefulWidget {
  ///Constructor
  const MakeYourQueueScreen({Key? key}) : super(key: key);

  /// allow child widgets to access variables
  static _MakeYourQueueScreenState of(BuildContext context) {
    return context.findAncestorStateOfType<_MakeYourQueueScreenState>()!;
  }

  @override
  _MakeYourQueueScreenState createState() => _MakeYourQueueScreenState();
}

class _MakeYourQueueScreenState extends State<MakeYourQueueScreen> {
  int currentIndex = 0;
  int currentStep = 1;
  int finalStep = 5;
  String queueName = '';
  MusicPlatformModel selectedPlatform = MusicPlatformModel();
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 41.h),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 11.w),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 15.w),
                      onPressed: navigateBack,
                    )),
                SizedBox(height: 26.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 27.w),
                  child: Text(
                    AppTextConstants.makeYourQueue,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColorConstants.roseWhite,
                        fontSize: 30),
                  ),
                ),
                SizedBox(height: 45.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 27.w),
                  child: Text(
                    'STEP $currentStep/$finalStep',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColorConstants.roseWhite.withOpacity(0.64),
                        letterSpacing: 4),
                  ),
                ),
                SizedBox(height: 8.h),
              ]),
          Expanded(
            child: PageView(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int val) {
                setState(() {
                  currentIndex = val;
                });
              },
              children: <Widget>[
                StepOne(onStepOneDone: onStepOneComplete),
                StepTwo(onStepTwoDone: onStepTwoComplete),
                StepThree(onStepThreeDone: onStepThreeComplete),
                StepFour(onStepFourDone: onStepFourComplete),
                StepFive(onStepFiveDone: onStepFourComplete)
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// function to call when step one is completed
  void onStepOneComplete(String queueName) {
    switchPage();
  }

  /// function to call when step two is completed
  void onStepTwoComplete() {
    switchPage();
  }

  /// function to call when step three is completed
  void onStepThreeComplete() {
    switchPage();
  }

  /// function to call when step four is completed
  void onStepFourComplete() {
    switchPage();
  }

  ///function for switching between pages
  void switchPage() {
    setState(() {
      if (currentStep < finalStep) {
        currentStep++;
      }
    });
    controller.animateToPage(currentIndex + 1,
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  ///function when pressing back icon and navigating back
  void navigateBack() {
    setState(() {
      if (currentStep > 1) {
        currentStep--;
      }
    });
    controller.animateToPage(currentIndex - 1,
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('currentIndex', currentIndex))
      ..add(IntProperty('currentStep', currentStep))
      ..add(IntProperty('finalStep', finalStep))
      ..add(StringProperty('queueName', queueName))
      ..add(DiagnosticsProperty<MusicPlatformModel>(
          'selectedPlatform', selectedPlatform))
      ..add(DiagnosticsProperty<PageController>('controller', controller));
  }
}
