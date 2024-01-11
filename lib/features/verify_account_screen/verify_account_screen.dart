
import 'package:auto_route/auto_route.dart';
import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/interactions/alert.dart';
import 'package:correct_hustle/core/locator.dart';
import 'package:correct_hustle/core/routes/routes.dart';
import 'package:correct_hustle/core/routes/routes.gr.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:correct_hustle/core/styles/input_style.dart';
import 'package:correct_hustle/core/utils/extensions.dart';
import 'package:correct_hustle/core/utils/functions.dart';
import 'package:correct_hustle/gen/assets.gen.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class VerifyAccountScreen extends StatefulWidget {
  const VerifyAccountScreen({super.key, required this.email, required this.token});

  final String email;
  final String token;

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {


  bool _passwordIsVisible = false;

  void _togglePasswordVisiblity() {
    _passwordIsVisible = !_passwordIsVisible;
    setState(() {});
  }

  final tokenController = TextEditingController();

  void verifyAccount(BuildContext context) async {
    try {
      
      if (tokenController.text.isEmpty) {
        showErrorAlert(context, message: "Please provide the token sent to your email address");
        return;
      }
      ToastAlert.showLoadingAlert("");
      String? fcmToken = await getIt<ILocalStorageService>().getItem(appDataBox, pushNotificationKey, defaultValue: null);
      fcmToken ??= await FirebaseMessaging.instance.getToken();
      final res = await getIt<Dio>().post("verify", data: {
        "email": widget.email,
        "token": tokenController.text,
      });

      print("VerifyAccount ::: Response ::: ${res.data}");

      ToastAlert.closeAlert();
      // ToastAlert.showAlert("Login successful");

      showSuccessAlert(context, message: "Account verified successfully", onOkay: () {
        getIt<AppRouter>().replaceAll([LoginRoute()]);
        // getIt<AppRouter>().replaceAll([AppRoute(url: "http://pallytopit.com.ng?token=${widget.token}&hst_footer=false")]);
      });

      // print(token);
    } on DioException catch (e) {
      ToastAlert.closeAlert();
      if (e.type == DioExceptionType.unknown) {
        showErrorAlert(context, message: "Internet error occurred");
        return;
      }
      // ToastAlert.showErrorAlert("${e.response!.data['message']}");
      showErrorAlert(context, message: "${e.response!.data['message']}");
      // print("${e.response.toString()}");
    } catch (error) {
      ToastAlert.closeAlert();
      // ToastAlert.showErrorAlert("Something went wrong");
      showErrorAlert(context, message: "Unable to login, please try again.");
      
      rethrow;
    }
  }


  void resendOtp(BuildContext context) async {
    try {

      ToastAlert.showLoadingAlert("");
      String? fcmToken = await getIt<ILocalStorageService>().getItem(appDataBox, pushNotificationKey, defaultValue: null);
      fcmToken ??= await FirebaseMessaging.instance.getToken();
      await getIt<Dio>().post("resend", data: {
        "email": widget.email,
      });

      ToastAlert.closeAlert();
      // ToastAlert.showAlert("Login successful");

      showSuccessAlert(context, message: "OTP sent successfully", onOkay: () {
        // getIt<AppRouter>().replaceAll([AppRoute(url: "http://pallytopit.com.ng?token=${widget.token}&hst_footer=false")]);
        Navigator.pop(context);
      });

      // print(token);
    } on DioException catch (e) {
      ToastAlert.closeAlert();
      if (e.type == DioExceptionType.unknown) {
        showErrorAlert(context, message: "Internet error occurred");
        return;
      }
      // ToastAlert.showErrorAlert("${e.response!.data['message']}");
      showErrorAlert(context, message: "${e.response!.data['message']}");
      // print("${e.response.toString()}");
    } catch (error) {
      ToastAlert.closeAlert();
      // ToastAlert.showErrorAlert("Something went wrong");
      showErrorAlert(context, message: "Unable to login, please try again.");
      
      rethrow;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          60.toColumSpace(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            height: 48.h,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => getIt<AppRouter>().replace(const RegisterRoute()),
                  child: Assets.svgs.backIcon.svg()
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Assets.svgs.logo.svg(
                      height: 34.h
                    ),
                  ),
                ),

                Assets.svgs.backIcon.svg(
                  width: 19, height: 19,
                  color: Colors.transparent
                ),

              ],
            ),
          ),

          23.toColumSpace(),

          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Verify Account", style: TextStyle(
                      fontSize: 25.sp, fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A)
                    ),),
                    8.toColumSpace(),
                    Text("Kindly provide the code sent to ${widget.email}", style: TextStyle(
                      fontSize: 14.sp, fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B)
                    ),),
                    48.toColumSpace(),
                    Form(
                      key: UniqueKey(),
                      child: Column(
                        children: [
                          TextFormField(
                            textAlign: TextAlign.center,
                            decoration: defaultInputDecoration.copyWith(
                              hintText: "Enter Token",
                              counterText: ""
                            ),
                            controller: tokenController,
                            style: TextStyle(
                              fontSize: 24.sp, fontWeight: FontWeight.w700
                            ),
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                          ),

                          10.toColumSpace(),

                          InkWell(
                            onTap: () => resendOtp(context),
                            child: const Text("Resend OTP")
                          ),
                          
                          41.toColumSpace(),
            
                          ElevatedButton(
                            onPressed: () => verifyAccount(context),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(const Color(0xFF2D55F9)),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r)
                              ))
                            ), 
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 17.h),
                              child: Center(child: Text("Verify Account", style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.white
                              ),)),
                            ),
                          ),

                          
            
                          41.toColumSpace(),
            
                          // Assets.svgs.or.svg(),
                          41.toColumSpace(),
                          // Assets.svgs.loginWithGoogle.svg(),

                          95.toColumSpace(),

                          // GestureDetector(
                          //   onTap: () => getIt<AppRouter>().push(const RegisterRoute()),
                          //   child: Assets.svgs.dontHaveAnAccount.svg()
                          // ),

                          31.toColumSpace()
            
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}