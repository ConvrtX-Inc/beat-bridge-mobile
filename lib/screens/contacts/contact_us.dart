import 'package:beatbridge/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

///Contact Screen
class ContactUsScreen extends StatefulWidget {
  ///Constructor
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorConstants.mirage,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 41.h),
                IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColorConstants.roseWhite,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                SizedBox(height: 26.h),
                Text(
                  AppTextConstants.contactUs,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColorConstants.roseWhite,
                      fontSize: 30.sp),
                ),
                SizedBox(height: 20.h),
                buildContactItem(
                    title: AppTextConstants.emailUs,
                    contactDetail: AppContactDetails.email,
                    callBack: () {
                      launch('mailto:${AppContactDetails.email}');
                    }),
                buildContactItem(
                    title: AppTextConstants.callUs,
                    icon: const Icon(Icons.phone_outlined),
                    contactDetail: AppContactDetails.phoneNumber,
                    callBack: () {
                      launch('tel:+${AppContactDetails.phoneNumber}');
                    })
              ]),
        ));
  }

  Widget buildContactItem(
          {Icon icon = const Icon(Icons.email_outlined),
          String title = '',
          String contactDetail = '',
          VoidCallback? callBack}) =>
      ListTile(
        leading: icon,
        iconColor: Colors.white,
        title: Text(title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        subtitle: Text(contactDetail),
        textColor: Colors.white,
        onTap: callBack,
      );
}
