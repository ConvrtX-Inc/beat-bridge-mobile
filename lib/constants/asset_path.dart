/*
  Although we have described the assets path in pubspec.yaml but to use that asset in an application we need to give there relative path in any widgets.
  If we add all the assets relative path in one file then it will be easy for us to get all the paths and update the path if required in the future.
 */
/// Class for app assets path
class AssetsPath {
  /// Constructor
  const AssetsPath();

  /// returns assets png path
  static const String assetsPNGPath = 'assets/images/png';

  /// returns assets svg path
  static const String assetsSVGPath = 'assets/images/svg';
}
