import 'package:beatbridge/constants/asset_path.dart';
import 'package:flutter/material.dart';

/// Widget for app logo
class ImageAppLogo extends StatelessWidget {
  /// Constructor
  const ImageAppLogo(
      {Key? key, required this.appLogoPath, this.appLogoSize = 64})
      : super(key: key);

  final String appLogoPath;
  final double appLogoSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
          '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.appLogoColoredSlogan}',
          width: 220,
          height: 184,
          fit: BoxFit.fill),
    );
  }
}
