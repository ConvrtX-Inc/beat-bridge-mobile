import 'package:beatbridge/constants/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Widget for walk through paginator
class SliderPaginator extends StatelessWidget {
  /// Constructor
  const SliderPaginator({Key? key, this.isCurrentPage = false})
      : super(key: key);

  /// Determines if current page
  final bool isCurrentPage;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 11.w),
      height: 4,
      width: isCurrentPage ? 45 : 10,
      decoration: BoxDecoration(
          color: isCurrentPage
              ? Colors.white
              : AppColorConstants.dodgerBlue.withOpacity(0.18),
          borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isCurrentPage', isCurrentPage));
  }
}
