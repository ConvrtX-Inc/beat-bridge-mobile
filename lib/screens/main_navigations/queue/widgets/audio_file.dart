// ignore_for_file: file_names

import 'package:beatbridge/utils/constant.dart';
import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';

/// Audio file for queue playing screen
class AudioFile extends StatefulWidget {
  /// constructor
  const AudioFile({Key? key}) : super(key: key);

  @override
  _AudioFileState createState() => _AudioFileState();
}

class _AudioFileState extends State<AudioFile>
    with SingleTickerProviderStateMixin {
  late AnimationController iconController;
  bool isAnimated = false;
  bool playing = false;
  IconData playBtn = Icons.play_arrow;

  Duration position = Duration();
  Duration musicLength = Duration();
  // late AudioPlayer _player;
  // late AudioCache cache;

  Widget slider() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Slider.adaptive(
          activeColor: Colors.white,
          inactiveColor: Colors.grey[350],
          value: position.inSeconds.toDouble(),
          max: musicLength.inSeconds.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    // _player.seek(newPos);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    iconController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 100));

    iconController.forward().then((value) async {
      await Future.delayed(const Duration(seconds: 1));
      await iconController.reverse();
    });

    // _player = AudioPlayer();
    // cache = AudioCache(fixedPlayer: _player);

    // _player.onDurationChanged.listen((d) {
    //   setState(() {
    //     musicLength = d;
    //   });
    // });

    // _player.onAudioPositionChanged.listen((p) {
    //   setState(() {
    //     position = p;
    //   });
    // });

    // cache.load("music.mp3");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              slider(),
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    '${position.inMinutes}:${position.inSeconds.remainder(60)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 17),
                  child: Text(
                    '${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: (){},
              child: Image.asset(Constants.shuffle),
            ),
            InkWell(
              onTap: (){},
              child: Image.asset(Constants.default2),
            ),
            InkWell(
              onTap: (){},
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

                    // if (!playing) {
                    //   //now let's play the song
                    //   cache.play("music.mp3");
                    //   setState(() {
                    //     playBtn = Icons.pause;
                    //     playing = true;
                    //   });
                    // } else {
                    //   _player.pause();
                    //   setState(() {
                    //     playBtn = Icons.play_arrow;
                    //     playing = false;
                    //   });
                    // }
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
              onTap: (){},
              child: Image.asset(Constants.forward),
            ),
            InkWell(
              onTap: (){},
              child: Image.asset(Constants.skip),
            ),
            InkWell(
              onTap: (){},
              child: Image.asset(Constants.volume),
            )
          ],
        )
      ],
    );
  }

  void animateIcon() {
    setState(() {
      isAnimated = !isAnimated;
      isAnimated ? iconController.forward() : iconController.reverse();
    });
  }
}
