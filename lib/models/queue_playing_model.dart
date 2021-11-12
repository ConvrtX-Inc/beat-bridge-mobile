import 'dart:ui';

/// Class for queue playing screen items
class QueuePlayingModels {
  /// Constructor
  QueuePlayingModels({
    required this.id,
    required this.title,
    required this.name,
    required this.type,
    required this.imgUrl,
  });

  /// property for ide
  int id;

  /// property for title
  String title;

  /// property for name
  String name;

  /// property for type
  String type;

  /// property for image url
  String imgUrl;

}