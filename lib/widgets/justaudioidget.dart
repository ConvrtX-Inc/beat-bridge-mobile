import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/notifier/songstimernotifier.dart';
import 'package:beatbridge/widgets/audioplayer.dart';
import 'package:spotify_sdk/models/player_state.dart' as sindu_player_state;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:volume_controller/volume_controller.dart';

class customPlayer extends StatefulWidget {
  // var mins;
  // customPlayer({required this.mins});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _customPlayer();
  }
}

class _customPlayer extends State<customPlayer> {
  bool shufflechk = false;
  bool forwardColor = false;
  bool backwardColor = false;
  var image_uri = "";
  var mins = 0;
  bool showLoader = false;
  double _value = 0.0;
  var songSeconds = 0;
  bool isMute = false;
  double _value1 = 0.0;
  double _totalTime = 1;
  var hour = 0.0, minute = 0.0, second = 0.0, maxValue = 0.0;
  late Timer _progressTimer;
  var songImage;
  bool _done = false;
  buffering() {
    _progressTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (_playerState!.isPaused) {
        _progressTimer.cancel();
      } else {
        // if (_value.round() >= songSeconds.round()) {
        //   _progressTimer.cancel();
        //   skipNext();
        // } else {

        // }
        setState(() {
          _value += 1;
          _value1 += 1;
          print("my timer started: $_value");

          // if (_value >= 60) {
          //   // _value = _totalTime;
          //   _value = 0.0;
          //   minute = minute + 1;
          // }
          // if (minute > double.parse(mins.toString().split("")[0])) {
          //   print("my minuts: $minute:   ${mins.toString().split("")[0]}");

          //   _done = true;
          // }
        });
        // if (_value <= songSeconds) {
        //   _progressTimer.cancel();
        //   skipNext();
        // } else {

        // }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _progressTimer.cancel();
  }

  // AudioPlayer players = AudioPlayer();
  int totalCount = 0;
  var progressCounter = 0;
  songsProgress() {}
  PlayerState? _playerState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("hello world: in widget");
    // if (_playerState == null) {
    //   maxValue = 0.0;
    //   mins = 0;
    //   _value = 0.3;
    //   // SongsTimeNotifier().stopTimer();
    // } else {
    //   if (_playerState!.isPaused) {
    //     maxValue = 0.0;
    //     mins = 0;
    //     SpotifySdk.seekTo(positionedMilliseconds: 0);
    //     _value = 0.3;
    //     SpotifySdk.seekTo(positionedMilliseconds: 0);
    //     // maxValue = 0.0;
    //     // _value = 1;
    //     // SongsTimeNotifier().stopTimer();
    //   } else {
    //     buffering();
    //     // SongsTimeNotifier().startTime();
    //     // buffering();
    //   }
    // }
    // TODO: implement build
    return Column(
      children: [
        StreamBuilder<sindu_player_state.PlayerState>(
          stream: SpotifySdk.subscribePlayerState(),
          builder: (BuildContext context,
              AsyncSnapshot<sindu_player_state.PlayerState> snapshot) {
            // if (snapshot.data == null) {
            //   UserSingleton.instance.myaccessToken = null;
            // }
            print("response from spotify subscribe: ${snapshot.data}");
            print("helllooooo");
            var track = snapshot.data?.track;

            var playerState = snapshot.data;
            _playerState = snapshot.data;

            print('track : $track');
            log('$track');
            print('Trackkkkkkkkkkkk!!!!!!!!!!!!!');

            // print('player state : $playerState');
            //  print('seekbar state : ${track.d}');

            if (playerState == null || track == null) {
              // _logger.i("Null player start " + snapshot.toString());
              return Center(
                child: Container(
                  height: 180,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 1.3,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              );
            } else {}
            //  SpotifySdk.s
            print('spotifyImage : ${track.artist}');
            print("hello world: ");
            var duration =
                double.parse(snapshot.data!.track!.duration.toString());
            var minutes =
                (int.parse(snapshot.data!.track!.duration.toString()) / 1000)
                    .round();

            songSeconds = minutes;
            mins = (minutes / 60).round();
            print("////////////////////minutes" + mins.toString());

            print("track duration: $mins");
            maxValue = double.parse(mins.toString());
            _totalTime = double.parse(mins.toString().split("")[0]);
            SongsTimeNotifier().lastValue.value = Duration(
                    seconds:
                        int.parse(snapshot.data!.track!.duration.toString()))
                .inMinutes;

            int mins1 = Duration(
                        seconds: int.parse(
                            snapshot.data!.track!.duration.toString()))
                    .inMinutes %
                100;

            return Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: Platform.isIOS
                    ? MediaQuery.of(context).size.height * .26
                    : MediaQuery.of(context).size.height * .24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        spotifyImageWidget(track.imageUri),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${track.name}',
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white,
                                    fontFamily: 'Glory',
                                    fontSize: 18),
                              ),
                              Text(
                                track.album.name.toString(),
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white,
                                    fontFamily: 'Glory',
                                    fontSize: 18),
                              ),
                              Text(
                                '${track.artist.name}',
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white,
                                    fontFamily: 'Glory',
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () {
                                setState(() {
                                  shufflechk = !shufflechk;
                                });
                                toggleShuffle();
                                print('music shuffle');
                              },
                              icon: Image.asset(
                                'assets/images/shuffle.png',
                                height: 20,
                                width: 25,
                                color: shufflechk
                                    ? Colors.deepPurple
                                    : Colors.white24,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                icon: Image.asset(
                                  'assets/images/backforward.png',
                                  height: 20,
                                  width: 25,
                                  color: backwardColor
                                      ? Colors.deepPurple
                                      : Colors.white24,
                                ),
                                onPressed: skipPrevious),
                            const SizedBox(
                              width: 15,
                            ),
                            if (playerState.isPaused)
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                iconSize: 50,
                                icon: Image.asset(
                                  'assets/images/Play1.png',
                                ),
                                onPressed: () {
                                  resume();
                                  setState(() {
                                    // SongsTimeNotifier().lastValue.value = int.parse(
                                    //     mins.toString().split("")[0].toString());
                                    print("minsss: $mins");
                                    print(
                                        "last value: ${SongsTimeNotifier().lastValue.value}");
                                  });

                                  print("minsss: $mins");
                                  print(
                                      "last value: ${SongsTimeNotifier().lastValue.value}");
                                  print('music forward');
                                },
                              )
                            else
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                iconSize: 50,
                                icon: Image.asset(
                                  'assets/images/pause.png',
                                ),
                                onPressed: () {
                                  setState(() {
                                    showLoader = false;
                                    duration = double.parse(snapshot
                                        .data!.track!.duration
                                        .toString());
                                  });
                                  pause();

                                  // SongsTimeNotifier().lastValue.value = int.parse(
                                  //     mins.toString().split("")[0].toString());
                                  print("minsss: $mins");
                                  print(
                                      "last value: ${SongsTimeNotifier().lastValue.value}");
                                  print('music forward');
                                },
                              ),
                            const SizedBox(
                              width: 15,
                            ),
                            IconButton(
                              // splashColor: Colors.purple,
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: Image.asset(
                                'assets/images/forward.png',
                                height: 20,
                                width: 25,
                                color: forwardColor
                                    ? Colors.deepPurple
                                    : Colors.white24,
                              ),
                              onPressed: () {
                                skipNext();

                                print('music sound forward');
                              },
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: isMute == true
                                  ? Image.asset(
                                      "assets/images/mute.png",
                                      width: 15,
                                      height: 15,
                                      color: Colors.grey,
                                    )
                                  : Icon(
                                      Icons.volume_up,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                              // Image.asset(
                              //   'assets/images/sound.png',
                              //   height: 20,
                              //   width: 25,
                              // ),
                              onPressed: () {
                                setState(() {
                                  SongsTimeNotifier().isMute.value =
                                      !SongsTimeNotifier().isMute.value;
                                  isMute = !isMute;
                                });
                                print(
                                    "mute value: ${SongsTimeNotifier().isMute.value}");
                                // skipNext();
                                setVolumn();
                                // SongsTimeNotifier().setVolumn(
                                //     SongsTimeNotifier().isMute.value);
                                // VolumeController().setVolume(0);

                                print('music sound');
                              },
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        mySlider(mins)
      ],
    );
  }

  Widget mySlider(mins) {
    // print("player state: ${_playerState!.}");
    return Padding(
      padding: EdgeInsets.only(left: 12, right: 12),
      child: ProgressBar(
        baseBarColor: Colors.grey[800],
        progressBarColor: Colors.white,
        bufferedBarColor: Colors.green,
        thumbColor: Colors.white,
        progress: Duration(seconds: _value.toInt()),
        timeLabelTextStyle: TextStyle(color: Colors.white),
        buffered: Duration(seconds: mins.toInt()),
        total: Duration(minutes: mins.toInt()),
        onSeek: (duration) {
          var milli = duration.inMilliseconds;
          setState(() {
            _value = duration.inSeconds.toDouble();
          });
          print("mmili second for changing song state: $milli");
          // setState(() {
          //   _value1 = duration;
          // });
          SpotifySdk.seekTo(positionedMilliseconds: milli);
          // // _player.seek(duration);
        },
      ),
    );
    //     Column(
    //   children: [
    //     Slider(
    //         value: _value1,
    //         //  double.parse(
    //         // SongsTimeNotifier().counter.value.toString()),
    //         min: -5,
    //         max: 150,
    //         // divisions: 20,
    //         activeColor: Colors.green,
    //         inactiveColor: Colors.grey,
    //         label: 'sa',
    //         onChanged: (double newValue) {
    //           // var data = newValue;
    //           // SongsTimeNotifier().counter.value =
    //           //     int.parse(newValue.toString());
    //           // // print("counter value incremented: $counter");
    //           // // duration = newValue;
    //           // setState(() {
    //           //   // double.parse(
    //           //   //     snapshot.data!.track!.duration.toString());
    //           //   // valueHolder = newValue.round();
    //           // });
    //         },
    //         semanticFormatterCallback: (double newValue) {
    //           return '${newValue.round()}';
    //         }),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Text(
    //           minute == 0 || minute == 0.0
    //               ? "${minute.round()}:${_value.round()}"
    //               : "${_value.round()}:0"
    //           // "${SongsTimeNotifier().counter.value}"
    //           // :
    //           // "${SongsTimeNotifier().count.value}:${SongsTimeNotifier().counter.value}"
    //           ,
    //           style: TextStyle(
    //               fontSize: 16,
    //               color: Colors.white,
    //               fontWeight: FontWeight.bold),
    //         ),
    //         Text(
    //           "0${mins.toString().split("")[0]}:00",
    //           style: TextStyle(
    //               fontSize: 16,
    //               color: Colors.white,
    //               fontWeight: FontWeight.bold),
    //         )
    //       ],
    //     ),
    //   ],
    // );
  }

  Future<void> play(String uri) async {
    try {
      // await _audioPlayer.play();

      print("spotify uri: $uri");

      await SpotifySdk.seekTo(positionedMilliseconds: 0);
      await SpotifySdk.play(spotifyUri: uri).then((value) {
        setState(() {
          maxValue = 0.0;
          _value = 0.0;
        });
        buffering();
      });
      // setState(() {
      //   maxValue = 0.0;
      //   _value = 0.0;
      // });
      // _resumeProgressTimer();

      // SongsTimeNotifier().startTime();
      // await SpotifySdk.play(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Widget spotifyImageWidget(ImageUri image) {
    if (image_uri != image.raw) {
      image_uri = image.raw;
      SpotifySdk.getImage(
        imageUri: image,
        dimension: ImageDimension.large,
      ).then(
        (value) {
          maxValue = 0.0;
          _value = 0.0;
          _value1 = 0.0;
          SpotifySdk.seekTo(positionedMilliseconds: 0);
          songImage = value;
        },
      );
    }
    // return FutureBuilder(
    //     future: SpotifySdk.getImage(
    //       imageUri: image,
    //       dimension: ImageDimension.large,
    //     ),
    //     builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
    //       if (snapshot.hasData) {
    //         return Container(
    //             width: 100,
    //             height: 100,
    //             decoration: BoxDecoration(shape: BoxShape.circle),
    //             child: Image.memory(snapshot.data!));
    //       } else if (snapshot.hasError) {
    //         setStatus(snapshot.error.toString());
    //         return SizedBox(
    //           width: 10,
    //           height: 10,
    //           child: const Center(child: Text('')),
    //         );
    //       } else {
    //         return SizedBox(
    //           width: 10,
    //           height: 10,
    //           child: const Center(child: Text('')),
    //         );
    //       }
    //     });
    return songImage == null
        ? Container()
        : Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Image.memory(songImage!));
  }

  Future<void> toggleShuffle() async {
    try {
      await SpotifySdk.toggleShuffle();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> pause() async {
    try {
      setState(() {
        // maxValue = 0.0;
        // _value = 0.0;
      });
      await SpotifySdk.pause();
      // buffering();
      // SongsTimeNotifier().stopTimer();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> resume() async {
    try {
      setState(() {
        showLoader = true;
        // maxValue = 0.0;
        // _value = 0.0;
        // _value1 = 0.0;
      });
      // await SpotifySdk.pause();
      await SpotifySdk.seekTo(positionedMilliseconds: 0);
      await SpotifySdk.resume().then((value) {
        buffering();
      }).catchError((error) {
        print("my resume error is: ${error}");
      });

      // buffering();
      // SongsTimeNotifier().stopTimer();
      // SongsTimeNotifier().startTime();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
    // _logger.i('$code$text');
  }

  Future<void> skipNext() async {
    try {
      showLoader = false;
      setState(() {
        maxValue = 0.0;
        _value = 0.0;
        _value1 = 0.0;
        forwardColor = !forwardColor;
      });
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          forwardColor = !forwardColor;
        });
      });

      await SpotifySdk.pause().then((value) async {
        await SpotifySdk.seekTo(positionedMilliseconds: 0);
        await SpotifySdk.skipNext().then((value) {
          buffering();
        }).catchError((onError) {
          print("skip next error: $onError");
        });
      });
      // var seekCheck = await SpotifySdk.seekTo(positionedMilliseconds: 0);
      print('Sekkkkkkkkkk Check');
      // print(seekCheck);

      // SongsTimeNotifier().stopTimer();
      // SongsTimeNotifier().startTime();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  setVolumn() {
    // isMute = value;
    if (isMute == true) {
      VolumeController().setVolume(0);
      // isMute = false;
    } else {
      VolumeController().setVolume(30);
      // isMute = true;
    }
    // isMute.value = !isMute.value;

    // notifyListeners();
  }

  Future<void> skipPrevious() async {
    print('function call inside skip previous');
    try {
      setState(() {
        maxValue = 0.0;
        _value = 0.0;
        _value1 = 0.0;
        backwardColor = !backwardColor;
      });
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          backwardColor = !backwardColor;
        });
      });

      await SpotifySdk.pause().then((value) async {
        await SpotifySdk.seekTo(positionedMilliseconds: 0);
        await SpotifySdk.skipPrevious().then((value) {
          buffering();
        });
      });

      // SongsTimeNotifier().stopTimer();
      // SongsTimeNotifier().startTime();
    } catch (e) {
      final snackBar = SnackBar(
        content: Text("Cant Skip To Previous Song"),
        backgroundColor: (Colors.red),
        action: SnackBarAction(
          label: 'dismiss',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> seekTo() async {
    try {
      await SpotifySdk.seekTo(positionedMilliseconds: 20000);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> seekToRelative() async {
    try {
      await SpotifySdk.seekToRelativePosition(relativeMilliseconds: 20000);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> addToLibrary() async {
    try {
      await SpotifySdk.addToLibrary(
          spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }
}
