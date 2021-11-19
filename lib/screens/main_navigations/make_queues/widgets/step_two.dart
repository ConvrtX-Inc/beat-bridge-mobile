import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/models/music_platform_model.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepTwo extends StatefulWidget {
  const StepTwo({Key? key, required this.onStepTwoDone}) : super(key: key);
  final void Function() onStepTwoDone;

  @override
  _StepTwoState createState() => _StepTwoState();
}

class _StepTwoState extends State<StepTwo> {

  final List<MusicPlatformModel> musicPlatforms =
      StaticDataService.getMusicPlatformModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorConstants.mirage,
        body: SingleChildScrollView( child: Stack(children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 11.w),
                          child: Text(AppTextConstants.letsAddMusic,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColorConstants.roseWhite,
                                  fontSize: 22)),
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                      ],
                    )),
                Column(
                    children: musicPlatforms.map((p) {
                  return _musicPlatformItems(context, p.index);
                }).toList()),

                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 27.w, vertical: 16.h),
                  child: ButtonRoundedGradient(
                    buttonText: AppTextConstants.continueTxt,
                    buttonCallback: () {
                      widget.onStepTwoDone();
                    },
                  ),
                ),
              ]),
        ])));
  }

  Widget _musicPlatformItems(BuildContext context, int index) {
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

    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          Expanded(
              flex: 3,
              child: Container(
                  padding: EdgeInsets.all(20.h),
                  child: Image.asset(
                    '${musicPlatforms[index].logoImagePath}',
                    width: 34,
                    height: 34,
                  ))),
          Expanded(
              flex: 3,
              child: Container(
                  child: Text(
                '${musicPlatforms[index].name}',
                style: TextStyle(
                    color: AppColorConstants.roseWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ))),
          Expanded(
              flex: 3,
              child: Container(
                  child: Column(
                children: <Widget>[
                  if (musicPlatforms[index].name == AppTextConstants.addYourOwn)
                    Transform.scale(
                        scale: 1.5,
                        child: Icon(
                          Icons.create_new_folder_outlined,
                          color: AppColorConstants.roseWhite,
                        ))
                  else
                    Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                            value: musicPlatforms[index].isSelected,
                            onChanged: (bool? value) {},
                            checkColor: AppColorConstants.rubberDuckyYellow,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            side: MaterialStateBorderSide.resolveWith(
                              (states) => BorderSide(
                                width: 1.0,
                                color: AppColorConstants.paleSky,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))))
                ],
              ))),
        ],
      ),
      if(index < musicPlatforms.length-1)
        Divider(
          color: AppColorConstants.paleSky,
        )
    ]);
  }
}
