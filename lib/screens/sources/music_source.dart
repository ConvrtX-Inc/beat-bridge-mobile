import 'dart:convert';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/app_list.dart';
import 'package:beatbridge/models/music_platform_model.dart';
import 'package:beatbridge/utils/preferences/shared_preferences.dart';
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
  List<MusicPlatformModel> musicPlatforms = <MusicPlatformModel>[];

  @override
  void initState() {
    super.initState();
    setMusicSource();
  }

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
                        AppTextConstants.editMusicSource,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColorConstants.roseWhite,
                            fontSize: 30.sp),
                      ),
                      SizedBox(height: 36.h),
                    ]),
              ),
              Expanded(child: buildMusicSourceList())
            ]));
  }

  Widget buildMusicSourceList() => ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(
            color: AppColorConstants.paleSky,
          ),
      itemCount: musicPlatforms.length,
      itemBuilder: (BuildContext ctx, int index) {
        return Padding(
            padding: EdgeInsets.all(8.w), child: buildMusicSource(index));
      });

  Widget buildMusicSource(int index) => ListTile(
        leading: Image.asset(
          musicPlatforms[index].logoImagePath,
          width: 34,
          height: 34,
        ),
        title: Text(
          musicPlatforms[index].name,
          style: TextStyle(
              color: AppColorConstants.roseWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        trailing: Transform.scale(
            scale: 1.5,
            child: Checkbox(
                value: musicPlatforms[index].isSelected,
                onChanged: (bool? value) {
                  setState(() {
                    musicPlatforms[index].isSelected = value!;
                  });
                  updateMusicSource();
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
                    borderRadius: BorderRadius.circular(5)))),
      );

  Future<void> setMusicSource() async {
    final List<MusicPlatformModel> musicSourceList =
        AppListConstants().musicSourceList;
    final String value = MusicPlatformModel.encode(musicSourceList);

    final String musicsString =
        SharedPreferencesRepository.getString('musicSource');
    debugPrint('music string, $musicsString');
    if (musicsString == '') {
          SharedPreferencesRepository.putString('musicSource', value);
        setState(() {
          musicPlatforms = musicSourceList;
        });
    } else {
      setState(() {
        musicPlatforms = MusicPlatformModel.decode(musicsString);
      });
    }
  }

  Future<void> updateMusicSource() async {
    final String value = MusicPlatformModel.encode(musicPlatforms);
       SharedPreferencesRepository.putString('musicSource', value);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        IterableProperty<MusicPlatformModel>('musicPlatforms', musicPlatforms));
  }
}
