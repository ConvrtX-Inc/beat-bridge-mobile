import 'package:beatbridge/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SliderPaginator extends StatelessWidget {
  const SliderPaginator({Key? key, this.isCurrentPage = false})
      : super(key: key);

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
}
