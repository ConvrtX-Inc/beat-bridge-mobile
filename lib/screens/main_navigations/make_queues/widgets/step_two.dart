import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/app_list.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/music_platform_model.dart';
import 'package:beatbridge/screens/main_navigations/make_queues/screens/make_queue_screen.dart';
import 'package:beatbridge/utils/preferences/shared_preferences.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///Step Two
class StepTwo extends StatefulWidget {
  ///Constructor
  const StepTwo({required this.onStepTwoDone, Key? key}) : super(key: key);

  ///Callback
  final void Function() onStepTwoDone;

  @override
  _StepTwoState createState() => _StepTwoState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<void Function()>.has(
        'onStepTwoDone', onStepTwoDone));
  }
}

class _StepTwoState extends State<StepTwo> {
  List<MusicPlatformModel> musicPlatforms = <MusicPlatformModel>[];
  String selectedPlatform = '';

  @override
  void initState() {
    super.initState();
    getMusicPlatforms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorConstants.mirage,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 11.w),
                        child: Text(AppTextConstants.letsAddMusic,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColorConstants.roseWhite,
                                fontSize: 22)),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  )),
              for (int i = 0; i < musicPlatforms.length; i++)
                Column(children: <Widget>[
                  buildMusicSource(i),
                  Divider(
                    color: AppColorConstants.paleSky,
                  )
                ]),
              buildAddYourOwnItem(),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 27.w, vertical: 16.h),
                child: ButtonRoundedGradient(
                  buttonText: AppTextConstants.continueTxt,
                  buttonCallback: () {
                    widget.onStepTwoDone();
                  },
                ),
              ),
            ]));
  }


  Widget buildMusicSource(int index) => Padding(
      padding: EdgeInsets.all(12.w),
      child: ListTile(
        leading: Image.asset(
          musicPlatforms[index].logoImagePath,
          width: 34,
          height: 34,
        ),
        title: Padding(
            padding: EdgeInsets.fromLTRB(22.w, 0, 0, 0),
            child: Text(
              musicPlatforms[index].name,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: AppColorConstants.roseWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            )),
        trailing: Transform.scale(
            scale: 1.5,
            child: Checkbox(
                value: musicPlatforms[index].name ==
                    MakeYourQueueScreen.of(context)
                        .selectedPlatform
                        .name,
                onChanged: (bool? value) {
                  setState(() {
                    MakeYourQueueScreen.of(context)
                        .selectedPlatform = musicPlatforms[index];
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
                    borderRadius: BorderRadius.circular(5)))),
      ));

  Widget buildAddYourOwnItem() => Padding(
      padding: EdgeInsets.all(12.w),
      child: ListTile(
          leading: Image.asset(
            '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.ownMusicLogoImage}',
            width: 34,
            height: 34,
          ),
          title: Padding(
              padding: EdgeInsets.fromLTRB(22.w, 0, 0, 0),
              child: Text(
                AppTextConstants.addYourOwn,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: AppColorConstants.roseWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              )),
          trailing: Transform.scale(
              scale: 1.5,
              child: Icon(
                Icons.create_new_folder_outlined,
                color: AppColorConstants.roseWhite,
              ))));



  Future<void> getMusicPlatforms() async {
    final String musicsString =
        SharedPreferencesRepository.getString('musicSource');
    if (musicsString == '') {
      final List<MusicPlatformModel> musicSourceList =
          AppListConstants().musicSourceList;
      final String value = MusicPlatformModel.encode(musicSourceList);
      SharedPreferencesRepository.putString('musicSource', value);
      setState(() {
        musicPlatforms = musicSourceList;
      });
    } else {
      setState(() {
        musicPlatforms = MusicPlatformModel.decode(musicsString);
        musicPlatforms = musicPlatforms.where((MusicPlatformModel musicSource) => musicSource.isSelected).toList();

      });
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<MusicPlatformModel>(
          'musicPlatforms', musicPlatforms))
      ..add(StringProperty('selectedPlatform', selectedPlatform));
  }
}
