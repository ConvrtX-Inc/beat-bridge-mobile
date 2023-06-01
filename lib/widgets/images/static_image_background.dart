import 'package:beatbridge/constants/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Widget for static image background
class ImageStaticBackground extends StatelessWidget {
  /// Constructor
  const ImageStaticBackground(
      {required this.imagePath, required this.childWidget, Key? key})
      : super(key: key);

  /// initialization for image path
  final String imagePath;

  /// initialization for child widget
  /// make sure the child widget ALWAYS occupies the whole screen
  final Widget childWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: AppColorConstants.darkNavy,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(imagePath),
          ),
        ),
        child: childWidget);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('imagePath', imagePath));
  }
}
