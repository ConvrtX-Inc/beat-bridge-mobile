import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/people_model.dart';
import 'package:beatbridge/constants/asset_path.dart';

/// Static data data for Recently Played
class PeopleListMockDataUtils {
  List<PeopleModel> getPeopleListModel() {
    return <PeopleModel>[
      PeopleModel(
          id: 1,
          name: 'Jeff Richards',
          totalTrackCount: 20,
          isSelected: false,
          isAdmin: false,
          profileImageUrl: '${AssetsPathConstants.assetsPNGPath}/mock_profile_image_1.png',
          musicPlatformsUsed: <MusicPlatformsUsedModel>[
            MusicPlatformsUsedModel(
              id: 1,
              name: AppTextConstants.soundCloud,
              logoImageUrl:
                  '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.soundCloudLogoImage}',
            ), MusicPlatformsUsedModel(
              id: 2,
              name: AppTextConstants.spotify,
              logoImageUrl:
              '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.spotifyLogoImage}',
            ), MusicPlatformsUsedModel(
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
        profileImageUrl: '${AssetsPathConstants.assetsPNGPath}/mock_profile_image_2.png',
          musicPlatformsUsed: <MusicPlatformsUsedModel>[
             MusicPlatformsUsedModel(
              id: 2,
              name: AppTextConstants.spotify,
              logoImageUrl:
              '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.spotifyLogoImage}',
            ), MusicPlatformsUsedModel(
              id: 3,
              name: AppTextConstants.itunes,
              logoImageUrl:
              '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.itunesLogoImage}',
            )
          ]
      ),
      PeopleModel(
        id: 3,
        name: 'Laura Ruth',
        totalTrackCount: 15,
        isSelected: false,
        isAdmin: false,
        profileImageUrl: '${AssetsPathConstants.assetsPNGPath}/mock_profile_image_3.png',
          musicPlatformsUsed: <MusicPlatformsUsedModel>[
            MusicPlatformsUsedModel(
              id: 1,
              name: AppTextConstants.soundCloud,
              logoImageUrl:
              '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.soundCloudLogoImage}',
            ) , MusicPlatformsUsedModel(
              id: 2,
              name: AppTextConstants.itunes,
              logoImageUrl:
              '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.itunesLogoImage}',
            )
          ]
      ),
      PeopleModel(
        id: 4,
        name: 'Robert Jones',
        totalTrackCount: 17,
        isSelected: false,
        isAdmin: false,
        profileImageUrl: '${AssetsPathConstants.assetsPNGPath}/mock_profile_image_4.png',
          musicPlatformsUsed: <MusicPlatformsUsedModel>[
            MusicPlatformsUsedModel(
              id: 1,
              name: AppTextConstants.soundCloud,
              logoImageUrl:
              '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants
                  .soundCloudLogoImage}',
            )
          ]
      ),
      PeopleModel(
        id: 5,
        name: 'Matt Bale',
        totalTrackCount: 17,
        isSelected: true,
        isAdmin: false,
        profileImageUrl: '${AssetsPathConstants.assetsPNGPath}/mock_profile_image_5.png',
          musicPlatformsUsed: <MusicPlatformsUsedModel>[
            MusicPlatformsUsedModel(
              id: 1,
              name: AppTextConstants.soundCloud,
              logoImageUrl:
              '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.soundCloudLogoImage}',
            ), MusicPlatformsUsedModel(
              id: 2,
              name: AppTextConstants.spotify,
              logoImageUrl:
              '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.spotifyLogoImage}',
            )
          ]
      )
    ];
  }
}
