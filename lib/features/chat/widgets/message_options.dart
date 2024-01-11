import 'package:correct_hustle/core/interactions/alert.dart';
import 'package:correct_hustle/features/chat/state/chat_messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chatUITypes;

class MessageOptionesWidget extends StatelessWidget {
  const MessageOptionesWidget({
    super.key, 
    required this.message,
    required this.provider
  });

  final chatUITypes.Message message;
  final ChatMessagesProvider provider;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  try {
                    Navigator.pop(context);
                    final delete = await ToastAlert.showConfirmAlert(context, "Are you sure you want to delete this message?");
                    if (delete) {
                      provider.deleteMessage(context, message.metadata?['id']);
                    }
                  } catch (error) {
                    print("DeleteMessage ::: ConfirmError");
                    rethrow;
                  }
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Delete'),
                ),
              ),
              
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
    );
  }
}