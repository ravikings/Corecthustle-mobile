
// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/interactions/alert.dart';
import 'package:correct_hustle/core/locator.dart';
import 'package:correct_hustle/core/routes/routes.dart';
import 'package:correct_hustle/core/routes/routes.gr.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:correct_hustle/core/styles/colors.dart';
import 'package:correct_hustle/core/utils/extensions.dart';
import 'package:correct_hustle/gen/assets.gen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_webview/fl_webview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';


@RoutePage()
class AppScreen extends StatefulWidget {
  AppScreen({super.key, required this.url, this.canExitFreely = false});

  final String url;
  final bool canExitFreely;

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {

  bool _loading = true;
  bool _errorOccurred = false;
  String _errorMessage = "";

  String _url = "";

  void setLoading(bool loading) {
    setState(() {
      _loading = loading;
    });
  }

  void setErrorMessage(bool errorState, String message) {
    setState(() {
      _errorOccurred = errorState;
      _errorMessage = message;
      _loading = false;
    });
  }

  FlWebViewController? controller;

  @override
  void initState() {
    _url = widget.url;
    super.initState();
  }

  bool _listenToUrlChanges(String url) {
    setLoading(true);
    // print("Listening for URL Change ::: ");
    
    print("url ::: $url");
    if (url.startsWith("https://pallytopit.com.ng")) {
      setState(() {
        _url = url;
      });
      if (url.contains("/auth/login")) {
        getIt<ILocalStorageService>().removeItem(userDataBox, userTokenKey).then((value) {
          getIt<AppRouter>().replaceAll([const LoginRoute()]);
        });
        return false;
      }
      if (url.contains("/inbox")) {
        final seperate = url.split("/");
        if (seperate.last == "inbox") {
          getIt<AppRouter>().push(const ChatBaseRoute());
        } else {
          getIt<AppRouter>().push(ChatBaseRoute(
            children: [
              const ChatListRoute(),
              ChatMessageBaseRoute(userId: seperate.last)
            ]
          ));
        }
        setLoading(false);
        return false;
      }

      if (url.contains("/auth/register")) {
        getIt<ILocalStorageService>().removeItem(userDataBox, userTokenKey).then((value) {
          getIt<AppRouter>().replaceAll([const RegisterRoute()]);
          // NavigationDecision.prevent;
        });
        return false;
      }

      if (url.contains("/auth/logout")) {
        controller!.clearCache();
        // controller
        controller!.evaluateJavascript("""(function () {
      var cookies = document.cookie.split("; ");
      for (var c = 0; c < cookies.length; c++) {
          var d = window.location.hostname.split(".");
          while (d.length > 0) {
              var cookieBase = encodeURIComponent(cookies[c].split(";")[0].split("=")[0]) + '=; expires=Thu, 01-Jan-1970 00:00:01 GMT; domain=' + d.join('.') + ' ;path=';
              var p = location.pathname.split('/');
              document.cookie = cookieBase + '/';
              while (p.length > 0) {
                  document.cookie = cookieBase + p.join('/');
                  p.pop();
              };
              d.shift();
          }
      }
  })()""").then((value) {
              getIt<ILocalStorageService>().removeItem(userDataBox, userTokenKey).then((value) {
                getIt<AppRouter>().replaceAll([const LoginRoute()]);
                // NavigationDecision.prevent;
              });
        });
      }
      
      return true;
    }
    // print(url);
    // if (url.startsWith("https://api.whatsapp.com/send")) {

    // }
    // print("NoMatchFound ::: $url");
    launchUrl(Uri.parse(url), mode: LaunchMode.externalNonBrowserApplication).then((value) => setLoading(false));
    return false;
  }

  void _wrapTryCatch(Function function) {
    try {
      function();
    } catch (error) {
      rethrow;
    }
  }
  
  int currentPage = 0;

  void setCurrentPage(int page) {
    setState(() {
      currentPage = page;
    });
  }


  @override
  Widget build(BuildContext context) {
    print("CurrentUrl $_url");
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          try {
            if (widget.canExitFreely) {
              return true;
            }
            bool res = false;
            if (controller != null) {
              final canGoBack = await controller!.canGoBack();
              print("CanGobank ::: $canGoBack");
              if (canGoBack == true) {
                setLoading(true);
                controller!.goBack();
                res = false;
              } else {
                res = await ToastAlert.showConfirmAlert(context, "Do you want to quit the app?");
              }
            }
            return res;
          } on Exception catch (e) {
            // TODO
            print("Error: $e");
            rethrow;
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                top: 0, left: 0, right: 0,
                bottom: 0,
                child: FlWebView(
                  // progressBar: FlProgressBar(
                  //   color: Colors.red,
                  //   height: 10
                  // ),
                  webSettings: WebSettings(
                    javascriptMode: JavascriptMode.unrestricted,
                    allowsAutoMediaPlayback: true,
                    allowsInlineMediaPlayback: true,
                    enabledDebugging: true
                  ),
                  load: LoadUrlRequest(widget.url, headers: {
                    '': ''
                  }),
                  
                  delegate: FlWebViewDelegate(
                    onPageStarted: (controller, url) {
                      setLoading(true);
                      _wrapTryCatch(() => _listenToUrlChanges(url!));
                    },
                    onProgress: (controller, progress) {
                      setLoading(progress != 100);
                    },
                    onPageFinished: (controller, url) => setLoading(false),
                    onShowFileChooser: (controller, params) async {
                      print('onShowFileChooser : ${params.toMap()}');
                
                      /// Select file
                      FileType fileType = FileType.any;
                      if (params.acceptTypes.toString().contains('image')) {
                        fileType = FileType.image;
                      }
                      if (params.acceptTypes.toString().contains('video')) {
                        fileType = FileType.video;
                      }
                      if (params.acceptTypes.toString().contains('file')) {
                        fileType = FileType.any;
                      }
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: fileType,
                        allowMultiple: params.mode == FileChooserMode.openMultiple
                      );
                      final list = result?.files.where((item) => item.path != null).map((item) => item.path!).toList();
                      return list ?? [];
                    },
                    onUrlChanged: (controller, url) => _listenToUrlChanges(url!),
                    onNavigationRequest: (controller, request) => _listenToUrlChanges(request.url),
                    onWebResourceError: (controller, error) {
                      setErrorMessage(true, error.description);
                    },
                    onPermissionRequest: (_, resources) {
                      // controller.applyWebSettings
                      // print("Resource Requested ::: $resources");
                      // Permission.microphone.request();
                      return true;
                    },
                    onPermissionRequestCanceled: (_, resources) {
                      print("CancelledPermission ::: $resources");
                    },
                  ),
                  onWebViewCreated: (ctr) async {
                    String userAgentString = 'userAgentString';
                    final value = await ctr.getNavigatorUserAgent();
                    // print('navigator.userAgent :  $value');
                    userAgentString = '$value = $userAgentString';
                    final userAgent = await ctr.setUserAgent(userAgentString);
                    // print('set userAgent:  $userAgent');
                    // onWebViewCreated?.call(controller);
                    setState(() {
                      controller = ctr;
                    });
                  },
                  
                ),
              ),
              if (_loading)
                const Positioned(
                  left: 0, right: 0, top: 0,
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    color: primaryColor,
                  ),
                  // child: BrowserLoading(),
                ),
              if (_errorOccurred)
                Positioned.fill(
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Text(_errorMessage),
                    )
                  ),
                ),

              Positioned(
                left: 0, right: 0, bottom: 0,
                child: (_url.isHomePage()) ? Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.circular(16)
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  // margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () async {
                          setCurrentPage(0);
                          final token = await getIt<ILocalStorageService>().getItem(userDataBox, userTokenKey, defaultValue: null);
                          controller!.loadUrl(LoadUrlRequest("$appUrl?token=$token&hst_footer=false"));
                        },
                        child: BottomNavItem(
                          label: "Home", 
                          icon: Assets.svgs.homeIcon.path,
                          isActive: currentPage == 0,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          context.router.push(ChatBaseRoute());
                        },
                        child: BottomNavItem(
                          label: "Inbox", 
                          icon: Assets.svgs.messageIcon.path
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context, 
                            isDismissible: true,
                            enableDrag: true,
                            isScrollControlled: true,
                            builder: (context) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  )
                                ),
                                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text("Explore", style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: primaryColor, fontSize: 18.sp
                                    ),),
                                    16.toColumSpace(),

                                    GestureDetector(
                                      onTap: () {
                                        setCurrentPage(2);
                                        setLoading(true);
                                        Navigator.pop(context);
                                        controller!.loadUrl(LoadUrlRequest("https://pallytopit.com.ng/search"));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 12),
                                        child: Text("Explore Gigs")
                                      ),
                                    ),
                                    2.toColumSpace(),
                                    GestureDetector(
                                      onTap: () {
                                        setCurrentPage(2);
                                        setLoading(true);
                                        Navigator.pop(context);
                                        controller!.loadUrl(LoadUrlRequest("https://pallytopit.com.ng/explore/projects"));
                                      },
                                      child: const Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        child: Text("Explore Projects"),
                                      ),
                                    ),
                                    // 16.toColumSpace(),
                                  ],
                                ),
                              );
                            }
                          );
                        },
                        child: BottomNavItem(
                          label: "Explore", 
                          icon: Assets.svgs.exploreIcon.path,
                          isActive: currentPage == 2,
                        ),
                      ),

                      // InkWell(
                      //   onTap: () {
                      //     setCurrentPage(3);
                      //     // context.router.push(ChatBaseRoute());
                      //   },
                      //   child: BottomNavItem(
                      //     label: "Alert", icon: Icons.mail_rounded,
                      //     isActive: currentPage == 3,
                      //   ),
                      // ),
                    ],
                  ),
                ) : Container(),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // flutterWebviewPlugin.close();
    super.dispose();
  }
}

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
    super.key,
    required this.label,
    required this.icon,
    this.isActive = false
  });

  final String icon;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icon(icon, color: isActive ? Colors.white : primaryColor,),
        SvgPicture.asset(icon, color: isActive ? primary : null,),
        4.toColumSpace(),
        Text(label, style: TextStyle(
          fontWeight: FontWeight.w700,
          color: isActive ? primary : Color(0xFF94A3B8),
          fontSize: 10.sp
        ),)
      ],
    );
  }
}


class BrowserLoading extends StatelessWidget {
  const BrowserLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Assets.svgs.loader.svg(
        height: 30.h, width: 30.w
      ).animate(
        autoPlay: true,
        onComplete: (controller) => controller.repeat(),
      ).rotate(
        duration: 2.seconds
      ),
    );
  }
}