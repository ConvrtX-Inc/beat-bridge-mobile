//ignore_for_file: unnecessary_lambdas

import 'dart:convert';

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

  static MusicPlatformModel fromJson(Map<String, dynamic> jsonData) {
    return MusicPlatformModel(
      name: jsonData['name'],
      logoImagePath: jsonData['logoImagePath'],
      isSelected: jsonData['isSelected'],
      index: jsonData['index']
    );
  }

  static Map<String, dynamic> toMap(MusicPlatformModel musicPlatform) => {
    'name': musicPlatform.name,
    'logoImagePath': musicPlatform.logoImagePath,
    'isSelected': musicPlatform.isSelected,
    'index': musicPlatform.index,

  };

  ///Encode data when storing to shared pref
  static String encode(List<MusicPlatformModel> musics) => json.encode(
    musics
        .map<Map<String, dynamic>>(MusicPlatformModel.toMap)
        .toList(),
  );

  ///Decode Data from shared pref
  static List<MusicPlatformModel> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<MusicPlatformModel>((item) => MusicPlatformModel.fromJson(item))
          .toList();
}
