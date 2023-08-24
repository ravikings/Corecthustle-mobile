
// // ignore_for_file: use_build_context_synchronously

// import 'dart:async';

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
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// // import 'package:webview_flutter/webview_flutter.dart';

// @RoutePage()
// class AppScreen extends StatefulWidget {
//   AppScreen({super.key, required this.url});

//   final String url;

//   @override
//   State<AppScreen> createState() => _AppScreenState();
// }

// class _AppScreenState extends State<AppScreen> {

//   bool _loading = true;
//   StreamSubscription? _stateStreamSubscription;
//   // double _percentageLoaded = 0;

//   void setLoading(bool loading) {
//     setState(() {
//       _loading = loading;
//     });
//   }

//   // final controller = WebViewController()
//   // ..setJavaScriptMode(JavaScriptMode.unrestricted)
//   // ..setBackgroundColor(const Color(0x00000000));

//   @override
//   void initState() {
//     super.initState();
//     _wrapTryCatch(_listenToStateChange);
//     _wrapTryCatch(_listenToUrlChanges);
//   }
//   //   controller.loadRequest(Uri.parse(widget.url));
//   //   controller.setNavigationDelegate(
//   //     NavigationDelegate(
//   //       onProgress: (int progress) {
//   //         // Update loading bar.
//   //         // print("Loading Progress ::: $progress");
//   //       },
//   //       onPageStarted: (String url) {
//   //         setLoading(true);
//   //       },
//   //       onPageFinished: (String url) {
//   //         setLoading(false);
//   //       },
//   //       onWebResourceError: (WebResourceError error) {},
//   //       onNavigationRequest: (NavigationRequest request) {
//   //         try {
//   //           setLoading(true);
//   //           // print("Url ::: ${request.url}");

//   //           if (request.url.contains("/auth/login")) {
//   //             return getIt<ILocalStorageService>().removeItem(userDataBox, userTokenKey).then((value) {
//   //               getIt<AppRouter>().replaceAll([const LoginRoute()]);
//   //               return NavigationDecision.prevent;
//   //             });
//   //           }

//   //           if (request.url.contains("/auth/register")) {
//   //             return getIt<ILocalStorageService>().removeItem(userDataBox, userTokenKey).then((value) {
//   //               getIt<AppRouter>().replaceAll([const RegisterRoute()]);
//   //               return NavigationDecision.prevent;
//   //             });
//   //           }

//   //           if (request.url.contains("/auth/logout")) {
//   //             return getIt<ILocalStorageService>().removeItem(userDataBox, userTokenKey).then((value) {
//   //               getIt<AppRouter>().replaceAll([const LoginRoute()]);
//   //               return NavigationDecision.prevent;
//   //             });
//   //           }

//   //           // url.queryParameters['another'] = 'another';

//   //           // print("Modified Url ::: $url");
            
          
//   //           return NavigationDecision.navigate;
//   //         } catch (error) {
//   //           print(error);
//   //           return NavigationDecision.navigate;
//   //         }
//   //       },
//   //     )
//   //   );
//   // }

//   final flutterWebviewPlugin = FlutterWebviewPlugin();

//   void _listenToUrlChanges() {
//     print("Listening for URL Change ::: ");
    
//     flutterWebviewPlugin.onUrlChanged.listen((String url) {
//       print("url ::: $url");
//       if (url.contains("/auth/login")) {
//         getIt<ILocalStorageService>().removeItem(userDataBox, userTokenKey).then((value) {
//           getIt<AppRouter>().replaceAll([const LoginRoute()]);
//         });
//       }

//       if (url.contains("/auth/register")) {
//         getIt<ILocalStorageService>().removeItem(userDataBox, userTokenKey).then((value) {
//           getIt<AppRouter>().replaceAll([const RegisterRoute()]);
//           // NavigationDecision.prevent;
//         });
//       }

//       if (url.contains("/auth/logout")) {
//         getIt<ILocalStorageService>().removeItem(userDataBox, userTokenKey).then((value) {
//           getIt<AppRouter>().replaceAll([const LoginRoute()]);
//           // NavigationDecision.prevent;
//         });
//       }
//     });
//   }

//   void _listenToStateChange() {
//     print("Listening for State Change ::: ");
//     flutterWebviewPlugin.onStateChanged.listen((event) {
//       print("Loading State ::: $_loading");
//       if (event.type == WebViewState.finishLoad) {
//         setLoading(false);
//       }
//       if (event.type == WebViewState.startLoad) {
//         setLoading(true);
//       }
//       if (event.type == WebViewState.shouldStart) {
//         setLoading(true);
//       }
//       if (event.type == WebViewState.abortLoad) {
//         setLoading(false);
//       }
//     });
//   }

//   void _wrapTryCatch(Function function) {
//     try {
//       function();
//     } catch (error) {
//       rethrow;
//     }
//   }

  


//   @override
//   Widget build(BuildContext context) {
//     print("Loading $_loading");
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: WillPopScope(
//         onWillPop: () async {
//           final canGoBack = await flutterWebviewPlugin.canGoBack();
//           if (canGoBack ==  true) {
//             setLoading(true);
//             flutterWebviewPlugin.goBack();
//             return false;
//           }
//           final res = await ToastAlert.showConfirmAlert(context, "Do you want to quit the app?", () {});
          
//           return res;
//         },
//         child: SafeArea(
//           child: Stack(
//             children: [
              
//               WebviewScaffold(
//                 // controller: controller,
//                 url: widget.url,
//                 initialChild: const BrowserLoading(),
//                 withZoom: true,
//                 withLocalStorage: true,
//                 withJavascript: true,
//                 withOverviewMode: true,
//                 debuggingEnabled: true,
//               ),
//               if (_loading)
//                 const Positioned.fill(
//                   child: BrowserLoading(),
//                 )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     flutterWebviewPlugin.close();
//     super.dispose();
//   }
// }

// class BrowserLoading extends StatelessWidget {
//   const BrowserLoading({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Assets.svgs.loader.svg(
//         height: 30.h, width: 30.w
//       ).animate(
//         autoPlay: true,
//         onComplete: (controller) => controller.repeat(),
//       ).rotate(
//         duration: 2.seconds
//       ),
//     );
//   }
// }