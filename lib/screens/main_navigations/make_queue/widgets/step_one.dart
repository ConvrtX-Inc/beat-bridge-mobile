import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepOne extends StatefulWidget {
  const StepOne({Key? key, required this.onStepOneDone}) : super(key: key);
  final void Function() onStepOneDone;

  @override
  _StepOneState createState() => _StepOneState();
}

class _StepOneState extends State<StepOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 41.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios,
                      color: Colors.white, size: 15.w),
                  onPressed: () {},
                ),
              ),
              SizedBox(height: 26.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 11.w),
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
                padding: EdgeInsets.symmetric(horizontal: 11.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'STEP 1/5',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                AppColorConstants.roseWhite.withOpacity(0.64),
                            letterSpacing: 4),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(AppTextConstants.enterYourQueueName,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColorConstants.roseWhite,
                              fontSize: 22)),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            hintText: AppTextConstants.egBeatBridgeFavorite,
                            hintStyle: TextStyle(
                              color:
                                  AppColorConstants.roseWhite.withOpacity(0.55),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColorConstants.roseWhite
                                        .withOpacity(0.55)))),
                      ),
                      SizedBox(height: 60.h),
                      ButtonRoundedGradient(
                        buttonText: AppTextConstants.continueTxt,
                        buttonCallback: () {
                          widget.onStepOneDone();
                        },
                      )
                    ]),
              )
            ],
          )),
    );
  }
}
