
// // ignore_for_file: use_build_context_synchronously

// import 'package:auto_route/auto_route.dart';
// import 'package:correct_hustle/core/constants/constants.dart';
// import 'package:correct_hustle/core/interactions/alert.dart';
// import 'package:correct_hustle/core/locator.dart';
// import 'package:correct_hustle/core/routes/routes.dart';
// import 'package:correct_hustle/core/routes/routes.gr.dart';
// import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
// import 'package:correct_hustle/gen/assets.gen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// @RoutePage()
// class AppScreen extends StatefulWidget {
//   AppScreen({super.key, required this.url});

//   final String url;

//   @override
//   State<AppScreen> createState() => _AppScreenState();
// }

// class _AppScreenState extends State<AppScreen> {

//   bool _loading = true;
//   // double _percentageLoaded = 0;

//   void setLoading(bool loading) {
//     setState(() {
//       _loading = loading;
//     });
//   }

//   final controller = WebViewController()
//   ..setJavaScriptMode(JavaScriptMode.unrestricted)
//   ..setBackgroundColor(const Color(0x00000000));

//   @override
//   void initState() {
//     super.initState();
//     controller.loadRequest(Uri.parse(widget.url));
//     controller.setNavigationDelegate(
//       NavigationDelegate(
//         onProgress: (int progress) {
//           // Update loading bar.
//           // print("Loading Progress ::: $progress");
//         },
//         onPageStarted: (String url) {
//           setLoading(true);
//         },
//         onPageFinished: (String url) {
//           setLoading(false);
//         },
//         onWebResourceError: (WebResourceError error) {},
//         onNavigationRequest: (NavigationRequest request) {
//           try {
//             setLoading(true);
//             // print("Url ::: ${request.url}");

//             if (request.url.contains("/auth/login")) {
//               return getIt<ILocalStorageService>().removeItem(userDataBox, userTokenKey).then((value) {
//                 getIt<AppRouter>().replaceAll([const LoginRoute()]);
//                 return NavigationDecision.prevent;
//               });
//             }

//             if (request.url.contains("/auth/register")) {
//               return getIt<ILocalStorageService>().removeItem(userDataBox, userTokenKey).then((value) {
//                 getIt<AppRouter>().replaceAll([const RegisterRoute()]);
//                 return NavigationDecision.prevent;
//               });
//             }

//             if (request.url.contains("/auth/logout")) {
//               return getIt<ILocalStorageService>().removeItem(userDataBox, userTokenKey).then((value) {
//                 getIt<AppRouter>().replaceAll([const LoginRoute()]);
//                 return NavigationDecision.prevent;
//               });
//             }

//             // url.queryParameters['another'] = 'another';

//             // print("Modified Url ::: $url");
            
          
//             return NavigationDecision.navigate;
//           } catch (error) {
//             print(error);
//             return NavigationDecision.navigate;
//           }
//         },
//       )
//     );
//   }

//   @override
//   Widget build(BuildContext context) {

    
//     return Scaffold(
//       body: WillPopScope(
//         onWillPop: () async {
//           final canGoBack = await controller.canGoBack();
//           if (canGoBack ==  true) {
//             setLoading(true);
//             controller.goBack();
//             return false;
//           }
//           final res = await ToastAlert.showConfirmAlert(context, "Do you want to quit the app?", () {});
          
//           return res;
//         },
//         child: SafeArea(
//           child: Stack(
//             children: [
              
//               Positioned.fill(
//                 child: RefreshIndicator(
//                   onRefresh: () async => controller.reload(),
//                   child: WebViewWidget(
//                     controller: controller,
//                   ),
//                 ),
//               ),
//               if (_loading)
//                 Positioned.fill(
//                   child: Center(
//                     child: Assets.svgs.loader.svg(
//                       height: 30.h, width: 30.w
//                     ).animate(
//                       autoPlay: true,
//                       onComplete: (controller) => controller.repeat(),
//                     ).rotate(
//                       duration: 2.seconds
//                     ),
//                   ),
//                 )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }