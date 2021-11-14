//ignore_for_file: avoid_classes_with_only_static_members
import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/walk_through_model.dart';

/// Static walk through data
class StaticDataService {
  /// Constructor
  static List<WalkThroughModel> getMockedDataWalkThrough() {
    print(
        '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.appLogoWhite}');
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
}
