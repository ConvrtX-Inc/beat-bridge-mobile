import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/models/music_platform_model.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///Music Source Screen
class MusicSourceScreen extends StatefulWidget {
  ///Constructor
  const MusicSourceScreen({Key? key}) : super(key: key);

  @override
  _MusicSourceScreenState createState() => _MusicSourceScreenState();
}

class _MusicSourceScreenState extends State<MusicSourceScreen> {
  final List<MusicPlatformModel> musicPlatforms =
      StaticDataService.getMusicPlatformModel();

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
                  AppTextConstants.editMusicSource,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColorConstants.roseWhite,
                      fontSize: 30.sp),
                ),
                SizedBox(height: 36.h),
                for (int i = 0; i < musicPlatforms.length - 1; i++)
                  buildMusicSourceItem(i),
                SizedBox(height: 26.h),
               /* Center(
                    child: TextButton(
                  onPressed: () {},
                  child: Text(AppTextConstants.addMore,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: AppColorConstants.roseWhite)),
                ))*/
              ]),
        ));
  }

  Widget buildMusicSourceItem(int index) => Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Container(
                    padding: EdgeInsets.all(20.h),
                    child: Image.asset(
                      musicPlatforms[index].logoImagePath,
                      width: 34,
                      height: 34,
                    ))),
            Expanded(
                flex: 3,
                child: Text(
                  musicPlatforms[index].name,
                  style: TextStyle(
                      color: AppColorConstants.roseWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                )),
            Expanded(
                // flex: 3,
                child: Transform.scale(
                    scale: 1.5,
                    child:   Checkbox(
                        value: musicPlatforms[index].isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            musicPlatforms[index].isSelected = value!;
                          });
                        },
                        checkColor: AppColorConstants.roseWhite,
                        activeColor: AppColorConstants.artyClickPurple,

                        side: MaterialStateBorderSide.resolveWith(
                          (Set<MaterialState> states) => BorderSide(
                            width: 2,
                            color: AppColorConstants.paleSky,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))))),
          ],
        ),
        if (index < musicPlatforms.length - 1)
          Divider(
            color: AppColorConstants.paleSky,
          )
      ]);



  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        IterableProperty<MusicPlatformModel>('musicPlatforms', musicPlatforms));
  }
}
