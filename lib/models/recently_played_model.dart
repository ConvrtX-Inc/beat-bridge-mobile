/// Recently  Played Model
class RecentlyPlayedModel {
  /// Constructor
  RecentlyPlayedModel({
    required this.songTitle,
    required this.artistName,
    required this.isSelected,
    required this.id,
    required this.songImageUrl
  });

  /// Initialization for Song title
  String songTitle;

  /// Initialization for artist name
  String artistName;

  /// Initialization for selected
  bool isSelected;

  /// Initialization for index
  int id;

/// Initialization for Song Image Path
  String songImageUrl;
}
