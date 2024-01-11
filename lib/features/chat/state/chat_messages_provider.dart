
import 'dart:convert';
import 'dart:io';

import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/data/models/user_model.dart';
import 'package:correct_hustle/core/interactions/alert.dart';
import 'package:correct_hustle/core/locator.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:correct_hustle/core/state/base_provider.dart';
import 'package:correct_hustle/features/chat/data/model/chat_message_model.dart';
import 'package:correct_hustle/features/chat/state/chat_list_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';


class ChatMessagesProvider extends ChangeNotifier {
  final UserModel otherUser;
  final UserModel? thisUser;
  final ILocalStorageService localStorageService;

  int page = 1;
  int totalMessage = 1;
  int lastPage = 1;
  String storageKey = "";
  String moreMessageStorageKey = "";

  
  ChatMessagesProvider(this.otherUser, this.thisUser, this.localStorageService) {
    print("Offer ::: ${thisUser!.toJson()}");
    storageKey = 'messages_${otherUser.id}${thisUser!.id}';
    moreMessageStorageKey = "${storageKey}_more";
    _listenToMessages();
    loadMessageFromCache();
  }

  List<types.Message> messages = [];
  
  final messagesState = ProviderActionState<List<types.Message>>();

  final pusher = PusherChannelsFlutter.getInstance();

  File? attachment;


  void addMessage(types.Message message) {
    try {
      messagesState.toSuccess([message, ...messagesState.data!]);
      messages.insert(0, message);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void loadMessageFromCache() async {
    try {
      final lastMessages = await getIt<ILocalStorageService>().getItem(userDataBox, storageKey, defaultValue: null);
      if (lastMessages == null) {
        loadMessages(true);
      } else {
        totalMessage = lastMessages['total'];
        lastPage = lastMessages['last_page'];
        final msgs = List.from(lastMessages['messages']).map((e) => MessageModel.fromJson(e));
        // print();
        messagesState.toSuccess(msgs.map((e) {
          return transformToChatMessage(e,  thisUser!, otherUser);
        }).toList());

        messages = messagesState.data ?? [];
        
        notifyListeners();
      }
    } catch (error) {
      loadMessages(true);
    }
  }
  void loadMoreMessageFromCache() async {
    try {
      // print("MarkAsRead ::: LoadingMessageFromCache ::: $lastPage $page");
      final moreMessages = await getIt<ILocalStorageService>().getItem(userDataBox, "${moreMessageStorageKey}_$page", defaultValue: null);
      if (moreMessages == null) {
        // print("MarkAsRead ::: CacheNotFound ::: $lastPage $page");
        loadMoreMessages(false);
      } else {
        // print("MarkAsRead ::: CacheFound ::: $lastPage $page");
        final msgs = List.from(moreMessages['messages']).map((e) => MessageModel.fromJson(e));
        messagesState.toSuccess(msgs.map((e) {
          return transformToChatMessage(e, thisUser!, otherUser);
        }).toList());
        messages = [...messages, ...(messagesState.data ?? []),];
        page += 1;
        notifyListeners();
      }
    } catch (error) {
      // print("MarkAsRead ::: CacheError ::: $lastPage $page ::: $error");
      loadMoreMessages(false);
    }
  }

  void _listenToMessages() async {
    try {
      final channelName = "private-chat.${thisUser!.id}";
      // print("Chat ::: ChannelName ::: $channelName");
      // print("Chat ::: ListenToMessages :::: ");
      await pusher.init(
        apiKey: "fd8e341790316fac7d06",
        cluster: "us2",
        authEndpoint: "${chatBaseUrl}auth",
        onAuthorizer: (channelName, socketId, options) async {
          // print("Chat ::: Authorization ::: $channelName $socketId $options");
          String token = await localStorageService.getItem(userDataBox, userTokenKey, defaultValue: null);
          var authUrl = "${chatBaseUrl}chat/auth";
          var result = await http.post(
            Uri.parse(authUrl),
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'Authorization': 'Bearer $token'
            },
            body: 'socket_id=$socketId&channel_name=$channelName',
          );
          // final data = jsonEncode(result.data);
          // print("Chat ::: Onauthorizer ::: ${result}");
          return jsonDecode(result.body);
        },
        onConnectionStateChange: onConnectionStateChange,
        onDecryptionFailure: onDecryptionFailure,
        onError: onError,
        onEvent: onEvent,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberAdded,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onSubscriptionError: onSubscriptionError,
      );
      
      // print("Chat ::: ListInitialize ::: Connected");
      final myChannel = await pusher.subscribe(
        channelName: channelName, 
        onEvent: (d) {
          try {
            // print('Chat ::: ${d.eventName.runtimeType}');
            // print("Chat ::: Event ::: ${d} ::: Subscription");
            if (d.eventName == 'mobile_messaging') {
              _receiveMessage(jsonDecode(d.data));
            }
          } catch (error) {
            // print("Chat ::: Error ::: $error");
            rethrow;
          }
        }, 
        onMemberAdded: (men) {
          // print("Chat ::: Member Added From Subscription");
        }, 
        onSubscriptionSucceeded: (d) {
          // print("Chat ::: Subscription succeeded ::: Subscription");
        },
        onSubscriptionError: (d) {
          // print("Chat ::: SubError ::: Subscription");
        },
      );
      // print("Chat ::: ListInitialize ::: Initialized");
      await pusher.connect();

      // myChannel.me
    } catch (error) {
      print("Chat ::: Error ::  ListenToMessages :::: $error");
      rethrow;
    }
  }


  void onError(String message, int? code, dynamic e) {
    print("Chat ::: onError: $message code: $code exception: $e");
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print("Chat ::: Connection: $currentState");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    print("Chat ::: onMemberRemoved: $channelName member: $member");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    print("Chat ::: onMemberAdded: $channelName member: $member");
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    print("Chat ::: onSubscriptionSucceeded: $channelName data: $data");
  }

  void onSubscriptionError(String message, dynamic e) {
    print("Chat ::: onSubscriptionError: $message Exception: $e");
  }

  void onEvent(PusherEvent event) {
    print("Chat ::: onEvent: $event");
  }

  void onDecryptionFailure(String event, String reason) {
    print("Chat ::: onDecryptionFailure: $event reason: $reason");
  }

  void loadMessages([bool reload = true]) async {
    try {
      // print("Loading messages");
      if (reload) messagesState.toLoading(); notifyListeners();
      final token = await getIt<ILocalStorageService>().getItem(userDataBox, userTokenKey, defaultValue: null);
      print('Token ::: $token ::: ${otherUser.id}');
      final res = await getIt<Dio>().post("${chatBaseUrl}fetchMessages", data: {
        "id": otherUser.id.toString(),
        'type': 'user',
        'page': page
      }, options: Options(
        headers: {
          "authorization": "Bearer $token"
        }
      ));
      // print("Message ::: ${res.data}");
      totalMessage = res.data['total'];
      lastPage = res.data['last_page'];
      getIt<ILocalStorageService>().setItem(userDataBox, storageKey, res.data);
      final msgs = List.from(res.data['messages']).map((e) => MessageModel.fromJson(e));
      // print();
      messagesState.toSuccess(msgs.map((e) {
        return transformToChatMessage(e, thisUser!, otherUser);
      }).toList());

      messages = messagesState.data ?? [];
      
      notifyListeners();
    } catch (error) {
      messagesState.toError("Error : $error");
      notifyListeners();
      rethrow;
    }
  }
  void loadMoreMessages([bool reload = true]) async {
    try {
      // print("MarkAsRead ::: Loading more messages $page ::: $lastPage ::: $totalMessage");
      if (reload) messagesState.toLoading(); notifyListeners();
      final token = await getIt<ILocalStorageService>().getItem(userDataBox, userTokenKey, defaultValue: null);
      print('Token ::: $token ::: ${otherUser.id}');
      final res = await getIt<Dio>().post("${chatBaseUrl}fetchMessages", data: {
        "id": otherUser.id.toString(),
        'type': 'user',
        'page': page + 1
      }, options: Options(
        headers: {
          "authorization": "Bearer $token"
        }
      ));
      // print("Message ::: ${res.data}");
      totalMessage = res.data['total'];
      await getIt<ILocalStorageService>().setItem(userDataBox, "${moreMessageStorageKey}_$page", res.data);
      final msgs = List.from(res.data['messages']).map((e) => MessageModel.fromJson(e));
      // print();
      messagesState.toSuccess(msgs.map((e) {
        return transformToChatMessage(e, thisUser!, otherUser);
      }).toList());

      messages = [...messages, ...(messagesState.data ?? [])];
      page += 1;
      notifyListeners();
    } catch (error) {
      messagesState.toError("Error : $error");
      notifyListeners();
      rethrow;
    }
  }

  void deleteMessage(BuildContext context, String messageId) async {
    try {
      ToastAlert.showErrorAlert("Deleting message");
      // print("DeleteMessage ::: ...");
      Fluttertoast.showToast(msg: "Deleting message");
      final token = await getIt<ILocalStorageService>().getItem(userDataBox, userTokenKey, defaultValue: null);
      final res = await getIt<Dio>().post("${chatBaseUrl}deleteMessage", data: FormData.fromMap({
        "id": messageId,
      }), options: Options(
        headers: {
          "authorization": "Bearer $token"
        }
      ));
      // print("DeleteMessage ::: Response ::: ${res.data}");
      Fluttertoast.showToast(msg: "Message deleted");
      loadMessages();
      context.read<ChatListProvider>().getChatList();
      notifyListeners();
    } catch (error) {
      // print("DeleteMessage ::: Error ::: $error");
      ToastAlert.showErrorAlert("Unable to delete message");
      rethrow;
    }
  }


  void _receiveMessage(dynamic data) {
    try {
      // print("RecievedData ::: $data");
      loadMessages(false);
      // pallytopit@gmail.com
      // addMessage(transformToChatMessage(MessageModel.fromJson(data['message'])));
      // print(data);
    } catch (error) {
      rethrow;
    }
  }

  void markMessagesAsRead() async {
    // makeSeen
    try {
      // print("MarkAsRead ::: Reached bottom ");
      final token = await getIt<ILocalStorageService>().getItem(userDataBox, userTokenKey, defaultValue: null);
      final res = await getIt<Dio>().post("${chatBaseUrl}makeSeen", data: FormData.fromMap({}), options: Options(
        headers: {
          "authorization": "Bearer $token"
        }
      ));
      // print("MarkAsRead ::: ${page < lastPage}  $page $lastPage");
      if (page < lastPage) {
        loadMoreMessageFromCache();
      }
    } catch (error) {
      rethrow;
    }
  }
}

  types.Message transformToChatMessage(MessageModel e, UserModel thisUser, UserModel otherUser) {
    // print("Chat :: Message :: ${e.toJson()}");
    types.User author = types.User(
      id: thisUser.id.toString(),
      imageUrl: thisUser.avatarId == null ? defaultProfilePicture : "$audioBaseUrl${thisUser?.avatarId}",
      lastName: thisUser.username,
      firstName: thisUser.username,
    );
    if (e.fromId == otherUser.id) {
      author = types.User(
        id: otherUser.id.toString(),
        imageUrl: otherUser.avatarId == null ? defaultProfilePicture : "$audioBaseUrl${otherUser.avatarId}",
        lastName: otherUser.username,
        firstName: otherUser.username,  
      );
    }
    final metaData = e.toJson();
    types.MessageType messageType = types.MessageType.text;
    types.Status status = types.Status.delivered;
    if (e.seen == 1) {
      status = types.Status.seen;
    }
    if (e.audioRecord != null) {
      return types.AudioMessage(
        id: e.id.toString(),
        author: author,
        metadata: metaData,
        showStatus: true,
        status: status,
        createdAt: e.createdAt!.millisecondsSinceEpoch,
        name: '',
        duration: const Duration(seconds: 60),
        size: 1000,
        uri: "$audioBaseUrl${e.audioRecord}",
      );
    }
    if (e.attachment != null) {
      messageType = types.MessageType.file;
      final attachment = jsonDecode(e.attachment);
      if (["png", "jpeg", "jpg"].contains(attachment['extension'])) {
        messageType = types.MessageType.image;
        return types.ImageMessage(
          id: e.id.toString(),
          author: author,
          metadata: metaData,
          type: messageType,
          name: attachment['old_name'],
          size: attachment['size'] ?? 0,
          uri: "$attachementBaseUrl${attachment['new_name']}",
          showStatus: true,
          status: status,
          createdAt: e.createdAt!.millisecondsSinceEpoch
        );
      }
      return types.FileMessage(
        id: e.id.toString(),
        author: author,
        metadata: metaData,
        type: messageType,
        name: attachment['old_name'],
        size: attachment['size'] ?? 0,
        uri: "$attachementBaseUrl${attachment['new_name']}",
        showStatus: true,
        status: status,
        createdAt: e.createdAt!.millisecondsSinceEpoch
      );
    }

    if (e.quotationId != null || e.customOfferId != null) {
      messageType = types.MessageType.custom;
      return types.CustomMessage(
        id: e.id.toString(),
        author: author,
        metadata: metaData,
        type: messageType,
        showStatus: true,
        status: status,
        createdAt: e.createdAt!.millisecondsSinceEpoch
      );
    }

    return types.TextMessage(
      id: e.id.toString(),
      author: author,
      metadata: metaData,
      type: messageType,
      text: e.body ?? "",
      showStatus: true,
      status: status,
      createdAt: e.createdAt!.millisecondsSinceEpoch
    );
  }