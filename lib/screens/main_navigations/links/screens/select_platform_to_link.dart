import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/music_platform_model.dart';
import 'package:beatbridge/screens/main_navigations/make_queues/screens/make_queue_screen.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Screen for link landing page
class SelectPlatformToLink extends StatefulWidget {
  /// Constructor
  const SelectPlatformToLink({Key? key, this.name = 'David'}) : super(key: key);

  /// Name of the logged in user
  final String name;

  @override
  State<SelectPlatformToLink> createState() => _SelectPlatformToLinkState();
}

class _SelectPlatformToLinkState extends State<SelectPlatformToLink> {
  final List<MusicPlatformModel> musicPlatforms =
      StaticDataService.getMusicPlatformModel();

  int selectedPlatform = -1;

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
                  SizedBox(height: 80.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 11.w),
                    child: Text(
                      AppTextConstants.success.toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 4,
                          fontSize: 12.sp),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 11.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.linkYourMusic}',
                          width: 247.w,
                          height: 48.h,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          AppTextConstants.selectMusicProfile,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18.sp,
                              color: Colors.white,
                              height: 1.5,
                              letterSpacing: 2),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 40.h,
                              ),
                              Column(
                                  children: musicPlatforms.map((p) {
                                return _musicPlatformItems(context, p.index);
                              }).toList()),
                            ]),
                      ],
                    ),
                  )
                ],
              ),
            ),
            ButtonRoundedGradient(
              buttonText: AppTextConstants.submit.toUpperCase(),
              buttonCallback: () async {},
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
                  ),
                ),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _musicPlatformItems(BuildContext context, int index) {
    return Column(children: <Widget>[
      GestureDetector(
        onTap: () {
          setState(() {
            selectedPlatform = index;
          });
        },
        child: Padding(
          padding: EdgeInsets.only(
            top: 20.h,
            bottom: 20.h,
          ),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 5.w, right: 20.w),
                width: 34.w,
                height: 34.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(musicPlatforms[index].logoImagePath),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  musicPlatforms[index].name,
                  style: TextStyle(
                      color: AppColorConstants.roseWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    if (musicPlatforms[index].name ==
                        AppTextConstants.addYourOwn)
                      Transform.scale(
                        scale: 1.5,
                        child: Icon(
                          Icons.create_new_folder_outlined,
                          color: AppColorConstants.roseWhite,
                        ),
                      )
                    else
                      selectedPlatform == index
                          ? Icon(
                              Icons.check,
                              color: AppColorConstants.roseWhite,
                            )
                          : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      if (index < musicPlatforms.length - 1)
        Divider(
          color: AppColorConstants.paleSky,
        )
    ]);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('name', widget.name));
  }
}
