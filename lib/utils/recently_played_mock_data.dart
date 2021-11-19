import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/recently_played_model.dart';

/// Static data data for Recently Played
class RecentlyPlayedMockDataUtils {
  List<RecentlyPlayedModel> getRecentlyPlayedModel() {
    return <RecentlyPlayedModel>[
      RecentlyPlayedModel(
        id: 1,
        isSelected: true,
        songTitle: 'Fear of the Water',
        artistName: 'G-Easy',
        songImageUrl:
        '${AssetsPathConstants.assetsPNGPath}/g_easy.png',
      ),
      RecentlyPlayedModel(
        id: 2,
        isSelected: false,
        songTitle: 'Love me like you do',
        artistName: 'Ariana Grande',
        songImageUrl:
        '${AssetsPathConstants.assetsPNGPath}/ariana.png',
      ),
      RecentlyPlayedModel(
        id: 3,
        isSelected: true,
        songTitle: 'Light it up',
        artistName: 'Drake',
        songImageUrl:
        '${AssetsPathConstants.assetsPNGPath}/drake.png',
      ),
      RecentlyPlayedModel(
        id: 4,
        isSelected: false,
        songTitle: '21 Guns',
        artistName: 'Green Day',
        songImageUrl:
        '${AssetsPathConstants.assetsPNGPath}/green_day.png',
      ),
      RecentlyPlayedModel(
        id: 5,
        isSelected: true,
        songTitle: 'Blinding Lights',
        artistName: 'The Weekend',
        songImageUrl:
        '${AssetsPathConstants.assetsPNGPath}/the_weekend.png',
      ),
    ];
  }
}
