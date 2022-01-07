import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/support_model.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///Support Screen
class SupportScreen extends StatefulWidget {
  ///Constructor
  const SupportScreen({Key? key}) : super(key: key);

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final List<SupportModel> supportMessageList =
      StaticDataService.getSupportMessages();

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
                Expanded(child: buildSupportMessageList()),
                ButtonRoundedGradient(
                    buttonText: AppTextConstants.createNewTicket, buttonCallback: (){
                      Navigator.pushNamed(context, '/create-ticket');
                }),
                SizedBox(height: 26.h),
              ]),
        ));
  }

  Widget buildSupportMessageList() => ListView.builder(
      itemCount: supportMessageList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildSupportMessageItem(index);
      });

  Widget buildSupportMessageItem(int index) => Column(children: <Widget>[
        InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/support-thread');
            },
            child: Container(
                decoration: BoxDecoration(
                    color: AppColorConstants.violet,
                    borderRadius: BorderRadius.all(Radius.circular(16.r))),
                child: ListTile(
                  leading: Image.asset(
                    '${AssetsPathConstants.assetsPNGPath}/app_logo_colored.png',
                    height: 50,
                    width: 50,
                  ),
                  contentPadding: EdgeInsets.all(10.sp),
                  title: Text(supportMessageList[index].createdDate,
                      style: TextStyle(color: AppColorConstants.paleSky)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(supportMessageList[index].id,
                          style: TextStyle(
                              color: AppColorConstants.jasminePurple)),
                      Text(supportMessageList[index].message,
                          style: TextStyle(color: AppColorConstants.roseWhite))
                    ],
                  ),
                  trailing: Text(supportMessageList[index].status,
                      style: TextStyle(
                          color: supportMessageList[index].status == 'Completed'
                              ? AppColorConstants.appleGreen
                              : AppColorConstants.neonCarrot)),
                ))),
        SizedBox(height: 10.h)
      ]);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<SupportModel>(
        'supportMessageList', supportMessageList));
  }
}
