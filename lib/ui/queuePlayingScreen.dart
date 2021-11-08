// ignore_for_file: file_names

import 'package:beatbridge/models/queuePlayingModel.dart';
import 'package:beatbridge/ui/audio_file.dart';
import 'package:beatbridge/utils/constant.dart';
import 'package:beatbridge/utils/queuePlayingScreen_mockdata.dart';
import 'package:flutter/material.dart';

class queuePlayingScreen extends StatefulWidget {
  const queuePlayingScreen({Key? key}) : super(key: key);

  @override
  _queuePlayingScreenState createState() => _queuePlayingScreenState();
}

class _queuePlayingScreenState extends State<queuePlayingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<queuePlayingModels> playerItems =
      QueuePlayingMockdataUtils.getMockedDataQueuePlaying();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        backgroundColor: Constants.bgColor,
        elevation: 0.5,
      ),
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: getBody(context),
      backgroundColor: Constants.bgColor,
    );
  }

  Widget getBody(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Karaoke at Eric's",
              style: TextStyle(
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
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Image.asset(Constants.image1),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(Constants.image2),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(children: [
              Container(
                width: 55,
                height: 55,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/ellie.png'),
                    )),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(Constants.image1, scale: 1.7)),
              ),
              
              Constants.spacingwidth20,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text(
                    'SOUND CLOUD',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700),
                  ),
                  const Text(
                    'Ellie Goulding',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w200),
                  ),
                  const Text(
                    'Love me like you do',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ]),
            Constants.heightSpacing30,
            const AudioFile(),
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
                  itemCount: playerItems.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return Column(
                      children: [
                        _queueplayerItems(context, index),
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
    BuildContext context,
    int index,
  ) {
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
                          fit: BoxFit.cover,
                          image: AssetImage('${playerItems[index].imgUrl}'),
                        ),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playerItems[index].title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      playerItems[index].name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w200),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('${playerItems[index].type}'),
                        fit: BoxFit.cover,
                      ),
                    )),
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
}
