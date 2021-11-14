import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/widgets/images/static_image_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Widget for walk through slider
class SliderTile extends StatelessWidget {
  /// Constructor
  const SliderTile({
    Key? key,
    this.index = 0,
    this.backgroundImagePath = '',
    this.logoImagePath = '',
    this.topHeaderText = '',
    this.bottomHeaderText = '',
    this.headerImagePath = '',
    this.buttonText = '',
  }) : super(key: key);

  final int index;
  final String backgroundImagePath,
      logoImagePath,
      topHeaderText,
      bottomHeaderText,
      headerImagePath,
      buttonText;

  @override
  Widget build(BuildContext context) {
    return ImageStaticBackground(
      childWidget: Container(
          padding: EdgeInsets.fromLTRB(29.w, 0.h, 29.w, 79.h),
          child: Stack(
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 24.h),
                    Text(
                      AppTextConstants.hassleFree.toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 5,
                          fontSize: 12),
                    ),
                    SizedBox(height: 24.h),
                    Image.asset(headerImagePath),
                    SizedBox(height: 37.h),
                    Text(
                      AppTextConstants.oneDeviceMillionSongs,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                    SizedBox(height: 126.h),
                  ]),
              Positioned(top: 72, left: 0, child: Image.asset(logoImagePath)),
            ],
          )),
      imagePath: backgroundImagePath,
    );
  }
}
