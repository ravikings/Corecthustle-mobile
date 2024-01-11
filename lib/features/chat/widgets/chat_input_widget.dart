import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/styles/colors.dart';
import 'package:correct_hustle/core/utils/extensions.dart';
import 'package:correct_hustle/features/chat/state/send_message_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ChatInputWidget extends StatefulWidget {
  const ChatInputWidget({super.key});

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  bool recording = false;
  final messageController = TextEditingController();


  RecorderController controller = RecorderController(); 

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      controller.onRecorderStateChanged.listen((event) {
        setState(() {
          recording = event.isRecording;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final sendMessageProvider = context.watch<SendMessageProvider>();
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF6F7F6),
        border: Border(
          top: BorderSide(color: primaryColor.withOpacity(.2), width: 1)
        )
      ),
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          if (sendMessageProvider.attachment != null) ...[
            Row(
              children: [
                InkWell(
                  onTap: () => sendMessageProvider.removeAttachment(),
                  child: Icon(Icons.close)
                ),
                10.toRowSpace(),
                if (sendMessageProvider.attachment!.isImage)
                  Image.file(
                    sendMessageProvider.attachment!,
                    height: 20, width: 40,
                  ),
                10.toRowSpace(),
                Expanded(
                  child: Text("${sendMessageProvider.attachment!.path.split("/").last}"),
                )
              ],
            ).animate().fadeIn()
          ],
          if (sendMessageProvider.quote != null) ...[
            Row(
              children: [
                InkWell(
                  onTap: () => sendMessageProvider.removeAttachment(),
                  child: Icon(Icons.close)
                ),
                10.toRowSpace(),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(4)
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ref: ${sendMessageProvider.quote!.reference}"),
                        Text("${moneyFormatter.format(num.parse(sendMessageProvider.quote!.total ?? "0"))}"),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: Text("${sendMessageProvider.quote!.paid == true ? "Paid" : "Unpaid"}", style: TextStyle(
                            fontSize: 10.sp, fontWeight: FontWeight.w400, color: Colors.white
                          ),)),
                      ],
                    ),
                  ),
                )

              ],
            )
          ],
          Row(
            children: [
              InkWell(
                onTap: () => sendMessageProvider.handleAttachmentPressed(context),
                child: const Icon(Icons.add, color: secondarryColor,)),
              10.toRowSpace(),
              Expanded(
                child: recording ? Container(
                  child: AudioWaveforms(
                    size: Size(MediaQuery.of(context).size.width, 40.0),
                    recorderController: controller,
                    enableGesture: true,
                    waveStyle: WaveStyle(
                      waveColor: secondarryColor.withOpacity(.3),
                      middleLineColor: primaryColor.withOpacity(.3)
                    ),
                  ),
                ) : TextFormField(
                  decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none
                  ),
                  maxLines: 5,
                  minLines: 1,
                  controller: messageController,
                ),
              ),
          
              
              if (!recording) ...[
                InkWell(
                  onTap: () {
                    context.read<SendMessageProvider>().sendMessage(messageController.text, context);
                    messageController.clear();
                  },
                  child: Icon(Icons.send, color: primaryColor,).animate().fadeIn()
                ),
                10.toRowSpace(),
                if (messageController.text.isEmpty) InkWell(
                  onTap: () async {
                    try {
                      final dir = await getApplicationDocumentsDirectory();
                      final path = "$dir/recording.mp3";
                      print(path);
                      controller.record();
                      print("AudioRecording ::: Recording");
                    } catch (error) {
                      print("AudioRecording ::: $error");
                      rethrow;
                    }
                  },
                  child: Icon(
                    Icons.mic,
                    color: secondarryColor,
                  ).animate().fadeIn()
                )
              ],
          
              if (recording) ...[
                InkWell(
                  onTap: () async {
                    // context.read<SendMessageProvider>().sendMessage(messageController.text, context);
                    // messageController.clear();
                    await controller.stop();
                  },
                  child: Icon(Icons.cancel, color: Colors.red).animate().fadeIn()
                ),
                10.toRowSpace(),
                InkWell(
                  onTap: () async {
                    final recordResult = await controller.stop();
                    print("AudioRecording ::: $recordResult");
                    
                    context.read<SendMessageProvider>().attachment = File(recordResult!);
                    context.read<SendMessageProvider>().attachmentToSend = File(recordResult);
                    context.read<SendMessageProvider>().isAudio = true;
                  },
                  child: Icon(Icons.stop, color: redColor).animate().fadeIn()
                )
              ],
            ],
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}