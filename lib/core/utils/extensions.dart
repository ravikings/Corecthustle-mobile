
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizedSpacing on num {
  SizedBox toColumSpace() => SizedBox(height: toDouble().h,);
  SizedBox toRowSpace() => SizedBox(width: toDouble().w,);
}

extension FileExtension on File {
  bool get isImage {
    return ['jpg', 'png', 'jpeg'].contains(path.split(".").last);
  }
}

extension StringExtension on String {
  String firstToUpper() {
    return "${split('').first.toUpperCase()}${substring(1)}";
  }
}