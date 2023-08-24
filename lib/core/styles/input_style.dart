import 'package:correct_hustle/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final defaultInputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.r),
    borderSide: const BorderSide(color: Color(0xFF2D55F9))
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.r),
    borderSide: const BorderSide(color: Color(0xFF2D55F9))
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.r),
    borderSide: const BorderSide(color: Color(0xFF2D55F9))
  ),
  contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
  hintStyle: TextStyle(
    fontSize: 14.sp, fontWeight: FontWeight.w400,
    color: const Color(0xFF94A3B8)
  ),
);