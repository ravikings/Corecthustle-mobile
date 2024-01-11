import 'package:auto_route/auto_route.dart';
import 'package:correct_hustle/core/state/user_profile_provider.dart';
import 'package:correct_hustle/features/chat/state/chat_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class AppBaseScreen extends StatelessWidget {
  const AppBaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ChangeNotifierProvider(create: (context) => ChatListProvider()),
      ],
      child: const AutoRouter()
    );
  }
}