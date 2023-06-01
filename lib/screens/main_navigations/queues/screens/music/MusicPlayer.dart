// // import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter/material.dart';

// class Home extends StatefulWidget {
//   Home({
//     super.key,
//     t,
//   });
//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> with WidgetsBindingObserver {
//   List SongsList = [];
//   bool MuteVolume = false;
//   var _state;

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);

//   }

//   final AssetsAudioPlayer audioplayer = AssetsAudioPlayer();
//   double screenwidth = 0;
//   double screenheight = 0;

//   @override
//   void initState() {
//     super.initState();
//     setupPlaylist();
//     WidgetsBinding.instance.removeObserver(this);
//     WidgetsBinding.instance.addObserver(this);
//   }

// // songs paths and links
//   void setupPlaylist() async {
//     await audioplayer.open(
//       showNotification: true,
//       Playlist(audios: [
//         Audio.network(
//           'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/09/17/bb/0917bbe1-58c3-6252-d00e-9b70d42ef5dc/mzaf_2269500085377778268.plus.aac.p.m4a',
//           metas: Metas(
//             id: 'Online',
//             title: 'Online',
//             artist: 'Florent Champigny',
//             album: 'OnlineAlbum',

//             // image: MetasImage.network('https://www.google.com')
//             image: const MetasImage.network(
//                 'https://i.dawn.com/large/2021/09/61399fb500900.png'),
//           ),
//         ),
//       ]),
//       autoStart: true,
//       loopMode: LoopMode.playlist,
//     );
//   }

//   var forward = AssetImage('assets/forward.png');

//   @override
//   void dispose() {
//     super.dispose();
//     setupPlaylist();
//   }

//   Widget slider(RealtimePlayingInfos realtimePlayingInfos) {
//     return SliderTheme(
//         data: const SliderThemeData(
//           thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
//         ),
//         child: Slider.adaptive(
//             activeColor: const Color.fromARGB(255, 241, 241, 241),
//             inactiveColor: const Color.fromARGB(255, 219, 217, 217),
//             thumbColor: const Color.fromARGB(255, 255, 255, 255),
//             value: realtimePlayingInfos.currentPosition.inSeconds.toDouble(),
//             max: realtimePlayingInfos.duration.inSeconds.toDouble(),
//             onChanged: (value) {
//               audioplayer.seek(Duration(seconds: value.toInt()));
//               _state = audioplayer.seek(Duration(seconds: value.toInt()));
//               print(_state);
//             }));
//   }

//   Widget timeStamps(RealtimePlayingInfos realtimePlayingInfos) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           transformString(realtimePlayingInfos.currentPosition.inSeconds),
//           style: const TextStyle(color: Colors.white),
//         ),
//         Text(transformString(realtimePlayingInfos.duration.inSeconds),
//             style: const TextStyle(color: Colors.white)),
//       ],
//     );
//   }
//   // slider timings

//   String transformString(int seconds) {
//     String minuteString =
//         '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
//     String secondString = '${seconds % 60 < 10 ? 0 : ' '}${seconds % 60}';
//     return '$minuteString:$secondString';
//   }

//   //control buttons of music player
//   Widget playBar(RealtimePlayingInfos realtimePlayingInfos) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Icon_Button(
//               icon: Icons.compare_arrows_rounded,
//               size: 21,
//               passedfunc: () {
//                 audioplayer.toggleShuffle();
//               }),
//           Icon_Button(
//               icon: Icons.fast_rewind_rounded,
//               size: 21,
//               passedfunc: () {
//                 audioplayer.seekBy(const Duration(seconds: -15));
//               }),
//           Icon_Button(
//               icon: Icons.skip_previous_rounded,
//               size: 21,
//               passedfunc: () => audioplayer.previous()),
//           Icon_Button(
//               icon: realtimePlayingInfos.isPlaying
//                   ? Icons.pause_circle_filled_rounded
//                   : Icons.play_circle_fill_rounded,
//               size: 50,
//               passedfunc: () {
//                 if (audioplayer.playerState.value == 'PlayerState.play') {
//                   return null;
//                 } else {
//                   print('state of player ${audioplayer.playerState.value}');
//                   return audioplayer.playOrPause();
//                 }
//               }),
//           Icon_Button(
//               icon: Icons.skip_next_rounded,
//               size: 21,
//               passedfunc: () => audioplayer.next()),
//           Icon_Button(
//               icon: Icons.fast_forward_rounded,
//               size: 21,
//               passedfunc: () {
//                 setState(() {
//                   audioplayer.seekBy(const Duration(seconds: 15));
//                 });
//               }),
//           Icon_Button(
//             icon: MuteVolume == true
//                 ? Icons.volume_off_outlined
//                 : Icons.volume_up,
//             size: 21,
//             passedfunc: () {
//               if (MuteVolume == true) {
//                 setState(() {
//                   audioplayer.setVolume(1);
//                   MuteVolume = !MuteVolume;
//                 });
//               } else {
//                 audioplayer.setVolume(0);
//                 MuteVolume = !MuteVolume;
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // screenheight = MediaQuery.of(context).size.height;
//     // screenwidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(31, 142, 111, 253),
//       body: audioplayer.builderRealtimePlayingInfos(
//           builder: (context, realtimePlayingInfos) {
//         // ignore: unnecessary_null_comparison
//         if (realtimePlayingInfos != null) {
//           return Column(
//             //Designing Texts and image
//             children: [
//               // slider code is here
//               Stack(
//                 children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       slider(realtimePlayingInfos),
//                       SizedBox(
//                         height: screenheight * 0.05,
//                       ),
//                       timeStamps(realtimePlayingInfos),
//                       SizedBox(
//                         height: screenheight * 0.05,
//                       ),
//                       playBar(realtimePlayingInfos),
//                     ],
//                   )
//                 ],
//               ),
//             ],
//           );
//         } else {
//           return Column();
//         }
//       }),
//     );
//   }
// }

// // Icon_Button custom widget

// // ignore: camel_case_types, must_be_immutable
// class Icon_Button extends StatelessWidget {
//   Icon_Button(
//       {super.key,
//       required this.icon,
//       required this.size,
//       required this.passedfunc});

//   IconData icon;
//   double size;
//   final passedfunc;
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: passedfunc,
//       icon: Icon(icon),
//       iconSize: size,
//       color: Colors.grey, 
//       splashColor: Colors.transparent,
//       highlightColor: Colors.transparent,
//     );
//   }
// }
