/// Music Platforms Model
class MusicPlatformModel {
  /// Constructor
  MusicPlatformModel({
    required this.name,
    required this.logoImagePath,
    required this.isSelected,
    required this.index
  });

  /// Initialization for platform name
  String name;

  /// Initialization for logo image path
  String logoImagePath;

  /// Initialization for selected
  bool isSelected;

  /// Initialization for index
  int index;
}
