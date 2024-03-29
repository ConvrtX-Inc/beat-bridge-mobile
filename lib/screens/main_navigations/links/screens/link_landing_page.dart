import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../../../../utils/logout_helper.dart';

/// Screen for link landing page
class LinkLandingPageScreen extends StatefulWidget {
  
  /// Constructor
 const  LinkLandingPageScreen({Key? key, this.name = 'Shariq'})
      : super(key: key);

  /// Name of the logged in user
  final String name;

  @override
  State<LinkLandingPageScreen> createState() => _LinkLandingPageScreenState();
}

class _LinkLandingPageScreenState extends State<LinkLandingPageScreen> {

String? userName;
@override
void initState() {
  super.initState();
  nameGetting();
}
var Name;
nameGetting()async{
final SharedPreferences pref = await SharedPreferences.getInstance();
     Name = pref.getString('username');      
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: <Widget>[
              
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 41.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(Icons.arrow_back_ios,
                          color: AppColorConstants.mirage, size: 15.w),
                      onPressed: () {
                        // Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(height: 122.h),
                  Center(
                    child: Image.asset(
                      '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.linkLandingPageHeaderImage}',
                      width: 221.w,
                      height: 142.h,
                      fit: BoxFit.cover,
                      //git commit is here
                    ),
                  ),
                  SizedBox(height: 33.h),
                  Center(
                      child: Text(
                    "${AppTextConstants.hey}  ${Global.username}!".toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: Colors.white,
                        letterSpacing: 5,
                        fontFamily: AppTextConstants.gilroyBold),
                  )),
                  SizedBox(height: 12.h),
                  Center(
                    child: Image.asset(
                      '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.linkLandingPageSuccessImage}',
                      width: 133.w,
                      height: 48.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Center(
                      child: Text(
                    AppTextConstants.accountHasBeenCreated,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18.sp,
                        color: Colors.white,
                        height: 1.5,
                        fontFamily: 'Gilory',
                        letterSpacing: 1),
                  )),
                ],
              ),
            ),
            ButtonRoundedGradient(
              buttonText: AppTextConstants.linkMyMusic.toUpperCase(),
              buttonCallback: ()  {
                Navigator.of(context).pushNamed('/select_platform');
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 26.h),
              child: TextButton(
                child: Text(
                  AppTextConstants.skipForNow,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: 'Gilory'
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/recent_queues');
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('name', widget.name));
  }
}
