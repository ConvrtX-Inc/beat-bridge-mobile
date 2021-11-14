import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/models/walk_through_model.dart';
import 'package:beatbridge/screens/walk_throughs/widgets/slider_paginator.dart';
import 'package:beatbridge/screens/walk_throughs/widgets/slider_tile.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Screen for walk through
class WalkThroughScreen extends StatefulWidget {
  /// Constructor
  const WalkThroughScreen({Key? key}) : super(key: key);

  @override
  _WalkThroughScreenState createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  final List<WalkThroughModel> walkThroughData =
      StaticDataService.getMockedDataWalkThrough();
  PageController sliderController = PageController();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.midnightPurple,
      body: Stack(
        children: <Widget>[
          PageView.builder(
            itemCount: walkThroughData.length,
            controller: sliderController,
            onPageChanged: (int val) {
              setState(() {
                currentIndex = val;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return SliderTile(
                backgroundImagePath: walkThroughData[index].backgroundImagePath,
                logoImagePath: walkThroughData[index].logoImagePath,
                topHeaderText: walkThroughData[index].topHeaderText,
                bottomHeaderText: walkThroughData[index].bottomHeaderText,
                headerImagePath: walkThroughData[index].headerImagePath,
              );
            },
          ),
          Positioned(
            top: 113.h,
            right: 23.w,
            child: Row(
              children: <Widget>[
                for (int i = 0; i < walkThroughData.length; i++)
                  currentIndex == i
                      ? const SliderPaginator(isCurrentPage: true)
                      : const SliderPaginator()
              ],
            ),
          ),
          Positioned(
            bottom: 79.h,
            right: 23.w,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 58,
              child: ButtonAppRoundedButton(
                buttonText: currentIndex == walkThroughData.length - 1
                    ? AppTextConstants.getStarted
                    : AppTextConstants.next,
                buttonCallback: () {
                  if (currentIndex == walkThroughData.length - 1) {
                    Navigator.of(context).pushNamed('/login');
                  } else {
                    sliderController.animateToPage(currentIndex + 1,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.linear);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        IterableProperty<WalkThroughModel>('walkThroughData', walkThroughData));
    properties.add(IntProperty('currentIndex', currentIndex));
    properties.add(DiagnosticsProperty<PageController>(
        'sliderController', sliderController));
  }
}
