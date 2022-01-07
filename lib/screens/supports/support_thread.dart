import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/support_thread_model.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///Support Thread Screen
class SupportThreadScreen extends StatefulWidget {
  ///Constructor
  const SupportThreadScreen({Key? key}) : super(key: key);

  @override
  _SupportThreadScreenState createState() => _SupportThreadScreenState();
}

class _SupportThreadScreenState extends State<SupportThreadScreen> {
  List<SupportThreadModel> supportThreadList =
      StaticDataService.getSupportMessageThread();

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
                  AppTextConstants.support,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColorConstants.roseWhite,
                      fontSize: 30.sp),
                ),
                SizedBox(height: 26.h),
                Expanded(child: buildSupportThreadListUI())
              ]),
        ));
  }

  Widget buildSupportThreadListUI() => ListView.builder(
      itemCount: supportThreadList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildMessageItem(index);
      });

  Widget buildMessageItem(int index) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: !supportThreadList[index].fromAdmin ?  ClipOval(
                child: Container(
                    color: AppColorConstants.silver,
                    padding: EdgeInsets.all(8.w),
                    child: Image.asset(
                      '${AssetsPathConstants.assetsPNGPath}/avatar1.png',
                      height: 30,
                    ))) : Image.asset('${AssetsPathConstants.assetsPNGPath}/app_logo_colored.png'),
            title: Text(supportThreadList[index].name,
                style: TextStyle(
                    color: AppColorConstants.roseWhite,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500)),
            subtitle: Text(supportThreadList[index].createdDate,
                style: TextStyle(
                    color: AppColorConstants.paleSky, fontSize: 14.sp)),
          ),
          SizedBox(height: 10.h),
          Text(supportThreadList[index].message,
              style: TextStyle(color: AppColorConstants.roseWhite)),
          SizedBox(height: 20.h)
        ],
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<SupportThreadModel>(
        'supportThreadList', supportThreadList));
  }
}
