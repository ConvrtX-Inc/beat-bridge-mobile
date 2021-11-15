// ignore_for_file: avoid_classes_with_only_static_members
import 'package:beatbridge/constants/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Helper for text
class TextHelper {
  /// Widget for error text
  static Widget errorTextDisplay(
    String errorText,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: <Widget>[
          Text(
            AppTextConstants.biggerBullet,
            style: const TextStyle(color: Colors.red),
          ),
          SizedBox(width: 10.w),
          Text(
            errorText,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
