
import 'package:audioplayers/audioplayers.dart';
import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/state/base_provider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:path_provider/path_provider.dart';

class MessagePlayerStateProvider extends BaseProvider {
  
  MessagePlayerStateProvider() {
    initialize();
  }

  final player = AudioPlayer();

  bool get isPlaying => player.state == PlayerState.playing;
  bool get isPaused => player.state == PlayerState.paused;
  bool get isStopped => player.state == PlayerState.stopped;
  String currentPlayingId = "";

  Duration totalDuration = Duration.zero;
  Duration usedDuration = Duration.zero;

  void initialize() {
    player.onDurationChanged.listen((event) {
      // print("${chatMessage.id} ::: Duration ::: ${event.inMicroseconds}");
      totalDuration = event;
      notifyListeners();
    });
    player.onPositionChanged.listen((event) {
      // print("${chatMessage.id} ::: Position ::: ${event.inMicroseconds}");
      usedDuration = event;
      notifyListeners();
    });
    player.onPlayerStateChanged.listen((event) {
      notifyListeners();
    });
  }


  void playMessage(types.Message message) async {
    currentPlayingId = message.id;
    // print("AudioUrl ::: ${currentPlayingId}");
    notifyListeners();
    // final audioPath = message.metadata!['audio_record'];
    // final audioUrl = "$audioBaseUrl$audioPath";
    // print("AudioUrl ::: ${audioUrl}");
    final documentpath = await getApplicationDocumentsDirectory();

    await player.play(DeviceFileSource('${documentpath.path}/${message.id}.mp3'));
    // audioDuration = (await player.getDuration())!;
    notifyListeners();
  }

  void pausePlay() async {
    player.pause();
    // player.seek(position)
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }


}