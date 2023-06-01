// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter/material.dart';

// import 'MusicPlayer.dart';


// class music_controls extends StatefulWidget {
//   const music_controls({super.key});

//   @override
//   State<music_controls> createState() => _music_controlsState();
// }

// class _music_controlsState extends State<music_controls> {
//     final AssetsAudioPlayer audioplayer = AssetsAudioPlayer();
    
//      var _state;
//        double screenwidth = 0;
//   double screenheight = 0;
   
//     Widget slider(RealtimePlayingInfos realtimePlayingInfos) {
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
//   // time stamp

//    Widget timeStamps(RealtimePlayingInfos realtimePlayingInfos) {
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

//     String transformString(int seconds) {
//     String minuteString =
//         '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
//     String secondString = '${seconds % 60 < 10 ? 0 : ' '}${seconds % 60}';
//     return '$minuteString:$secondString';
//   }
//   // play bar

//     Widget playBar(RealtimePlayingInfos realtimePlayingInfos) {
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
//     return audioplayer.builderRealtimePlayingInfos(
//           builder: (context, realtimePlayingInfos) {
//         // ignore: unnecessary_null_comparison
//         if (realtimePlayingInfos != null) {
//           return Column(
//             //Designing Texts and image
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(23.0),
//                 child: Row(
//                   children: [
//                     ClipRRect(
//                         borderRadius: BorderRadius.circular(40),
//                         child: Image.network(
//                           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUyCn1ItXdchQzeH8MkPEtQJcKttTplAw7oDrBuQI&s',
//                           height: 70,
//                           width: 70,
//                         )),
//                     Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Sound Cloud',
//                             style: TextStyle(color: Colors.white, fontSize: 18),
//                           ),
//                           const Text(
//                             'Name Goes',
//                             style: TextStyle(color: Colors.white, fontSize: 15),
//                           ),
//                           const Text(
//                             'Song Name Goes here',
//                             style: TextStyle(color: Colors.white, fontSize: 20),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
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
//       });
//   }
// }