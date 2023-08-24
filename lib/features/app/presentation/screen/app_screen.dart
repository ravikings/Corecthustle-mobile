
// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/interactions/alert.dart';
import 'package:correct_hustle/core/locator.dart';
import 'package:correct_hustle/core/routes/routes.dart';
import 'package:correct_hustle/core/routes/routes.gr.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:correct_hustle/gen/assets.gen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_webview/fl_webview.dart';


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
    super.initState();
  }

  bool _listenToUrlChanges(String url) {
    setLoading(true);
    // print("Listening for URL Change ::: ");
    
    print("url ::: $url");
    if (url.contains("/auth/login")) {
      getIt<ILocalStorageService>().removeItem(userDataBox, userTokenKey).then((value) {
        getIt<AppRouter>().replaceAll([const LoginRoute()]);
      });
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
      
      return false;
    }
    return true;
  }

  void _wrapTryCatch(Function function) {
    try {
      function();
    } catch (error) {
      rethrow;
    }
  }

  


  @override
  Widget build(BuildContext context) {
    // print("Loading $_loading");
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
              if (canGoBack!) {
                setLoading(true);
                controller!.goBack();
                res = false;
              } else {
                res = await ToastAlert.showConfirmAlert(context, "Do you want to quit the app?", () {});
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
              FlWebView(
                webSettings: WebSettings(
                  javascriptMode: JavascriptMode.unrestricted,
                  allowsAutoMediaPlayback: true,
                  allowsInlineMediaPlayback: true,
                ),
                load: LoadUrlRequest(widget.url),
                delegate: FlWebViewDelegate(
                  onPageStarted: (controller, url) {
                    setLoading(true);
                    _wrapTryCatch(() => _listenToUrlChanges(url!));
                  },
                  onProgress: (controller, progress) => setLoading(progress != 100),
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
                ),
                onWebViewCreated: (ctr) => setState(() {
                  controller = ctr;
                }),
              ),
              if (_loading)
                const Positioned.fill(
                  child: BrowserLoading(),
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