//ignore_for_file: avoid_classes_with_only_static_members
import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/music_platform_model.dart';
import 'package:beatbridge/models/walk_through_model.dart';

/// Static walk through data
class StaticDataService {
  /// Constructor
  static List<WalkThroughModel> getMockedDataWalkThrough() {
    return <WalkThroughModel>[
      WalkThroughModel(
        logoImagePath:
            '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.appLogoWhite}',
        backgroundImagePath:
            '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.walkThroughBackground1}',
        topHeaderText: AppTextConstants.hassleFree,
        bottomHeaderText: AppTextConstants.oneDeviceMillionSongs,
        headerImagePath:
            '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.walkThroughColoredText1}',
      ),
      WalkThroughModel(
        index: 1,
        logoImagePath:
            '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.appLogoWhite}',
        backgroundImagePath:
            '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.walkThroughBackground2}',
        topHeaderText: AppTextConstants.your,
        bottomHeaderText: AppTextConstants.oneDeviceMillionSongs,
        headerImagePath:
            '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.walkThroughColoredText2}',
      ),
      WalkThroughModel(
        index: 2,
        logoImagePath:
            '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.appLogoWhite}',
        backgroundImagePath:
            '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.walkThroughBackground3}',
        topHeaderText: AppTextConstants.hassleFree,
        bottomHeaderText: AppTextConstants.oneDeviceMillionSongs,
        headerImagePath:
            '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.walkThroughColoredText3}',
      ),
    ];
  }

/// Static data for Music platforms
   static  List<MusicPlatformModel> getMusicPlatformModel() {
     return [
       MusicPlatformModel(
           name: AppTextConstants.spotify,
           index: 0,
           logoImagePath:
           '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants
               .spotifyLogoImage}',
           isSelected: true),
       MusicPlatformModel(
           name: AppTextConstants.soundCloud,
           index: 1,
           logoImagePath:
           '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants
               .soundCloudLogoImage}',
           isSelected: false),
       MusicPlatformModel(
           name: AppTextConstants.itunes,
           index: 2,
           logoImagePath:
           '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants
               .itunesLogoImage}',
           isSelected: false),
       MusicPlatformModel(
           name: AppTextConstants.addYourOwn,
           index: 3,
           logoImagePath:
           '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants
               .ownMusicLogoImage}',
           isSelected: false)
     ];
   }
}
