import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/recently_played_model.dart';
import 'package:beatbridge/screens/main_navigations/make_queues/screens/make_queue_screen.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///Step Three
class StepThree extends StatefulWidget {
  ///Constructor
  const StepThree({required this.onStepThreeDone, Key? key}) : super(key: key);

  ///Callback
  final void Function() onStepThreeDone;

  @override
  _StepThreeState createState() => _StepThreeState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<void Function()>.has(
        'onStepThreeDone', onStepThreeDone));
  }
}

class _StepThreeState extends State<StepThree> {
  final List<RecentlyPlayedModel> recentlyPlayedItems =
      StaticDataService.getRecentlyPlayedMockData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorConstants.mirage,
        resizeToAvoidBottomInset: false,
        body: Stack(children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 11.w),
                          child: Column(children: <Widget>[
                            Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('${AppTextConstants.letsAddMusic}:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColorConstants.roseWhite,
                                          fontSize: 22)),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 6.w),
                                      child: Image.asset(
                                        MakeYourQueueScreen.of(context)
                                            .selectedPlatform
                                            .logoImagePath,
                                        height: 24,
                                        width: 24,
                                      )),
                                  Text(
                                      MakeYourQueueScreen.of(context)
                                          .selectedPlatform
                                          .name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColorConstants.roseWhite,
                                          fontSize: 22)),
                                ]),
                            SizedBox(height: 26.h),
                            Divider(color: AppColorConstants.paleSky),
                            SizedBox(height: 26.h),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(AppTextConstants.recentlyPlayed,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColorConstants.roseWhite
                                              .withOpacity(0.7),
                                          fontSize: 22)),
                                  TextButton(
                                      onPressed: () {},
                                      child: Text(AppTextConstants.seeAll,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  AppColorConstants.roseWhite,
                                              fontSize: 13)))
                                ]),
                          ])),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ))),
              Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 27.w),
                      itemCount: recentlyPlayedItems.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext ctx, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            buildRecentlyPlayedItem(context, index),
                          ],
                        );
                      })),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 27.w, vertical: 16.h),
                    child: ButtonRoundedGradient(
                      buttonText: AppTextConstants.continueTxt,
                      buttonCallback: () {
                        widget.onStepThreeDone();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ]));
  }

  Widget buildRecentlyPlayedItem(BuildContext context, int index) {
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

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      SizedBox(height: 24.h),
      Row(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
              child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image:
                            AssetImage(recentlyPlayedItems[index].songImageUrl),
                        fit: BoxFit.fitHeight,
                      )),
                  child: Align(
                      child: Image.asset(
                          '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}')))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(recentlyPlayedItems[index].songTitle,
                  style: TextStyle(
                      color: AppColorConstants.roseWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 17)),
              SizedBox(height: 8.h),
              Text(recentlyPlayedItems[index].artistName,
                  style:
                      TextStyle(color: AppColorConstants.paleSky, fontSize: 13))
            ],
          ),
          const Spacer(),
          Transform.scale(
              scale: 1.5,
              child: Checkbox(
                  value: recentlyPlayedItems[index].isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      recentlyPlayedItems[index].isSelected = value!;
                    });
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
                      borderRadius: BorderRadius.circular(5))))
        ],
      )
    ]);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<RecentlyPlayedModel>('recentlyPlayedItems', recentlyPlayedItems));
  }
}