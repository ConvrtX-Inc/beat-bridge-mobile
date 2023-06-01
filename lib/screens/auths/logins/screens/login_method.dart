import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/screens/walk_throughs/widgets/slider_tile.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Screen for login
class LoginMethodScreen extends StatelessWidget {
  /// Constructor
  const LoginMethodScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.midnightPurple,
      body: 
      Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const <Widget>[
               Expanded(
                child: SliderTile(
                  isImage: false,
                  backgroundImagePath:
                      '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.walkThroughBackground1}',
                  logoImagePath:
                      '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.appLogoWhite}',
                      
                ),
              ),
             
            ],
          ),
          if (GetPlatform.isIOS)
          Positioned(
            bottom: 210.h,
            right: 13.w,
            child:SizedBox(
               width: MediaQuery.of(context).size.width - 28,
              child: Text(
                'Login Using',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                           color: AppColorConstants.roseWhite,
                           fontFamily: 'Gilory-Bold',
                           fontSize: 22
                        )),
            ),
          ),
          if (GetPlatform.isIOS)
          Positioned(
            bottom: 130.h,
            right: 13.w,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 28,
              child: ButtonRoundedGradient(
                custom: true,
                fontSize: 17,
                fontFamily: 'Gilory-SemiBold',
                buttonColor: Color(0xFF8D14EA),
                buttonText: 'Email Address',
                buttonCallback: () {
                  
                   Navigator.of(context).pushNamed('/login_input_email');
                },
              ),
            ),
          ),
          if (GetPlatform.isAndroid)
          Positioned(
            // bottom: 250.h,
            // right: 13.w,
            bottom: 150.h,
            right: 13.w,
            child:SizedBox(
               width: MediaQuery.of(context).size.width - 28,
              child: Text(
                'Login Using',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                           color: AppColorConstants.roseWhite,
                           fontFamily: 'Gilory-Bold',
                           fontSize: 22
                        )),
            ),
          ),
          if (GetPlatform.isAndroid) 
          Positioned(
            // bottom: 150.h,
            // right: 13.w,
            bottom: 65.h,
            right: 13.w,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 28,
              child: ButtonRoundedGradient(
                custom: true,
                fontSize: 17,
                fontFamily: 'Gilory-SemiBold',
                buttonColor: Color(0xFF8D14EA),
                buttonText: 'Email Address',
                buttonCallback: () {
                  Navigator.of(context).pushNamed('/login_input_email');
                },
              ),
            ),
          ),
          // if (GetPlatform.isAndroid)
          // Positioned(
          //   bottom: 65.h,
          //   right: 13.w,
          //   child: SizedBox(
          //     width: MediaQuery.of(context).size.width - 28,
          //     child: ButtonRoundedGradient(
          //       custom: true,
          //       fontSize: 17,
          //       fontFamily: 'Gilory-SemiBold',
          //       buttonColor: Color(0xFFEAB22D),
          //       buttonText: 'Phone Number',
          //       buttonCallback: () {
          //         Navigator.of(context).pushNamed('/login_input');
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
