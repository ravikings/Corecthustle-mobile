import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/locator.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:correct_hustle/core/state/base_provider.dart';
import 'package:correct_hustle/features/chat/data/model/user_contact_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ChatListProvider extends ChangeNotifier {

  ChatListProvider() {
    initialize();
  }

  final chatContactState = ProviderActionState<List<UserContactModel>>();


  void initialize() async {
    try {
      chatContactState.toLoading(); notifyListeners();
      getChatListFromCached();
    } catch (error) {
      print("ChatListInitialize ::: Error : $error");
    }
  }

  void getChatListFromCached() async {
    try {
      final userId = await getIt<ILocalStorageService>().getItem(userDataBox, userTokenKey, defaultValue: null);
      print("UserId ::: $userId");
      final chatList = await getIt<ILocalStorageService>().getItem(userDataBox, 'chat_list_$userId', defaultValue: null);
      if (chatList == null) {
        getChatList();
      } else {
        final contacts = List.from(chatList['contacts']);
        chatContactState.toSuccess(contacts.map((e) => UserContactModel.fromJson(e)).toList()); notifyListeners();
        notifyListeners();
        getChatList();
      }
    } catch (error) {
      print("ChatListFromCache ::: $error");
      getChatList();
    }
  }

  void getChatList() async {
    try {
      final token = await getIt<ILocalStorageService>().getItem(userDataBox, userTokenKey, defaultValue: null);
      print("UserToken ::: $token");
      final res = await getIt<Dio>().get("${chatBaseUrl}getContacts", options: Options(
        headers: {
          "authorization": "Bearer $token"
        }
      ));
      final contacts = List.from(res.data['contacts']);
      chatContactState.toSuccess(contacts.map((e) => UserContactModel.fromJson(e)).toList()); notifyListeners();
      // print("Contacts ::: ${contacts.first}");

      final userId = await getIt<ILocalStorageService>().getItem(userDataBox, userTokenKey, defaultValue: null);
      await getIt<ILocalStorageService>().setItem(userDataBox, 'chat_list_$userId', res.data);
    } catch (error) {
      chatContactState.toError("Error: $error"); notifyListeners();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // chatList!.cancel();
    super.dispose();
  }

}