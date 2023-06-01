import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerssss extends StatefulWidget {
  var songUrl;
  var songsList = [];
  AudioPlayerssss({this.songUrl, required this.songsList});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AudioPlayer();
  }
}

class _AudioPlayer extends State<AudioPlayerssss>
    with TickerProviderStateMixin {
  AudioCache? audioCache;
  var width, height;
  AudioPlayer? audioPlayer;
  Duration _duration = new Duration();
  Duration _position = new Duration();
  Duration _slider = new Duration(seconds: 0);
  late AnimationController _animationIconController1;
  double? durationvalue;
  bool issongplaying = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _position = _slider;
    _animationIconController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
      reverseDuration: Duration(milliseconds: 750),
    );
    audioPlayer = new AudioPlayer();
    audioCache = new AudioCache();
    // audioPlayer! .durationHandler = (d) => setState(() {
    //       _duration = d;
    //     });

    // audioPlayer.positionHandler = (p) => setState(() {
    //       _position = p;
    //     });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    height = MediaQuery.of(context).size.height;

    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100.withOpacity(0.55),
        image: DecorationImage(
          image: AssetImage("assets/images/ellie.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Container(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            width: (MediaQuery.of(context).size.width),
            height: (MediaQuery.of(context).size.height),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ClipOval(
                    child: Image(
                      image: AssetImage("assets/images/starman.png"),
                      width: width * .5,
                      height: height * .2,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Slider(
                    activeColor: Colors.white,
                    inactiveColor: Colors.grey,
                    value: _position.inSeconds.toDouble(),
                    max: _duration.inSeconds.toDouble(),
                    onChanged: (double value) {
                      // Add code to track the music duration.
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.navigate_before,
                        size: 55,
                        color: Colors.white,
                      ),
                      GestureDetector(
                        onTap: () {
                          print("song: ${widget.songsList.first}");
                          audioPlayer!.play(widget.songsList.first);
                          // Add code to pause and play the music.
                        },
                        child: ClipOval(
                          child: Container(
                            color: Colors.pink[600],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AnimatedIcon(
                                icon: AnimatedIcons.play_pause,
                                size: 55,
                                progress: _animationIconController1,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.navigate_next,
                        size: 55,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
