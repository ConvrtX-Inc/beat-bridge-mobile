// ignore_for_file: file_names, diagnostic_describe_all_properties, always_specify_types, prefer_const_constructors, use_key_in_widget_constructors, sort_constructors_first, prefer_const_constructors_in_immutables, public_member_api_docs

import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/controller/audio_controller.dart';
import 'package:beatbridge/models/spotify/track.dart';
import 'package:beatbridge/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:spotify/spotify.dart' as spot;
import 'package:spotify_sdk/models/player_state.dart';
import 'dart:math';
import 'package:spotify_sdk/spotify_sdk.dart';
// import 'package:stop_watch_timer/stop_watch_timer.dart';
// import 'package:audioplayers/audioplayers.dart';

/// Audio file for queues playing screen
class AudioFile extends StatefulWidget {
  /// constructor
  final PlayListTrack track;
  final List<PlayListTrack> playListItems;
  AudioFile(this.track, this.playListItems);

  @override
  _AudioFileState createState() => _AudioFileState();
}

class _AudioFileState extends State<AudioFile>
    with SingleTickerProviderStateMixin {
  late AnimationController iconController;
  late Timer myTimer;

  bool isAnimated = false;
  bool playing = false;
  IconData playBtn = Icons.play_arrow;
  int start = 0;
  Duration position = Duration();
  int musicLength = 0;
  final audioController = Get.put(AudioController());
  StreamController<int> audiseeStream = StreamController<int>();
  // late StopWatchTimer stopWatchTimer = StopWatchTimer(); // Create instance.
  late PlayerState pState;
  final trackChangeController = Get.put(TrackChangeController());

  @override
  void initState() {
    super.initState();
    iconController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));

    SpotifySdk.subscribePlayerState().listen((playeState) {
      setState(() {
        musicLength = playeState.track!.duration;
        pState = playeState;
      });
    });
    // ignore: unnecessary_lambdas
    // audiseeStream.stream.listen((event) {
    //   stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    //   stopWatchTimer.clearPresetTime();

    //   if (event > 0) {
    //     stopWatchTimer.setPresetTime(mSec: event);
    //     seekTo(event);
    //     stopWatchTimer.onExecute.add(StopWatchExecute.start);
    //   } else {
    //     stopWatchTimer.dispose();
    //     play(widget.track);
    //     startTimer();
    //   }
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      play(widget.track);
      startTimer();
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    // await stopWatchTimer.dispose();
    await audiseeStream.close();
    // myTimer.cancel();
  }

  void startTimer() {
    // stopWatchTimer = StopWatchTimer(
    //   onChange: (value) {
    //     if (value < musicLength - 500) {
    //       audioController.setDuration(value);
    //     } else {
    //       playnext();
    //     }
    //   },
    //   onChangeRawSecond: (value) => null,
    //   onChangeRawMinute: (value) => null,
    // );
    // stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: GetBuilder<AudioController>(
              id: 'duration',
              builder: (controller) {
                // print('controller.duration ${controller.duration}');
                return ProgressBar(
                  progressBarColor: Colors.white,
                  baseBarColor: Colors.white.withOpacity(0.24),
                  bufferedBarColor: Colors.white.withOpacity(0.24),
                  thumbColor: Colors.white,
                  progress: Duration(milliseconds: controller.duration),
                  total: Duration(milliseconds: musicLength),
                  timeLabelTextStyle: TextStyle(color: Colors.white),
                  onSeek: (duration) {
                    print('duration.inMilliseconds ${duration.inMilliseconds}');

                    audiseeStream.sink.add(duration.inMilliseconds);
                  },
                );
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                audioController.setIsShuffle(
                    audioController.shuffle == 'true' ? 'false' : 'true');
              },
              child: GetBuilder<AudioController>(
                  id: 'shuffle',
                  builder: (controller) {
                    print(controller.shuffle);
                    return Image.asset(
                      Constants.shuffle,
                      color: controller.shuffle == 'true'
                          ? AppColorConstants.appleGreen
                          : null,
                    );
                  }),
              // child: Image.asset(Constants.shuffle),
            ),
            InkWell(
              onTap: () {
                audiseeStream.sink.add(audioController.duration - 15000);
              },
              child: Image.asset(Constants.default2),
            ),
            InkWell(
              onTap: playPrevious,
              child: Image.asset(Constants.previous),
            ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Constants.lightviolet,
                      Constants.lightred,
                    ],
                  ),
                  shape: BoxShape.circle),
              child: Center(
                child: GestureDetector(
                  // ignore: unnecessary_lambdas
                  onTap: () {
                    animateIcon();
                  },
                  child: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: iconController,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: playnext,
              child: Image.asset(Constants.forward),
            ),
            InkWell(
              onTap: () {
                audiseeStream.sink.add(audioController.duration + 15000);
              },
              child: Image.asset(Constants.skip),
            ),
            InkWell(
              onTap: () {},
              child: Image.asset(Constants.volume),
            )
          ],
        )
      ],
    );
  }

  void playnext() {
    int nextIndex = 0;
    if (audioController.shuffle == 'false') {
      final track = widget.playListItems
          .where((track) => track.track!.uri == pState.track!.uri)
          .toList()
          .first;
      final index = widget.playListItems
          .indexWhere((t) => t.track!.id == track.track!.id);
      nextIndex = index + 1;
    } else {
      final int randomNumber =
          Random().nextInt(widget.playListItems.length) + 1;
      nextIndex = randomNumber;
    }

    if (nextIndex < widget.playListItems.length) {
      final nextTrack = widget.playListItems[nextIndex];
      // stopWatchTimer.dispose();
      play(nextTrack);
      startTimer();
      trackChangeController.setTrack(nextTrack);
    } else {
      // final firstTrack = widget.playListItems[0];
      // stopWatchTimer.dispose();
      // play(firstTrack);
      startTimer();
      // trackChangeController.setTrack(firstTrack);
    }
  }

  void playPrevious() {
    final track = widget.playListItems
        .where((track) => track.track!.uri == pState.track!.uri)
        .toList()
        .first;
    final index =
        widget.playListItems.indexWhere((t) => t.track!.id == track.track!.id);
    final prevIndex = index - 1;
    if (prevIndex > 0) {
      final nextTrack = widget.playListItems[prevIndex];
      // stopWatchTimer.dispose();
      play(nextTrack);
      startTimer();
      trackChangeController.setTrack(nextTrack);
    } else {
      final firstTrack = widget.playListItems[0];
      // stopWatchTimer.dispose();
      play(firstTrack);
      startTimer();
      trackChangeController.setTrack(firstTrack);
    }
  }

  Future<void> queue(PlayListTrack track) async {
    try {
      await SpotifySdk.queue(spotifyUri: track.track!.uri!);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> skipNext() async {
    try {
      await SpotifySdk.skipNext();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> skipPrevious() async {
    try {
      await SpotifySdk.skipPrevious();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  void setStatus(String code, {String? message}) {
    final text = message ?? '';
    logger.i('$code$text');
  }

  Future<void> play(PlayListTrack track) async {
    try {
      await SpotifySdk.play(spotifyUri: 'spotify:track:${track.track!.id}');
      await iconController.forward();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> seekToRelative(int position) async {
    try {
      await SpotifySdk.seekToRelativePosition(relativeMilliseconds: position);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> seekTo(int position) async {
    try {
      await SpotifySdk.seekTo(positionedMilliseconds: position);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> pause() async {
    try {
      await SpotifySdk.pause();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> resume() async {
    try {
      await SpotifySdk.resume();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  final Logger logger = Logger(
    //filter: CustomLogFilter(), // custom logfilter can be used to have logs in release mode
    printer: PrettyPrinter(
      printTime: true,
    ),
  );
  void animateIcon() {
    setState(() {
      isAnimated = !isAnimated;
      isAnimated
          ? iconController.forward().then((value) {
              resume();
              // stopWatchTimer.onExecute.add(StopWatchExecute.start);
            })
          : iconController.reverse().then((value) {
              pause();
              // stopWatchTimer.onExecute.add(StopWatchExecute.stop);
            });
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Timer>('myTimer', myTimer));
  }
}
