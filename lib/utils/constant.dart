import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'hexColor.dart';

// ignore: avoid_classes_with_only_static_members
class Constants {
  static var bgColor = HexColor('##181720');
  static var lightviolet = HexColor('##8201FF');
  static var lightred = HexColor('##C2837C');

  static var image1 = 'assets/images/image1.png';
  static var image2 = 'assets/images/image2.png';
  static var volume = 'assets/images/volume.png';
  static var forward = 'assets/images/forward.png';
  static var previous = 'assets/images/previous.png';
  static var shuffle = 'assets/images/shuffle.png';
  static var carbonDelete = 'assets/images/carbon_delete.png';
  static var skip = 'assets/images/default.png';
  static var default2 = 'assets/images/default2.png';

  static Widget heightSpacing60 = const SizedBox(
    height: 60,
  );

  static Widget heightSpacing40 = const SizedBox(
    height: 40,
  );
  static Widget heightSpacing30 = const SizedBox(
    height: 30,
  );

  static Widget heightSpacing20 = const SizedBox(
    height: 20,
  );
  static Widget spacing15 = const SizedBox(
    height: 15,
  );
  static Widget spacingwidth20 = const SizedBox(
    width: 20,
  );
  static Widget spacingwidth15 = const SizedBox(
    width: 15,
  );
}
