import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/locator.dart';
import 'package:correct_hustle/core/routes/routes.dart';
import 'package:correct_hustle/core/routes/routes.gr.dart';
import 'package:correct_hustle/core/styles/input_style.dart';
import 'package:correct_hustle/core/utils/extensions.dart';
import 'package:correct_hustle/core/widgets/custom_error_widget.dart';
import 'package:correct_hustle/features/chat/state/chat_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({
    super.key
  });

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // print("ChatLIstSce");
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1F47F5),
            ),
            padding: EdgeInsets.fromLTRB(16, 55, 16, 15),
            child: Row(
              children: [
                InkWell(
                  onTap: () => context.router.pop(),
                  child: const Icon(Icons.arrow_back, color: Color(0xFFF6F7F6),)
                ),
                16.toRowSpace(),
                Row(
                  children: [
                    Text("Chats".firstToUpper(), style: TextStyle(
                      fontSize: 16.sp, fontWeight: FontWeight.w700, color: Color(0xFFF6F7F6),
                    ),),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(),

          16.toColumSpace(),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextFormField(
              decoration: defaultInputDecoration.copyWith(
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: const Icon(Icons.search),
                ),
                hintText: "Search user",
                constraints: BoxConstraints(
                  maxHeight: 48.h, minHeight: 48.h
                ),
              ),
              textAlignVertical: TextAlignVertical.center,
              onChanged: (v) => setState(() {}),
              controller: searchController,
            ),
          ),
          16.
          toColumSpace(),

          Expanded(
            child: Consumer<ChatListProvider>(
              builder: (context, value, child) {
                final chatListState = value.chatContactState;
                if (chatListState.isLoading()) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (chatListState.isError()) {
                  return CustomErrorWidget(
                    message: "${chatListState.message}",
                    onRefresh: () => value.getChatList(),
                  );
                }
                final data = (chatListState.data ?? []).where(
                  (element) => 
                    element.user!.username!.toLowerCase().contains(searchController.text.toLowerCase()) ||
                    element.user!.lastName!.toLowerCase().contains(searchController.text.toLowerCase()) ||
                    element.user!.firstName!.toLowerCase().contains(searchController.text.toLowerCase()) 
                ).toList();

                if (data.isEmpty) {
                  return const Center(
                    child: Text("You have not sent a message to anyone"),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => value.getChatList(),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final chat = data[index];
                      final profileImage = chat.user!.avatarId == null ? defaultProfilePicture : "$audioBaseUrl${chat.user!.avatarId}";
                      return ListTile(
                        leading: CircleAvatar(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: CachedNetworkImage(
                              imageUrl: profileImage,
                              errorWidget: (ctx, str, obj) {
                                return const Icon(Icons.person);
                              },
                            ),
                          ),
                        ),
                        title: Text("${chat.user!.username ?? "Anonymous"}".firstToUpper(), style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w600
                        ),),
                        subtitle: Builder(
                          builder: (context) {
                            if (chat.lastMessage == null) {
                              return SizedBox.shrink();
                            }
                            if (chat.lastMessage!.customOfferId != null) {
                              return Text(("Offer"), style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic
                              ),);
                            }
                            if (chat.lastMessage!.quotationId != null) {
                              return Text(("Quote"), style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic
                              ),);
                            }
                            return Text((chat.lastMessage != null ? chat.lastMessage!.body ?? "" : ""), style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w100,
                              fontStyle: FontStyle.italic
                            ),);
                          }
                        ),
                        onTap: () => getIt<AppRouter>().push(ChatMessageBaseRoute(
                          userId: chat.user!.uid!,
                          children: const [
                            ChatMessagesRoute()
                          ]
                        )),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.0),
                        child: Divider(
                          height: 1, thickness: .2,
                        ),
                      );
                    },
                  ),
                );
              }
            ),
          )
        ],
      )
    );
  }
}