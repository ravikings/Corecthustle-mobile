
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/locator.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:correct_hustle/core/styles/colors.dart';
import 'package:correct_hustle/features/chat/state/message_player_state_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chatTypes;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';


Future<List<double>> getWaveData(PlayerController controller, String path, token) async {
  try {
    BackgroundIsolateBinaryMessenger.ensureInitialized(token);
    // print("DownloadAudio ::: ExtractWaveData ");
    final data = await controller.extractWaveformData(path: path, noOfSamples: 100);
    // print("DownloadAudio ::: $data");
    return data;
  } catch (error) {
    // print("DownloadAudio ::: Error ::: $error");
    rethrow;
  }
}

class AudioMessageWidget extends StatefulWidget {
  const AudioMessageWidget({
    super.key,
    required this.message
  });

  final chatTypes.Message message;

  @override
  State<AudioMessageWidget> createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget> {

  PlayerController controller = PlayerController();
  String audioUrl = "";

  bool loading = true;

  List<double> waveData = [];

  @override
  void initState() {
    audioUrl = "$audioBaseUrl${widget.message.metadata!['audio_record']}";
    // compute(loadFromCache);
    loadFromCache();
    super.initState();
  }

  void loadWave() async {
    final documentpath = await getApplicationDocumentsDirectory();
    final audioPath = "${documentpath.path}/${widget.message.id}.mp3";
    loading = false;
    waveData = await compute<List, List<double>>((p) => getWaveData(p[0], p[1], p[2]), [controller, audioPath, RootIsolateToken.instance!]);
    await getIt<ILocalStorageService>().setItem(userDataBox, 'audio_wave_${widget.message.id}', waveData);
    setState(() {});
  }

  loadWaveFromCache() async {
    final audioWave = await getIt<ILocalStorageService>().getItem(userDataBox, 'audio_wave_${widget.message.id}', defaultValue: null);
    if (audioWave == null) {
      loadWave();
    } else {
      // print("DownloadAudio ::: LocalWave ::: $audioWave");
      setState(() {
        loading = false;
        waveData = audioWave;
      });
    }
  }

  void loadFromCache() async {
    final audioDownloaded = await getIt<ILocalStorageService>().getItem(userDataBox, 'audio_${widget.message.id}', defaultValue: false);
    if (!audioDownloaded) {
      downloadAudio();
    } else {
      loadWaveFromCache();
    }
  }

  void downloadAudio() async {
    try {
      // print('DownloadAudio ::: AudioUrl ::: $audioUrl');
      final documentpath = await getApplicationDocumentsDirectory();
      final audioPath =  "${documentpath.path}/${widget.message.id}.mp3";
      // print('DownloadAudio ::: AudioPath ::: $audioPath');
      getIt<Dio>().download(audioUrl, audioPath).then((value) async {
        // print('DownloadAudio ::: Response ::: $value');
        getIt<ILocalStorageService>().setItem(userDataBox, 'audio_${widget.message.id}', true);
        loading = false;
        loadWaveFromCache();
      }).catchError((err) {
        // print('DownloadAudio ::: CatchError $err');
      });
    } catch (error) {
      // print('DownloadAudio ::: Error $error');
      rethrow;
    }
  }

  
  @override
  Widget build(BuildContext context) {
    // print('DownloadAudio ::: WaveData ::: $waveData');
    final messagePlayerProvider = context.watch<MessagePlayerStateProvider>();
    final thisIsPlaying = messagePlayerProvider.isPlaying && messagePlayerProvider.currentPlayingId == widget.message.id;
    // print("AudioUrl ::: ${thisIsPlaying} ::: ${widget.message.id} ::: ${messagePlayerProvider.currentPlayingId}");
    return Container(
      key: Key(widget.message.id),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Consumer<MessagePlayerStateProvider>(
        builder: (context, value, child) {
          return Row(
            children: [
              InkWell(
                onTap: () {
                  controller.startPlayer(
                    finishMode: FinishMode.stop,
                    forceRefresh: true
                  );
                  context.read<MessagePlayerStateProvider>().playMessage(widget.message);
                },
                // onTap: () => 
                child: thisIsPlaying ? const Icon(
                  Icons.pause, color: Colors.white
                ,) : const Icon(
                  Icons.play_arrow, color: Colors.white
                ,),
              ),
              Expanded(
                // child: Image.asset(
                //   'assets/images/wave.png',
                //   height: 40, width: MediaQuery.of(context).size.width,
                //   fit: BoxFit.cover,
                //   color: Colors.white,
                // ),
                child: loading ? Container(
                  height: 40,
                ) : AudioFileWaveforms(
                  size: Size(MediaQuery.of(context).size.width, 40), 
                  playerController: controller,
                  waveformType: WaveformType.fitWidth,
                  enableSeekGesture: true,
                  waveformData: waveData,
                  playerWaveStyle: PlayerWaveStyle(
                    liveWaveColor: Colors.white,
                    seekLineColor: secondarryColor.withOpacity(.5),
                    backgroundColor: secondarryColor.withOpacity(.5)
                  ),
                ),
              )
            ],
          );
        }
      )
    );
  }
}