import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/app_list.dart';
import 'package:beatbridge/models/settings_model.dart';
import 'package:beatbridge/screens/Privac_Policy/privacy_policy.dart';
import 'package:beatbridge/screens/Privac_Policy/terms.dart';
import 'package:beatbridge/utils/approutes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///System setting Screen
class SystemSettingScreen extends StatefulWidget {
  ///Constructor
  const SystemSettingScreen({Key? key}) : super(key: key);

  @override
  _SystemSettingScreenState createState() => _SystemSettingScreenState();
}

class _SystemSettingScreenState extends State<SystemSettingScreen> {
  final List<SystemSettingsModel> systemSettings =
      AppListConstants().systemSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
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
                        AppTextConstants.settings,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColorConstants.roseWhite,
                            fontSize: 30.sp),
                      ),
                      SizedBox(height: 20.h),
                    ])),
            Expanded(child: buildSystemSettingList())
          ]),
    );
  }

  Widget buildSystemSettingList() => ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(
            color: AppColorConstants.paleSky,
          ),
      itemCount: systemSettings.length,
      itemBuilder: (BuildContext ctx, int index) {
        return Padding(
            padding: EdgeInsets.all(8.w),
            child: buildSystemSettingItem(systemSettings[index]));
      });

  Widget buildSystemSettingItem(SystemSettingsModel setting) => ListTile(
        leading: setting.icon,
        title: Text(
          setting.name,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17.sp),
        ),
        textColor: Colors.white,
        iconColor: Colors.white,
        onTap: () {
          if (setting.name.toString() == "Terms & Condition") {
            AppRoutes.push(context, terms());
          } else if (setting.name.toString() == "Privacy Policy") {
            AppRoutes.push(context, PrivacyScreen());
          } else {
            Navigator.pushNamed(context, setting.routePath);
          }
        },
        trailing: const Icon(Icons.arrow_forward_ios),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<SystemSettingsModel>(
        'systemSettings', systemSettings));
  }
}
