import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/app_list.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/music_platform_model.dart';
import 'package:beatbridge/models/people_model.dart';
import 'package:beatbridge/models/recently_played_model.dart';
import 'package:beatbridge/screens/main_navigations/make_queues/screens/make_queue_screen.dart';
import 'package:beatbridge/utils/preferences/shared_preferences.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///Step Two
class addMusicScreen extends StatefulWidget {
  ///Constructor
  const addMusicScreen({ Key? key}) : super(key: key);

  ///Callback
  // final void Function() onStepTwoDone;

  @override
  _addMusicScreenState createState() => _addMusicScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // properties.add();
  }
}

class _addMusicScreenState extends State<addMusicScreen> {
  List<MusicPlatformModel> musicPlatforms = <MusicPlatformModel>[];
  final List<PeopleModel> friendList =
      StaticDataService.getPeopleListMockData();
      final List<RecentlyPlayedModel> recentlyPlayedItems =
      StaticDataService.getRecentlyPlayedMockData();
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
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 11.w),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 20.w),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 11.w),
                            child: buildMusicSource(),
                                
                          ),
                          //  Padding(
                          //    padding: const EdgeInsets.fromLTRB(11, 15, 0,0),
                          //    child: Divider(color: AppColorConstants.paleSky),
                          //  ),
                           SizedBox(
                            height: 350,
                      child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 27.w),
                      itemCount: recentlyPlayedItems.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            buildRecentlyPlayedItem(context, index),
                          ],
                        );
                      })),
                           Padding(
                             padding: const EdgeInsets.fromLTRB(11, 15, 0,0),
                             child: Divider(color: AppColorConstants.paleSky),
                           ),
                           selectFromPlaylist()
                        ],
                      )),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 27.w, vertical: 16.h),
                  child: ButtonRoundedGradient(
                    buttonText: AppTextConstants.continueTxt,
                    buttonCallback: () {
                    },
                  ),
                ),
              ]),
        ));
  }
  Widget selectFromPlaylist(){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: <Widget>[
              Text(AppTextConstants.selectFromPlaylist,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColorConstants.roseWhite.withOpacity(0.7),
                fontSize: 22)),
                TextButton(
                  onPressed: () {},
                  child: Text(AppTextConstants.seeAll,
                   style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColorConstants.roseWhite,
                    fontSize: 13)))
                            ]),
                            Container(
      height: 120.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            for (int i = 0; i < friendList.length - 1; i++)
            buildFriendItem(i),
          ]),
    ),
        ],
      ),
    );
  }
  Widget buildFriendItem(int index) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(friendList[index].profileImageUrl),
                    fit: BoxFit.fitHeight,
                  )),
            ),
            SizedBox(
              height: 6.h,
            ),
            Text(friendList[index].name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600))
          ],
        ));
  }
 

  Widget buildRecentlyPlayedItem(BuildContext context, int index) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return AppColorConstants.roseWhite;
      }
      return AppColorConstants.artyClickPurple;
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      SizedBox(height: 24.h),
      Row(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
              child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image:
                            AssetImage(recentlyPlayedItems[index].songImageUrl),
                        fit: BoxFit.fitHeight,
                      )),
                  child: Align(
                      child: Image.asset(
                          '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}')))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(recentlyPlayedItems[index].songTitle,
                  style: TextStyle(
                      color: AppColorConstants.roseWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 17)),
              SizedBox(height: 8.h),
              Text(recentlyPlayedItems[index].artistName,
                  style:
                      TextStyle(color: AppColorConstants.paleSky, fontSize: 13))
            ],
          ),
          const Spacer(),
          Transform.scale(
              scale: 1.5,
              child: Checkbox(
                  value: recentlyPlayedItems[index].isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      recentlyPlayedItems[index].isSelected = value!;
                    });
                  },
                  checkColor: AppColorConstants.rubberDuckyYellow,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  side: MaterialStateBorderSide.resolveWith(
                    (Set<MaterialState> states) => BorderSide(
                      width: 2,
                      color: AppColorConstants.paleSky,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))))
        ],
      )
    ]);
  }
  Widget buildMusicSource() 
  {
    int index= 0;
    return Padding(
      padding: EdgeInsets.all(0.w),
      child: Row(
        children: [
          Text(AppTextConstants.addMusic,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColorConstants.roseWhite,
            fontSize: 22)), 
            Padding(
              padding: const EdgeInsets.fromLTRB(10,0,0,0),
              child: Image.asset(
                musicPlatforms[index].logoImagePath,
                width: 24,
                height: 24,
              ),
            ),
             Padding(
                padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
                child: Text(
                  musicPlatforms[index].name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: AppColorConstants.roseWhite,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                )),
        ],
      )
      );}

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
        musicPlatforms = musicPlatforms
            .where((MusicPlatformModel musicSource) => musicSource.isSelected)
            .toList();
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
