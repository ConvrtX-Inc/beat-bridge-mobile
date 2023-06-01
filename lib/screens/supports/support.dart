import 'dart:convert';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/helpers/basehelper.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/support/support_model.dart';
import 'package:beatbridge/models/support_model.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/screens/supports/create_ticket.dart';
import 'package:beatbridge/utils/approutes.dart';
import 'package:beatbridge/utils/helpers/text_helper.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../constants/api_path.dart';
import '../../constants/constantsclass.dart';

///Support Screen
class SupportScreen extends StatefulWidget {
  ///Constructor
  const SupportScreen({Key? key}) : super(key: key);

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  // final List<SupportModel> supportMessageList =
  //     StaticDataService.getSupportMessages();

  List<SupportListModel> supportList = <SupportListModel>[];
  bool hasError = false;

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
                Expanded(child: buildSupportUI()),
                ButtonRoundedGradient(
                    buttonText: AppTextConstants.createNewTicket,
                    buttonCallback: () {
                      AppRoutes.replace(context, CreateTicketScreen());
                      // Navigator.pushNamed(context, '/create-ticket');
                    }),
                SizedBox(height: 26.h),
              ]),
        ));
  }

  Widget buildSupportUI() => FutureBuilder<List<SupportListModel>>(
        future: getSupportList(),
        builder: (BuildContext context,
            AsyncSnapshot<List<SupportListModel>> snapshot) {
          print("snapshot data: ${snapshot.data}");
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.data != null) {
                supportList = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Text(
                    //   '${peopleList.length} ${AppTextConstants.friends}',
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.w700,
                    //       color: AppColorConstants.roseWhite,
                    //       letterSpacing: 2,
                    //       fontSize: 13.sp),
                    // ),
                    Expanded(child: buildSupportMessageList())
                  ],
                );
              } else {
                if (hasError) {
                  return TextHelper.anErrorOccurredTextDisplay();
                }
                return TextHelper.noAvailableDataTextDisplay();
              }
            case ConnectionState.active:
              {
                return TextHelper.stableTextDisplay('You are connected');
              }
            case ConnectionState.none:
              {
                return const SizedBox.shrink();
              }
          }

          // return Container();
        },
      );

  Widget buildSupportMessageList() => ListView.builder(
      itemCount: supportList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildSupportMessageItem(index);
      });

  Widget buildSupportMessageItem(int index) =>

      Column(
          children: <Widget>[
          InkWell(
            onTap: () {

              constTicketId = '${supportList[index].id}';
              constDescription = supportList[index].description.toString();
              status = '${supportList[index].status}';
              Navigator.pushNamed(context, '/support-thread',);
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
                  title: Text(
                      "${DateTime.parse(supportList[index].createdDate.toString()).day}/${DateTime.parse(supportList[index].createdDate.toString()).month}/${DateTime.parse(supportList[index].createdDate.toString()).year}",
                      style: TextStyle(color: AppColorConstants.paleSky)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("${supportList[index].id!.substring(0,8)}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: AppColorConstants.jasminePurple)),
                      Text(supportList[index].description.toString(),
                          style: TextStyle(color: AppColorConstants.roseWhite))
                    ],
                  ),
                  trailing: supportList[index].status == 'approved' ? Text("completed",
                      style: TextStyle(
                          color: AppColorConstants.appleGreen),
                  ) : Text('${supportList[index].status}',
                  style: TextStyle(
                      color : AppColorConstants.neonCarrot
                  ),)


                ))),
        SizedBox(height: 10.h)
      ]);

  Future<List<SupportListModel>> getSupportList() async {
    var result = await BaseHelper().getSupport(context);
    final List<SupportListModel> supportList = <SupportListModel>[];
    print("return response of support list: $result");
    // final dynamic jsonData = jsonDecode(result);
    for (final dynamic res in result) {
      print("the status of support: ${result[0]['status']}");
      final SupportListModel support = SupportListModel.fromJson(res);

      supportList.add(SupportListModel(
          id: support.id,
          userId: support.userId,
          adminId: support.adminId,
          status: support.status,
          subject: support.subject,
          description: support.description,
          createdDate: support.createdDate));
    }
    return supportList;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // properties.add(IterableProperty<SupportModel>(
    //     'supportMessageList', supportMessageList));
  }
}
