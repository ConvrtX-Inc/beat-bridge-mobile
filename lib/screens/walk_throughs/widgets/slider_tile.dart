import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/widgets/images/static_image_background.dart';
import 'package:flutter/foundation.dart';
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
    this.isLogin = false,
  }) : super(key: key);

  /// index and additional height
  final int index;

  /// Strings for path and images
  final String backgroundImagePath,
      logoImagePath,
      topHeaderText,
      bottomHeaderText,
      headerImagePath,
      buttonText;

  /// Check if is for login
  final bool isLogin;
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
                    SizedBox(height: isLogin ? 142.h : 126.h),
                    if (isLogin)
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/login_input');
                        },
                        child: Center(
                          child: RichText(
                              text: TextSpan(
                            text: AppTextConstants.alreadyAMember.toUpperCase(),
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1,
                                fontFamily: 'Gilroy'),
                            children: [
                              TextSpan(
                                text:
                                    ' ${AppTextConstants.logIn.toUpperCase()}',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    decoration: TextDecoration.underline,
                                    letterSpacing: 1.4,
                                    fontFamily: 'Gilroy'),
                              ),
                            ],
                          )),
                        ),
                      ),
                  ]),
              Positioned(top: 72, left: 0, child: Image.asset(logoImagePath)),
            ],
          )),
      imagePath: backgroundImagePath,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('index', index));
    properties.add(StringProperty('backgroundImagePath', backgroundImagePath));
    properties.add(StringProperty('logoImagePath', logoImagePath));
    properties.add(StringProperty('topHeaderText', topHeaderText));
    properties.add(StringProperty('bottomHeaderText', bottomHeaderText));
    properties.add(StringProperty('headerImagePath', headerImagePath));
    properties.add(StringProperty('buttonText', buttonText));
    properties.add(DiagnosticsProperty<bool>('isLogin', isLogin));
  }
}
