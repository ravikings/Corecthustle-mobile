
import 'package:auto_route/auto_route.dart';
import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/data/models/user_model.dart';
import 'package:correct_hustle/core/locator.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:correct_hustle/core/state/base_provider.dart';
import 'package:correct_hustle/core/state/user_profile_provider.dart';
import 'package:correct_hustle/core/widgets/custom_error_widget.dart';
import 'package:correct_hustle/features/chat/data/model/user_contact_model.dart';
import 'package:correct_hustle/features/chat/state/chat_messages_provider.dart';
import 'package:correct_hustle/features/chat/state/message_player_state_provider.dart';
import 'package:correct_hustle/features/chat/state/send_message_provider.dart';
import 'package:correct_hustle/gen/assets.gen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ChatMessageBaseScreen extends StatefulWidget {
  const ChatMessageBaseScreen({
    super.key,
    required this.userId
  });

  final String userId;

  @override
  State<ChatMessageBaseScreen> createState() => _ChatMessageBaseScreenState();
}

class _ChatMessageBaseScreenState extends State<ChatMessageBaseScreen> {

  void loadUserDetail() async {
    // print(widget.userId);
    try {
      final token = await getIt<ILocalStorageService>().getItem(userDataBox, userTokenKey, defaultValue: null);
      final res = await getIt<Dio>().get("$appUrl/fetch/find-user/${widget.userId}", options: Options(
        headers: {
          "Authorization": "Bearer $token"
        }
      ));
      print("UserDetail ::: ${res.data}");
      await getIt<ILocalStorageService>().setItem(userDataBox, 'user_${widget.userId}', res.data['data']);
      otherUserState.toSuccess(UserModel.fromJson(res.data['data'])); setState(() {});
    } catch (error) {
      context.router.pop();
      rethrow;
    }
  }

  final otherUserState = ProviderActionState<dynamic>(data: null);

  @override
  void initState() {
    super.initState();
    loadUserFromCache();
  }

  void loadUserFromCache() async {
    try {
      final cachedUserDetail = await getIt<ILocalStorageService>().getItem(userDataBox, 'user_${widget.userId}', defaultValue: null);
      if (cachedUserDetail == null) {
        loadUserDetail();
      } else {
        otherUserState.toSuccess(UserModel.fromJson(cachedUserDetail)); setState(() {});
      }
    } catch (error) {
      loadUserDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final userProfileState = context.watch<UserProfileProvider>().userProfileState;
    return Scaffold(
      body: Consumer<UserProfileProvider>(
        builder: (context, value, child) {
          final userProfileState = value.userProfileState;
          if (userProfileState.isLoading() || otherUserState.isLoading()) {
            return Center(
              child: SizedBox(
                height: 40, width: 40,
                child: Assets.svgs.loader.svg(
                  height: 60.h, width: 60.w
                ).animate(
                  autoPlay: true,
                  onComplete: (controller) => controller.repeat(),
                ).rotate(
                  duration: 2.seconds
                ),
              ),
            );
          }
          if (userProfileState.isError() || otherUserState.isError()) {
            return CustomErrorWidget(message: "${otherUserState.message}\n${userProfileState.message}", onRefresh: () => value.loadUserDetail());
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => ChatMessagesProvider(
                  otherUserState.data,
                  userProfileState.data!,
                  getIt<ILocalStorageService>()
                ),
              ),
              ChangeNotifierProvider(
                create: (context) => SendMessageProvider(
                  otherUserState.data,
                  userProfileState.data!,
                  getIt<ILocalStorageService>()
                ),
              ),
              ChangeNotifierProvider(
                create: (context) => MessagePlayerStateProvider(),
              ),
            ],
            child: const AutoRouter(),
          );
        }
      ),
    );
  }
}