
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizedSpacing on num {
  SizedBox toColumSpace() => SizedBox(height: toDouble().h,);
  SizedBox toRowSpace() => SizedBox(width: toDouble().w,);
}