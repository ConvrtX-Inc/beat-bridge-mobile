// ignore_for_file: always_specify_types

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/app_list.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Screen for register input
class ProfileSettigs extends StatefulWidget {
  /// Constructor
  const ProfileSettigs({Key? key}) : super(key: key);

  @override
  _ProfileSettigsState createState() => _ProfileSettigsState();
}

class _ProfileSettigsState extends State<ProfileSettigs> {
  /// use in profile settings screen

  String selectedAvatar = 'avatar1.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: SingleChildScrollView(
        child: _settingsUI(context),
      ),
    );
  }

  Widget _settingsUI(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 41.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(Icons.close, color: Colors.white, size: 15.w),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        SizedBox(height: 41.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppTextConstants.heyWelcome,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColorConstants.roseWhite,
                        fontSize: 14),
                  ),
                  Text(
                    'David',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColorConstants.lavender,
                      fontSize: 28,
                      fontFamily: AppTextConstants.gilroyBold,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => BsModal(
                          context: context,
                          dialog: BsModalDialog(
                            size: BsModalSize.sm,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            child: BsModalContent(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              children: [
                                const BsModalContainer(
                                    title: Text('Select Avatar'),
                                    closeButton: true),
                                BsModalContainer(
                                  child: SizedBox(
                                    height: 49.h,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: AppListConstants()
                                          .avatarImages
                                          .length,
                                      itemBuilder:
                                          (BuildContext context, int index) =>
                                              IconButton(
                                        icon: Image.asset(
                                            '${AssetsPathConstants.assetsPNGPath}/${AppListConstants().avatarImages[index]}'),
                                        tooltip: 'Closes application',
                                        onPressed: () {
                                          setState(() {
                                            selectedAvatar = AppListConstants()
                                                .avatarImages[index];
                                          });
                                        },
                                      ),
                                      //         Container(
                                      //   margin: const EdgeInsets.all(20),
                                      //   height: 49.h,
                                      //   width: 49.w,
                                      //   decoration: const BoxDecoration(
                                      //     image: DecorationImage(
                                      //       image: AssetImage(
                                      //           '${AssetsPathConstants.assetsPNGPath}/settings_avatar.png'),
                                      //       fit: BoxFit.cover,
                                      //     ),
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                child: Container(
                  height: 49.h,
                  width: 49.w,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          '${AssetsPathConstants.assetsPNGPath}/avatar_border.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      '${AssetsPathConstants.assetsPNGPath}/$selectedAvatar',
                      height: 27.h,
                      width: 27.w,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 15.h),
        Column(
          children: List<Widget>.generate(
              AppListConstants().profileSettings.length, (int index) {
            return Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    if(AppListConstants().profileSettings[index].routePath !=''){
                      Navigator.pushNamed(context,
                          AppListConstants().profileSettings[index].routePath);
                    }

                  },
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      child: ListTile(
                        leading: Container(
                          height: 18.h,
                          width: 18.w,
                          transform: Matrix4.translationValues(0, 2, 0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              // AppListConstants.profileSettingsIcons[index]
                              image: AssetImage(
                                  '${AssetsPathConstants.assetsPNGPath}/${AppListConstants().profileSettings[index].icon}'),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        title: Text(
                          AppListConstants().profileSettings[index].name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColorConstants.roseWhite,
                              fontSize: 14),
                        ),
                        trailing: Icon(Icons.chevron_right,
                            color: Colors.white, size: 15.w),
                      )),
                ),
                if (index < AppListConstants().profileSettingsIcons.length - 1)
                  const Divider(
                    color: Colors.white,
                  )
              ],
            );
          }),
        ),
      ],
    );
  }
}
