import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/screens/Privac_Policy/privacy_policy.dart';
import 'package:beatbridge/screens/Privac_Policy/terms.dart';
import 'package:beatbridge/utils/approutes.dart';
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
    this.customText = '',
    this.isLogin = false,
    this.isImage = true,
  }) : super(key: key);

  /// index and additional height
  final int index;

  /// Strings for path and images
  final String backgroundImagePath,
      logoImagePath,
      topHeaderText,
      bottomHeaderText,
      headerImagePath,
      customText,
      buttonText;

  /// Check if is for login
  final bool isLogin;
  final bool isImage;
  @override
  Widget build(BuildContext context) {
    return ImageStaticBackground(
      childWidget: Container(
          padding: EdgeInsets.fromLTRB(29.w, 0.h, 29.w, 20.h),
          child: Stack(
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 16.h),
                    Text(
                      topHeaderText,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 5,
                          fontSize: 12),
                    ),
                    SizedBox(height: 24.h),
                    if (isImage)
                      Image.asset(
                        headerImagePath,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .45,
                      ),
                    SizedBox(height: 37.h),
                    Text(
                      bottomHeaderText,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                    Text(customText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColorConstants.roseWhite,
                            fontFamily: 'Gilory-Bold',
                            fontSize: 22)),
                    SizedBox(height: isLogin ? 142.h : 126.h),
                    if (isLogin)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                AppTextConstants.alreadyAMember.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 1,
                                    fontFamily: 'Gilroy'),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('/login_method');
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text:
                                        ' ${AppTextConstants.logIn.toUpperCase()}',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        letterSpacing: 1.4,
                                        fontFamily: 'Gilroy'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isLogin ? 40.h : 0),
                          Text(
                            AppTextConstants.createAccountLogin,
                            style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Gilroy-Medium'),
                          ),
                          SizedBox(height: isLogin ? 5.h : 0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  AppRoutes.push(context, terms());
                                },
                                child: Text(
                                  AppTextConstants.terms,
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Gilroy-Medium'),
                                ),
                              ),
                              Text(
                                ' ,and ',
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Gilroy-Medium'),
                              ),
                              InkWell(
                                onTap: () {
                                  AppRoutes.push(context, PrivacyScreen());
                                },
                                child: Text(
                                  AppTextConstants.policy,
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Gilroy-Medium'),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                  ]),
              Positioned(
                  top: MediaQuery.of(context).size.height * .03,
                  left: 0,
                  child: Image.asset(logoImagePath)),
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
    properties.add(DiagnosticsProperty<bool>('isLogin', isImage));
  }
}
