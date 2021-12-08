import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/models/people_model.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///Step four
class StepFour extends StatefulWidget {
  ///Constructor
  const StepFour({required this.onStepFourDone, Key? key}) : super(key: key);

  ///Callback for step four
  final void Function() onStepFourDone;

  @override
  _StepFourState createState() => _StepFourState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<void Function()>.has(
        'onStepFourDone', onStepFourDone));
  }
}

class _StepFourState extends State<StepFour> {
  final List<PeopleModel> peopleList = StaticDataService.getPeopleListMockData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorConstants.mirage,
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
                            Text(AppTextConstants.addFriends,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColorConstants.roseWhite,
                                    fontSize: 22)),
                            SizedBox(height: 26.h),
                          ])),
                    ],
                  ))),
              Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 27.w),
                      itemCount: peopleList.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            buildPeopleItem(context, index),
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
                        widget.onStepFourDone();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ]));
  }

  Widget buildPeopleItem(BuildContext context, int index) {
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
      SizedBox(height: 22.h),
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
                      image: AssetImage(peopleList[index].profileImageUrl),
                          fit: BoxFit.fitHeight,
                        )),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(peopleList[index].name,
                  style: TextStyle(
                          color: AppColorConstants.roseWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  SizedBox(height: 6.h),
                  Text('${peopleList[index].totalTrackCount} Tracks',
                      style: TextStyle(
                          color: AppColorConstants.paleSky, fontSize: 13)),
                  buildMusicPlatformsUsedRow(context, index)
                ],
              ),
              const Spacer(),
              Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                      value: peopleList[index].isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          peopleList[index].isSelected = value!;
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
      ),
      if (peopleList[index].isSelected)
        buildMakeAdminButton(context)
        ]);
  }

  Widget buildMusicPlatformsUsedRow(BuildContext context, int index) {
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          for (int i = 0; i < peopleList[index].musicPlatformsUsed.length; i++)
            Image(
                image: AssetImage(
                    peopleList[index].musicPlatformsUsed[i].logoImageUrl),
                height: 20,
                width: 20),
          SizedBox(width: 6.w)
        ],
      )
    ]);
  }

  Widget buildMakeAdminButton(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 14, 0, 0),
        height: 36,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          autofocus: true,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(166, 70, 255, 0.29)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                        color: AppColorConstants.artyClickPurple, width: 1.5)),
              )),
          child: Text(AppTextConstants.makeAdmin,
              style: TextStyle(
                  color: AppColorConstants.roseWhite,
                  fontWeight: FontWeight.bold)),
        ));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<PeopleModel>('peopleList', peopleList));
  }
}
