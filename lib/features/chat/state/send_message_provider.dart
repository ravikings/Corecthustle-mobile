
import 'dart:io';

import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/data/models/user_model.dart';
import 'package:correct_hustle/core/interactions/alert.dart';
import 'package:correct_hustle/core/locator.dart';
import 'package:correct_hustle/core/routes/routes.dart';
import 'package:correct_hustle/core/routes/routes.gr.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:correct_hustle/core/state/base_provider.dart';
import 'package:correct_hustle/features/chat/data/model/chat_offer_model.dart';
import 'package:correct_hustle/features/chat/data/model/gig_model.dart';
import 'package:correct_hustle/features/chat/data/model/quote_model.dart';
import 'package:correct_hustle/features/chat/data/model/user_contact_model.dart';
import 'package:correct_hustle/features/chat/state/chat_list_provider.dart';
import 'package:correct_hustle/features/chat/state/chat_messages_provider.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/v4.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class SendMessageProvider extends BaseProvider {
  final UserModel otherUser;
  final UserModel? thisUser;
  final ILocalStorageService localStorageService;
  
  SendMessageProvider(
    this.otherUser,
    this.thisUser,
    this.localStorageService
  );

  File? attachment;
  File? attachmentToSend;

  void selectAttachment(BuildContext context) async {
    final file = await FilePicker.platform.pickFiles();
    if (file != null) {
      attachment = File(file.files.first.path!);
      attachmentToSend = File(file.files.first.path!);
      // sendMessage(null, context);
      notifyListeners();
    }
  }

  void removeAttachment() {
    attachment = null;
    quote = null;
    offer = null;
    isAudio = false;
    notifyListeners();
  }

  QuoteModel? quote;
  GigModel? offer;
  bool isAudio = false;

  void setQuote(QuoteModel q) {
    quote = q;
    notifyListeners();
  }

  void sendMessage(String? chatMessage, BuildContext context) async {
    try {
      context.read<ChatMessagesProvider>().addMessage(types.TextMessage(
        text: "...",
        author: types.User(
          id: thisUser!.id.toString(),
          imageUrl: thisUser?.avatarId == null ? defaultProfilePicture : "$audioBaseUrl${thisUser?.avatarId}",
          lastName: thisUser!.username,
          firstName: thisUser!.username,
        ),
        id: 'temp_id',
        previewData: types.PreviewData(
          description: message ?? "...",
        ),
        status: types.Status.sending
      ));
      attachment = null; notifyListeners();
      getIt<Dio>().interceptors.add(PrettyDioLogger(
        canShowLog: true, requestBody: true, responseBody: true, responseHeader: true, requestHeader: true
      ));
      // print("Quotation ::: ${quote?.toJson()}");
      final token = await getIt<ILocalStorageService>().getItem(userDataBox, userTokenKey, defaultValue: null);
      Map<String, dynamic> data = {
        "id": otherUser.id.toString(),
        "type": "user",
        "message": chatMessage ?? "...",
        "temp": const UuidV4().generate(),
        "quotation": quote == null ? "" : quote!.id
      };
      if (attachmentToSend != null) {
        ToastAlert.showLoadingAlert("");
        if (isAudio) {
          data['audio'] = MultipartFile.fromFileSync(attachmentToSend!.path);
        } else {
          data['file'] = MultipartFile.fromFileSync(attachmentToSend!.path) ;
        }
      }
      if (offer != null) {
        ToastAlert.showLoadingAlert("");
        data['offer'] = {
          'gig_id': offer!.id,
          'description': offer!.description,
          'offer_amount': offer!.price,
          'delivery_time': offer!.deliveryTime
        };
      }
      print("UserDetail ::: $data");
      final res = await getIt<Dio>().post("${chatBaseUrl}sendMessage", data: FormData.fromMap(data), options: Options(
        headers: {
          "authorization": "Bearer $token"
        }
      ));
      ToastAlert.closeAlert();
      print("SendMessage ::: Response ::: ${res.data}");
      attachment = null;
      attachmentToSend = null;
      offer = null;
      quote = null;
      isAudio = false;
      context.read<ChatMessagesProvider>().loadMessages(false);
      context.read<ChatListProvider>().getChatList();
      notifyListeners();
    } on DioException catch (error) {
      print("SendMessage ::: Error ::: ${error.response!.data}");
      rethrow;
    } catch (error) {
      print("SendMessage ::: Error ::: $error");
      rethrow;
    }
  }

  void _handleFileSelection(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      attachment = File(result.files.first.path!);
      attachmentToSend = File(result.files.first.path!);
      // sendMessage(null, context);
      notifyListeners();
    }
  }

  void _handleImageSelection(BuildContext context) async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      attachment = File(result.path);
      attachmentToSend = File(result.path);
      // sendMessage(null, context);
      notifyListeners();
    }
  }


  void handleAttachmentPressed(BuildContext context) {
    // print(thisUser!.toJson());
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext ctx) => SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _handleImageSelection(context);
              },
              child: const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text('Photo'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _handleFileSelection(context);
              },
              child: const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text('File'),
              ),
            ),
            if ((thisUser!.accountType == "seller" && otherUser.isSupport == false)) ...[
              if (thisUser!.isSupport == false) ...[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // _handleFileSelection(context);
                  getIt<AppRouter>().push(const SelectQuotesRoute());
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Quotation'),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  // _handleFileSelection(context);
                  final selectedOffer = await getIt<AppRouter>().push(const SelectOfferRoute());
                  if (selectedOffer != null) {
                    offer = selectedOffer as GigModel;
                    sendMessage(null, context);
                  }
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Custom Offer'),
                ),
              ),
            ]],
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