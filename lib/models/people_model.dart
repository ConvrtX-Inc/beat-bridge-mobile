/// People Model - Model for Add Friends
class PeopleModel {
  /// Constructor
  PeopleModel(
      {required this.id,
      required this.name,
      required this.profileImageUrl,
      required this.isSelected,
      required this.isAdmin,
      required this.totalTrackCount,
      required this.musicPlatformsUsed
      });

  /// Initialization for id
  int id;

  /// Initialization for total tracks
  int totalTrackCount;

  /// Initialization for person's name
  String name;

  /// Initialization for profile image path
  String profileImageUrl;

  /// Initialization for isAdmin
  bool isAdmin;

  /// Initialization for isSelected
  bool isSelected;

  /// Initialization for music platforms used
  List<MusicPlatformsUsedModel> musicPlatformsUsed =[];
}

/// model for music platforms used
class MusicPlatformsUsedModel {
  /// Constructor
  MusicPlatformsUsedModel(
      {required this.id, required this.name, required this.logoImageUrl});

  /// Initialization for id
  int id;

  /// Initialization for name
  String name;

  /// Initialization for logo image url
  String logoImageUrl;
}
