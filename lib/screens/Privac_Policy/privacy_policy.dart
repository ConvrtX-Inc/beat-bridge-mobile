import 'package:beatbridge/helpers/basehelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_constants.dart';

class PrivacyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PrivacyScreen();
  }
}

class _PrivacyScreen extends State<PrivacyScreen> {
  var text = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BaseHelper().getPrivacyPolicy(context).then((value) {
      print("privacy policy response: $value");
      setState(() {
        text = value['description'].toString();
        print("sadasda: $text");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorConstants.mirage,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 27.w),
          child: text == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                      SizedBox(height: 41.h),
                      IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: AppColorConstants.roseWhite,
                            size: 15.w,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      SizedBox(height: 26.h),
                      Text(
                        AppTextConstants.policy,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColorConstants.roseWhite,
                            fontFamily: 'Gilroy-Bold',
                            fontSize: 22.sp),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "$text",
                        style: TextStyle(
                            color: AppColorConstants.roseWhite,
                            fontSize: 14,
                            wordSpacing: 3),
                      ),
                    ]),
        ));
  }
}
