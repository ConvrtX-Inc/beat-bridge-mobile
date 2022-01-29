// ignore_for_file: use_key_in_widget_constructors, sort_constructors_first, diagnostic_describe_all_properties, public_member_api_docs, must_be_immutable, always_specify_types, curly_braces_in_flow_control_structures, unnecessary_lambdas, prefer_const_constructors_in_immutables

import 'dart:async';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/controller/audio_controller.dart';
import 'package:beatbridge/models/queue_playing_model.dart';
import 'package:beatbridge/models/spotify/play_list.dart';
import 'package:beatbridge/models/spotify/track.dart';
import 'package:beatbridge/screens/main_navigations/queues/widgets/audio_file.dart';
import 'package:beatbridge/utils/constant.dart';
import 'package:beatbridge/utils/queue_playing_screen_mockdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///PlayList Screen
class PlayMusicScreen extends StatefulWidget {
  ///contructor
  final PlayListTrack track;
  final List<PlayListTrack> playListItems;
  final PlayList playList;
  PlayMusicScreen(this.track, this.playListItems, this.playList);
  @override
  State<PlayMusicScreen> createState() => _PlayMusicScreenState();
}

class _PlayMusicScreenState extends State<PlayMusicScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<QueuePlayingModels> playerItems =
      QueuePlayingMockdataUtils.getMockedDataQueuePlaying();
  final trackChangeController = Get.put(TrackChangeController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      trackChangeController.setTrack(widget.track);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: FutureBuilder<bool>(
        future: SpotifySdk.connectToSpotifyRemote(
            clientId: dotenv.env['CLIENT_ID'].toString(),
            redirectUrl: dotenv.env['REDIRECT_URL'].toString()),
        builder: (BuildContext context, AsyncSnapshot<bool> response) {
          switch (response.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (response.hasError) {
                return Text(response.error.toString(),
                    style: TextStyle(
                        color: AppColorConstants.roseWhite, fontSize: 15));
              } else {
                // play();
                return getBody(context);
              }
            // ignore: no_default_cases
            default:
              return const Text('Unhandle State');
          }
        },
      ),
      // body: getBody(context),
      backgroundColor: Constants.bgColor,
    );
  }

  Widget getBody(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 22.h,
            ),
            // IconButton(
            //   padding: EdgeInsets.zero,
            //   icon: Icon(
            //     Icons.arrow_back_ios,
            //     color: AppColorConstants.roseWhite,
            //   ),
            // onPressed: () {
            //   Navigator.of(context).pop();
            // },
            // ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColorConstants.roseWhite,
              ),
            ),
            SizedBox(
              height: 22.h,
            ),
            Text(
              widget.playList.name!,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Constants.heightSpacing20,
            const Text(
              'Platforms:',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w300),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(Constants.image2),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            GetBuilder<TrackChangeController>(builder: (controller) {
              return Row(children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(controller
                            .track.value.track!.album!.images!.first.url
                            .toString()),
                        fit: BoxFit.cover),
                    // image: DecorationImage(
                    //   fit: BoxFit.cover,
                    //   image: AssetImage('assets/images/ellie.png'),
                    // ),
                  ),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Image.asset(Constants.image2, scale: 1.7)),
                ),
                Constants.spacingwidth20,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      'Spotify',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      controller.track.value.track!.artists!.first.name!,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w200),
                    ),
                    SizedBox(
                      width: width * 0.6,
                      child: Text(
                        controller.track.value.track!.name!,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              ]);
            }),
            Constants.heightSpacing30,
            AudioFile(widget.track, widget.playListItems),
            Constants.heightSpacing30,
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    'Up Next',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {},
                  child: Container(
                      width: 85,
                      height: 25,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Constants.lightviolet,
                              Constants.lightred,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(3)),
                      child: const Center(
                        child: Text(
                          'Add Music',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                )
              ],
            ),
            Constants.heightSpacing20,
            Expanded(
              child: ListView.builder(
                  itemCount: widget.playListItems.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return Column(
                      children: [
                        _queueplayerItems(
                            context, index, widget.playListItems[index]),
                        const Divider(
                          thickness: 0.5,
                        )
                      ],
                    );
                  }),
            ),
          ],
        ),
      )
    ]);
  }

  Widget _queueplayerItems(
      BuildContext context, int index, PlayListTrack track) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                            image: NetworkImage(track
                                .track!.album!.images!.first.url
                                .toString()),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.track!.name!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        track.track!.artists!.first.name!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w200),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Image.asset(Constants.carbonDelete),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> play() async {
    try {
      await SpotifySdk.play(
          spotifyUri: 'spotify:track:${widget.track.track!.id}');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
    print(message);
  }
}
