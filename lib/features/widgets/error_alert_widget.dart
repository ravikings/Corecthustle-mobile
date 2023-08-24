import 'package:correct_hustle/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorAlertWidget extends StatelessWidget {
  const ErrorAlertWidget({
    super.key,
    required this.message
  });

  final String message;
  // final Function onOkay;

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
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: InkWell(
          //     onTap: () => Navigator.pop(context),
          //     child: const Icon(Icons.close)),
          // ),
          const SizedBox(height: 3,),
          Center(
            child: const CircleAvatar(
              radius: 75/2,
              backgroundColor: Colors.red,
              child: Icon(Icons.close,color: Colors.white, size: 45,),
            ).animate().scale(),
          ),
          const SizedBox(height: 20,),
          Text("Error", style: TextStyle(
            fontSize: 24.sp, fontWeight: FontWeight.w500,
            color: const Color(0xFF192A56)
          ), textAlign: TextAlign.center,),

          const SizedBox(height: 19,),

          Text("$message", style: TextStyle(
            fontSize: 14.sp, fontWeight: FontWeight.w400,
            color: const Color(0xFF192A56)
          ), textAlign: TextAlign.center,).animate().shakeX(delay: 100.ms),

          const SizedBox(height: 40,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
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
                child: Center(child: Text("Okay", style: TextStyle(
                  fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.white
                ),)),
              ),
            ),
          ),

          const SizedBox(height: 10,),
        ],
      ),
    );
  }
}