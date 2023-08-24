import 'package:correct_hustle/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessAlertWidget extends StatelessWidget {
  const SuccessAlertWidget({
    super.key,
    required this.message,
    required this.onOkay
  });

  final String message;
  final Function onOkay;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)
      ),
      // margin: EdgeInsets.symmetric(horizontal: 23.w),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close)),
          ),
          const SizedBox(height: 3,),
          Center(
            child: Assets.svgs.successIcon.svg(
              height: 150
            ),
          ),
          const SizedBox(height: 66,),
          Text("Successful", style: TextStyle(
            fontSize: 24.sp, fontWeight: FontWeight.w500,
            color: const Color(0xFF192A56)
          ), textAlign: TextAlign.center,),

          const SizedBox(height: 19,),

          Text("$message", style: TextStyle(
            fontSize: 14.sp, fontWeight: FontWeight.w400,
            color: const Color(0xFF192A56)
          ), textAlign: TextAlign.center,),

          const SizedBox(height: 20,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () => onOkay(),
              // onPressed: () => login(context),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color(0xFF2D55F9)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)
                )),
                elevation: MaterialStateProperty.all(0)
              ), 
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Center(child: Text("Continue", style: TextStyle(
                  fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.white
                ),)),
              ),
            ),
          ),

          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}