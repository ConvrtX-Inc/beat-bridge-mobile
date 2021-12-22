//ignore_for_file: avoid_classes_with_only_static_members
import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/music_platform_model.dart';
import 'package:beatbridge/models/my_devices_model.dart';
import 'package:beatbridge/models/people_model.dart';
import 'package:beatbridge/models/recently_played_model.dart';
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
  static List<MusicPlatformModel> getMusicPlatformModel() {
    return [
      MusicPlatformModel(
          name: AppTextConstants.spotify,
          index: 0,
          logoImagePath:
              '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.spotifyLogoImage}',
          isSelected: true),
      MusicPlatformModel(
          name: AppTextConstants.soundCloud,
          index: 1,
          logoImagePath:
              '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.soundCloudLogoImage}',
          isSelected: false),
      MusicPlatformModel(
          name: AppTextConstants.itunes,
          index: 2,
          logoImagePath:
              '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.itunesLogoImage}',
          isSelected: false),
      MusicPlatformModel(
          name: AppTextConstants.addYourOwn,
          index: 3,
          logoImagePath:
              '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.ownMusicLogoImage}',
          isSelected: false)
    ];
  }

  ///Static data for people
  static List<PeopleModel> getPeopleListMockData() {
    return <PeopleModel>[
      PeopleModel(
          id: 1,
          name: 'Jeff Richards',
          totalTrackCount: 20,
          isSelected: false,
          isAdmin: false,
          profileImageUrl:
              '${AssetsPathConstants.assetsPNGPath}/mock_profile_image_1.png',
          musicPlatformsUsed: <MusicPlatformsUsedModel>[
            MusicPlatformsUsedModel(
              id: 1,
              name: AppTextConstants.soundCloud,
              logoImageUrl:
                  '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.soundCloudLogoImage}',
            ),
            MusicPlatformsUsedModel(
              id: 2,
              name: AppTextConstants.spotify,
              logoImageUrl:
                  '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.spotifyLogoImage}',
            ),
            MusicPlatformsUsedModel(
              id: 3,
              name: AppTextConstants.itunes,
              logoImageUrl:
                  '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.itunesLogoImage}',
            )
          ]),
      PeopleModel(
          id: 2,
          name: 'Allen Smith',
          totalTrackCount: 17,
          isSelected: true,
          isAdmin: false,
          profileImageUrl:
              '${AssetsPathConstants.assetsPNGPath}/mock_profile_image_2.png',
          musicPlatformsUsed: <MusicPlatformsUsedModel>[
            MusicPlatformsUsedModel(
              id: 2,
              name: AppTextConstants.spotify,
              logoImageUrl:
                  '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.spotifyLogoImage}',
            ),
            MusicPlatformsUsedModel(
              id: 3,
              name: AppTextConstants.itunes,
              logoImageUrl:
                  '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.itunesLogoImage}',
            )
          ]),
      PeopleModel(
          id: 3,
          name: 'Laura Ruth',
          totalTrackCount: 15,
          isSelected: false,
          isAdmin: false,
          profileImageUrl:
              '${AssetsPathConstants.assetsPNGPath}/mock_profile_image_3.png',
          musicPlatformsUsed: <MusicPlatformsUsedModel>[
            MusicPlatformsUsedModel(
              id: 1,
              name: AppTextConstants.soundCloud,
              logoImageUrl:
                  '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.soundCloudLogoImage}',
            ),
            MusicPlatformsUsedModel(
              id: 2,
              name: AppTextConstants.itunes,
              logoImageUrl:
                  '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.itunesLogoImage}',
            )
          ]),
      PeopleModel(
          id: 4,
          name: 'Robert Jones',
          totalTrackCount: 17,
          isSelected: false,
          isAdmin: false,
          profileImageUrl:
              '${AssetsPathConstants.assetsPNGPath}/mock_profile_image_4.png',
          musicPlatformsUsed: <MusicPlatformsUsedModel>[
            MusicPlatformsUsedModel(
              id: 1,
              name: AppTextConstants.soundCloud,
              logoImageUrl:
                  '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.soundCloudLogoImage}',
            )
          ]),
      PeopleModel(
          id: 5,
          name: 'Matt Bale',
          totalTrackCount: 17,
          isSelected: true,
          isAdmin: false,
          profileImageUrl:
              '${AssetsPathConstants.assetsPNGPath}/mock_profile_image_5.png',
          musicPlatformsUsed: <MusicPlatformsUsedModel>[
            MusicPlatformsUsedModel(
              id: 1,
              name: AppTextConstants.soundCloud,
              logoImageUrl:
                  '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.soundCloudLogoImage}',
            ),
            MusicPlatformsUsedModel(
              id: 2,
              name: AppTextConstants.spotify,
              logoImageUrl:
                  '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.spotifyLogoImage}',
            )
          ])
    ];
  }

  ///Static Data for devices
  static List<MyDevicesModel> getMyDevicesMockData() {
    return <MyDevicesModel>[
      MyDevicesModel(
          id: 1,
          name: 'Sony',
          isConnected: true,
          deviceImageUrl: '${AssetsPathConstants.assetsPNGPath}/sony.png'),
      MyDevicesModel(
          id: 2,
          name: 'JBL Roomie',
          isConnected: false,
          deviceImageUrl: '${AssetsPathConstants.assetsPNGPath}/jbl.png'),
      MyDevicesModel(
          id: 3,
          name: 'Yaz Device',
          isConnected: false,
          deviceImageUrl: '${AssetsPathConstants.assetsPNGPath}/yaz.png'),
    ];
  }

  ///Static data for recently played
  static List<RecentlyPlayedModel> getRecentlyPlayedMockData() {
    return <RecentlyPlayedModel>[
      RecentlyPlayedModel(
        id: 1,
        isSelected: true,
        songTitle: 'Fear of the Water',
        artistName: 'G-Easy',
        songImageUrl: '${AssetsPathConstants.assetsPNGPath}/g_easy.png',
      ),
      RecentlyPlayedModel(
        id: 2,
        isSelected: false,
        songTitle: 'Love me like you do',
        artistName: 'Ariana Grande',
        songImageUrl: '${AssetsPathConstants.assetsPNGPath}/ariana.png',
      ),
      RecentlyPlayedModel(
        id: 3,
        isSelected: true,
        songTitle: 'Light it up',
        artistName: 'Drake',
        songImageUrl: '${AssetsPathConstants.assetsPNGPath}/drake.png',
      ),
      RecentlyPlayedModel(
        id: 4,
        isSelected: false,
        songTitle: '21 Guns',
        artistName: 'Green Day',
        songImageUrl: '${AssetsPathConstants.assetsPNGPath}/green_day.png',
      ),
      RecentlyPlayedModel(
        id: 5,
        isSelected: true,
        songTitle: 'Blinding Lights',
        artistName: 'The Weekend',
        songImageUrl: '${AssetsPathConstants.assetsPNGPath}/the_weekend.png',
      ),
    ];
  }
}
