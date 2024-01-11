
// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/data/models/user_model.dart';
import 'package:correct_hustle/core/interactions/alert.dart';
import 'package:correct_hustle/core/locator.dart';
import 'package:correct_hustle/core/routes/routes.dart';
import 'package:correct_hustle/core/routes/routes.gr.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:correct_hustle/core/state/user_profile_provider.dart';
import 'package:correct_hustle/core/styles/input_style.dart';
import 'package:correct_hustle/core/utils/extensions.dart';
import 'package:correct_hustle/core/utils/functions.dart';
import 'package:correct_hustle/gen/assets.gen.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  bool _passwordIsVisible = false;

  void _togglePasswordVisiblity() {
    _passwordIsVisible = !_passwordIsVisible;
    setState(() {});
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login(BuildContext context) async {
    try {
      
      if (emailController.text.isEmpty) {
        showErrorAlert(context, message: "Email is required");
        return;
      }
      if (passwordController.text.isEmpty) {
        showErrorAlert(context, message: "Password is required");
        return;
      }
      ToastAlert.showLoadingAlert("");
      String? fcmToken = await getIt<ILocalStorageService>().getItem(appDataBox, pushNotificationKey, defaultValue: null);
      fcmToken ??= await FirebaseMessaging.instance.getToken();
      final res = await getIt<Dio>().post("login", data: {
        "email": emailController.text,
        "password": passwordController.text,
        "fcm_token": fcmToken
      });
      
      final token = res.data['data']['token'];

      print(res.data['data']['user']);

      await getIt<Dio>().put("user/update-fcm", data: {
        "token": fcmToken
      }, options: Options(
        headers: {
          "authorization": "Bearer $token"
        }
      ));

      ToastAlert.closeAlert();
      // ToastAlert.showAlert("Login successful");
      final emailVerified = res.data['data']['user']['email_verified_at'] != null;

      if (emailVerified) {
        final user = UserModel.fromJson(res.data['data']['user']);
        await getIt<ILocalStorageService>().setItem(userDataBox, userTokenKey, token);
        await getIt<ILocalStorageService>().setItem(userDataBox, userIDKey, user.id);

        showSuccessAlert(context, message: "Login Successful.", onOkay: () {
          getIt<AppRouter>().replace(AppRoute(url: "$appUrl?token=$token&hst_footer=false"));
        });
      } else {
        showSuccessAlert(context, message: "Please verify your account to continue.", onOkay: () {
          getIt<AppRouter>().replace(VerifyAccountRoute(email: emailController.text, token: token));
        });
      }


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
                  child: Assets.svgs.backIcon.svg()),

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
                    Text("Welcome back", style: TextStyle(
                      fontSize: 25.sp, fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A)
                    ),),
                    8.toColumSpace(),
                    Text("Let’s log in. You’ve been missed!", style: TextStyle(
                      fontSize: 14.sp, fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B)
                    ),),
                    48.toColumSpace(),
                    Form(
                      key: UniqueKey(),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: defaultInputDecoration.copyWith(
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(vertical: 18.h),
                                child: Assets.svgs.emailAddressIcon.svg(),
                              ),
                              hintText: "Enter email address"
                            ),
                            controller: emailController
                          ),
                          15.toColumSpace(),
                          TextFormField(
                            obscureText: !_passwordIsVisible,
                            decoration: defaultInputDecoration.copyWith(
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(vertical: 18.h),
                                child: Assets.svgs.passwordIcon.svg(),
                              ),
                              hintText: "Enter password",
                              suffixIcon: InkWell(
                                onTap: () => _togglePasswordVisiblity(),
                                child: Icon(
                                  _passwordIsVisible ? Icons.visibility_off : Icons.remove_red_eye
                                ),
                              )
                            ),
                            controller: passwordController
                          ),
                          10.toColumSpace(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                context.router.push(AppRoute(url: "$appUrl/auth/password/reset?from_app=true", canExitFreely: true));
                              },
                              child: const Text("Forgot password", style: TextStyle(
                                color: Color(0xFF2D55F9)
                              ),),
                            ),
                          ),
                          41.toColumSpace(),
            
                          ElevatedButton(
                            onPressed: () => login(context),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(const Color(0xFF2D55F9)),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r)
                              ))
                            ), 
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 17.h),
                              child: Center(child: Text("Log In", style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.white
                              ),)),
                            ),
                          ),
            
                          41.toColumSpace(),
            
                          // Assets.svgs.or.svg(),
                          41.toColumSpace(),
                          // Assets.svgs.loginWithGoogle.svg(),

                          95.toColumSpace(),

                          GestureDetector(
                            onTap: () => getIt<AppRouter>().push(const RegisterRoute()),
                            child: Assets.svgs.dontHaveAnAccount.svg()
                          ),

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