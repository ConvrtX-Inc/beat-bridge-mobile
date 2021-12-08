import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///Step One
class StepOne extends StatefulWidget {
  ///Constructor
  const StepOne({required this.onStepOneDone,Key? key}) : super(key: key);
  ///Callback
  final void Function(String queueName) onStepOneDone;

  @override
  _StepOneState createState() => _StepOneState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<void Function(String queueName)>.has('onStepOneDone', onStepOneDone));
  }
}

class _StepOneState extends State<StepOne> {

  final TextEditingController queueNameTxtController =  TextEditingController();

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
      body:
      SingleChildScrollView(child:Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child:
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 11.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(AppTextConstants.enterYourQueueName,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColorConstants.roseWhite,
                              fontSize: 22)),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextField(

                        controller: queueNameTxtController,
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
                        style:TextStyle(color: AppColorConstants.roseWhite),
                      ),
                      SizedBox(height: 60.h),
                      ButtonRoundedGradient(
                        buttonText: AppTextConstants.continueTxt,
                        buttonCallback: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          widget.onStepOneDone(queueNameTxtController.text);
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
    properties.add(DiagnosticsProperty<TextEditingController>('queueNameTxtController', queueNameTxtController));
  }
}
