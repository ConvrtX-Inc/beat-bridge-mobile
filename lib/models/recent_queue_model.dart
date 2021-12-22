import 'package:beatbridge/models/music_platform_model.dart';

///  Recent Queue Model
class RecentQueueModel {
  /// Constructor
  RecentQueueModel({
    this.id = '',
    this.name = '',
    this.thumbnailUrl = '',
    this.createdBy = '',
    this.isSelected = false,
    this.createdAt = '',
    this.totalSongs = 0,
    this.musicPlatformsUsed =const []
  });

  /// Initialization for id
  String id;

  /// Initialization for queue name
  String name;

  /// Initialization for  thumbnail url
  String thumbnailUrl;

  /// Initialization for created by
  String createdBy;

  ///Initialization for isSelected
  bool isSelected;

  ///initialization for total songs
  int totalSongs;

  ///Initialization for created_at
  String createdAt;

  /// Initialization for music platforms used
  List<MusicPlatformModel> musicPlatformsUsed;
}
