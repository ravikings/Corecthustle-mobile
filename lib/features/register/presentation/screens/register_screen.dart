
import 'package:auto_route/auto_route.dart';
import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/interactions/alert.dart';
import 'package:correct_hustle/core/locator.dart';
import 'package:correct_hustle/core/routes/routes.dart';
import 'package:correct_hustle/core/routes/routes.gr.dart';
import 'package:correct_hustle/core/services/local_storage/hive.localstorage.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:correct_hustle/core/styles/input_style.dart';
import 'package:correct_hustle/core/utils/extensions.dart';
import 'package:correct_hustle/core/utils/functions.dart';
import 'package:correct_hustle/gen/assets.gen.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  bool registrationInProgress = false;

  bool _passwordIsVisible = false;

  void _togglePasswordVisiblity() {
    _passwordIsVisible = !_passwordIsVisible;
    setState(() {});
  }

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  void register(BuildContext context) async {
    try {
      if (firstNameController.text.isEmpty) {
        showErrorAlert(context, message: "First name is required");
        return;
      }
      if (lastNameController.text.isEmpty) {
        showErrorAlert(context, message: "Last name is required");
        return;
      }
      if (emailController.text.isEmpty) {
        showErrorAlert(context, message: "Email is required");
        return;
      }
      if (userNameController.text.isEmpty) {
        showErrorAlert(context, message: "Username is required");
        return;
      }
      if (passwordController.text.isEmpty) {
        showErrorAlert(context, message: "Password is required");
        return;
      }
      ToastAlert.showLoadingAlert("");
      
      final res = await getIt<Dio>().post("register", data: {
        "username": userNameController.text,
        "email": emailController.text,
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "password": passwordController.text
      });
      ToastAlert.closeAlert();
      // ToastAlert.showAlert("Registration successful");


      // String? fcmToken = await getIt<ILocalStorageService>().getItem(appDataBox, pushNotificationKey, defaultValue: null);
      // fcmToken ??= await FirebaseMessaging.instance.getToken();

      final token = res.data['data']['token'];
      
      // await getIt<Dio>().put("user/update-fcm", data: {
      //   "token": fcmToken
      // }, options: Options(
      //   headers: {
      //     "authorization": "Bearer $token"
      //   }
      // )).catchError((err) {
      //   print(err);
      // });


      // // print(token);
      // await getIt<ILocalStorageService>().setItem(appDataBox, firstTimeKey, false);
      // await getIt<ILocalStorageService>().setItem(userDataBox, userTokenKey, token);

      showSuccessAlert(context, message: "Registration successful", onOkay: () {
        // getIt<AppRouter>().replaceAll([AppRoute(url: "http://pallytopit.com.ng?token=$token&hst_footer=false")]);
        getIt<AppRouter>().replace(VerifyAccountRoute(
          email: emailController.text,
          token: token
        ));
      });
      

    } on DioException catch (e) {
      ToastAlert.closeAlert();
      showErrorAlert(context, message: "${e.response!.data['message']}");
      // print("${e.response.toString()}");
    } catch (error) {
      ToastAlert.closeAlert();
      showErrorAlert(context, message: "Something went wrong");
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
                InkWell(
                  onTap: () => context.router.replace(const LoginRoute()),
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

          10.toColumSpace(),

          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    13.toColumSpace(),
                    Text("Create a new Account", style: TextStyle(
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
                      key: _key,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: defaultInputDecoration.copyWith(
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(vertical: 18.h),
                                child: Assets.svgs.nameIcon.svg(),
                              ),
                              hintText: "Enter first name",
                            ),
                            controller: firstNameController
                          ),
                          15.toColumSpace(),
                          TextFormField(
                            decoration: defaultInputDecoration.copyWith(
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(vertical: 18.h),
                                child: Assets.svgs.nameIcon.svg(),
                              ),
                              hintText: "Enter last name"
                            ),
                            controller: lastNameController
                          ),
                          15.toColumSpace(),
                          TextFormField(
                            decoration: defaultInputDecoration.copyWith(
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(vertical: 18.h),
                                child: Assets.svgs.emailAddressIcon.svg(),
                              ),
                              hintText: "Enter email address"
                            ),
                            controller: emailController,
                          ),
                          15.toColumSpace(),
                          TextFormField(
                            decoration: defaultInputDecoration.copyWith(
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(vertical: 18.h),
                                child: Assets.svgs.nameIcon.svg(),
                              ),
                              hintText: "Enter a username"
                            ),
                            controller: userNameController
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
                          41.toColumSpace(),
            
                          ElevatedButton(
                            onPressed: () => register(context),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(const Color(0xFF2D55F9)),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r)
                              ))
                            ), 
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 17.h),
                              child: Center(child: Text("Sign Up", style: TextStyle(
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
                            onTap: () {
                              getIt<ILocalStorageService>().setItem(appDataBox, firstTimeKey, false);
                              getIt<AppRouter>().replace(const LoginRoute());
                            },
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.w400,
                                  color: const Color(0xFF64748B)
                                ),
                                children: const [
                                  TextSpan(text: "Already have an account? "),
                                  TextSpan(text: "Sign In", style: TextStyle(
                                    color: Color(0xFF2D55F9)
                                  )),
                                ]
                              ),
                            )
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