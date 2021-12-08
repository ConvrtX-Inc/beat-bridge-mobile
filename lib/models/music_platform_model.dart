/// Music Platforms Model
class MusicPlatformModel {
  /// Constructor
  MusicPlatformModel({
      this.name ='',
      this.logoImagePath ='',
      this.isSelected =false,
      this.index = 0
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
