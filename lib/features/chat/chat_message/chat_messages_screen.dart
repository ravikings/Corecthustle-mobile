import 'dart:ffi';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:correct_hustle/core/routes/routes.gr.dart';
import 'package:correct_hustle/core/state/user_profile_provider.dart';
import 'package:correct_hustle/core/utils/extensions.dart';
import 'package:correct_hustle/core/widgets/custom_error_widget.dart';
import 'package:correct_hustle/features/app/presentation/screen/app_screen.dart';
import 'package:correct_hustle/features/chat/state/chat_messages_provider.dart';
import 'package:correct_hustle/features/chat/state/send_message_provider.dart';
import 'package:correct_hustle/features/chat/widgets/audio_message_widget.dart';
import 'package:correct_hustle/features/chat/widgets/chat_input_widget.dart';
import 'package:correct_hustle/features/chat/widgets/chat_offer_widget.dart';
import 'package:correct_hustle/features/chat/widgets/chat_quotation_widget.dart';
import 'package:correct_hustle/features/chat/widgets/message_options.dart';
import 'package:correct_hustle/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;


Widget testFunction(types.Message message, {required BuildContext context}){
  return Container();
}

@RoutePage()
class ChatMessagesScreen extends StatelessWidget {
  const ChatMessagesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final chatMessagesProvider = context.watch<ChatMessagesProvider>();
    final sendMessagesProvider = context.watch<SendMessageProvider>();
    final userProfile = context.watch<UserProfileProvider>().userProfileState.data!;
    final otherUser = chatMessagesProvider.otherUser;

    final user = types.User(
      id: userProfile.id.toString(),
      firstName: userProfile.firstName,
      lastName: userProfile.lastName,
      imageUrl: userProfile.avatarId
    );
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1F47F5),
            ),
            padding: const EdgeInsets.fromLTRB(16, 55, 16, 15),
            child: Row(
              children: [
                InkWell(
                  onTap: () => context.router.pop(),
                  child: const Icon(Icons.arrow_back, color: Color(0xFFF6F7F6),)
                ),
                16.toRowSpace(),
                Row(
                  children: [
                    Text("${otherUser.username ?? "Anonymous"}".firstToUpper(), style: TextStyle(
                      fontSize: 16.sp, fontWeight: FontWeight.w700, color: const Color(0xFFF6F7F6),
                    ),),
                    10.toRowSpace(),

                    if (otherUser.isSupport == true) Text("SUPPORT", style: TextStyle(
                      fontSize: 10.sp, fontWeight: FontWeight.w900, color: const Color(0xFFF18522)
                    ),),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(),
          
          Expanded(
            child: Builder(
              builder: (context) {
                final chatMessageState = chatMessagesProvider.messagesState;
                if (chatMessageState.isLoading()) {
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
                // if (chatMessageState.isError()) {
                //   return CustomErrorWidget(
                //     message: "Service unavailable at the moment.",
                //     onRefresh: () => chatMessagesProvider.loadMessages(),
                //   );
                // }
                // return Container(
                //   height: 100, color: Colors.green,
                // );
                return Chat(
                  messages: chatMessagesProvider.messages,
                  onSendPressed: (t) {
                    sendMessagesProvider.sendMessage(t.text, context);
                  },
                  user: user,
                  scrollToUnreadOptions: const ScrollToUnreadOptions(),
                  audioMessageBuilder: (message, {required int messageWidth}) {
                    return AudioMessageWidget(message: message);
                  },
                  customMessageBuilder: (types.CustomMessage message, {required int messageWidth}){
                    final metadata = message.metadata!;
                    print("Chat ::: Metadata ::: $metadata");
                    // if (metadata!['audio_record'] != null) {
                    //   return AudioMessageWidget(message: message);
                    // }
                    if (metadata['quotation_id'] != null) {
                      return ChatQuotationWidget(quotationId: metadata['quotation_id'].toString());
                    }
                    if (metadata['custom_offer_id'] != null) {
                      return ChatOfferWidget(quotationId: metadata['custom_offer_id'].toString());
                    }
                    return const SizedBox.shrink();
                  },
                  onAttachmentPressed: () =>  sendMessagesProvider.handleAttachmentPressed(context),
                  inputOptions: const InputOptions(
                    enableSuggestions: true,
                    sendButtonVisibilityMode: SendButtonVisibilityMode.always,
                  ),
                  customBottomWidget: const ChatInputWidget(),
                  onMessageTap: (ctx, message) {
                    print("MessageMeta ::: ${message.metadata}");
                    if (userProfile.id.toString() == message.author.id) {
                      showModalBottomSheet(context: context, builder: (context) => MessageOptionesWidget(
                        message: message,
                        provider: chatMessagesProvider,
                      ));
                    }
                  },
                  showUserAvatars: true,
                  theme: const DefaultChatTheme(
                    backgroundColor: Color(0xFFF6F7F6),
                    messageBorderRadius: 15,
                    messageInsetsHorizontal: 15, messageInsetsVertical: 10,
                    inputBackgroundColor: Color(0xFF1F47F5),
                    primaryColor: Color(0xFF1F47F5),
                    secondaryColor: Color(0xFFF18522),
                    sentMessageBodyTextStyle: TextStyle(
                      color: Colors.white
                    ),
                    receivedMessageBodyTextStyle: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  avatarBuilder: (u) {
                    return GestureDetector(
                      onTap: () => context.router.push(AppRoute(url: 'https://pallytopit.com.ng/profile/${u.firstName}', canExitFreely: true)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 10
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: CircleAvatar(
                            child: CachedNetworkImage(imageUrl: u.imageUrl!),
                          ),
                        ),
                      ),
                    );
                  },
                  onEndReached: () async {
                    chatMessagesProvider.markMessagesAsRead();
                  },
                  dateHeaderThreshold: 1000 * 60,
                  customDateHeaderText: (d) {
                    return "${timeago.format(d, allowFromNow: true)}";
                  },
                  dateHeaderBuilder: (d) {
                    return Container(
                      padding: const EdgeInsets.only(right: 25, bottom: 0, top: 20),
                      alignment: Alignment.center,
                      child: Text(d.text, style: TextStyle(
                        fontSize: 10.sp, fontWeight: FontWeight.w100,
                      ),)
                    );
                  },
                  typingIndicatorOptions: const TypingIndicatorOptions(
                    typingMode: TypingIndicatorMode.name,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}