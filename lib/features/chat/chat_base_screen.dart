import 'package:auto_route/auto_route.dart';
import 'package:correct_hustle/features/chat/state/chat_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


@RoutePage()
class ChatBaseScreen extends StatelessWidget {
  const ChatBaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatListProvider(),
      child: const AutoRouter(),
    );
  }
}