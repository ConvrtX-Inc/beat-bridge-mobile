import 'package:beatbridge/models/music_platform_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///Music Platforms Used
class MusicPlatformUsed extends StatelessWidget {
  ///Constructor
  const MusicPlatformUsed(
      {Key? key,
      List<MusicPlatformModel> musicPlatforms =
          const <MusicPlatformModel>[]})
      : _musicPlatforms = musicPlatforms,
        super(key: key);

  final List<MusicPlatformModel> _musicPlatforms;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          for (int i = 0; i < _musicPlatforms.length; i++)
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Image(
                    image: AssetImage(_musicPlatforms[i].logoImagePath),
                    height: 20,
                    width: 20)),
        ],
      )
    ]);
  }
}
