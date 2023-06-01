import 'package:beatbridge/utils/services/spotify_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify/spotify.dart' as spot;
import 'package:spotify_sdk/spotify_sdk.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_path.dart';

class SeeMostPlayed extends StatefulWidget {
  const SeeMostPlayed({Key? key}) : super(key: key);

  @override
  State<SeeMostPlayed> createState() => _SeeMostPlayedState();
}

class _SeeMostPlayedState extends State<SeeMostPlayed> {
  var songURL;
  var songName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SpotifyApiService.getTopTracks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 12,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColorConstants.roseWhite,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  'Most Played Songs',
                  style: TextStyle(
                      color: AppColorConstants.roseWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      fontFamily: 'Gilroy'),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: FutureBuilder<Iterable<spot.Track>>(
                  future: SpotifyApiService.getTopTracks(),
                  builder: (BuildContext context,
                      AsyncSnapshot<Iterable<spot.Track>> recentPlayed) {
                    if (recentPlayed.hasData) {
                      return ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                                height: 10,
                              ),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 11.w,
                                ),
                                child:
                                    buildTopPlayedItemList(recentPlayed.data!));
                          });
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }

  Widget buildTopPlayedItemList(Iterable<spot.Track> rPlayed) {
    return Column(
      // FIRST SPRINT DISABLED ITEM BELOW
      children: List.generate(rPlayed.length,
          (int index) => buildTopPlayedItem(rPlayed.elementAt(index), index)),

      // FIRST SPRINT DISABLED ITEM up
    );
  }

  Widget buildTopPlayedItem(spot.Track item, int index) {
    return ListTile(
      onTap: () async {
        songName = item.name.toString();
        songURL = item.uri.toString();
        await play(songURL);
      },
      contentPadding: EdgeInsets.zero,
      key: Key(item.id.toString()),
      leading: FutureBuilder<spot.Artist>(
        future: SpotifyApiService.getArtistDetails(
            item.artists!.first.id!), // async work
        builder: (BuildContext context, AsyncSnapshot<spot.Artist> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const SizedBox(
                height: 50,
                width: 50,
                child: Center(child: CircularProgressIndicator()),
              );

            // ignore: no_default_cases
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                          image: NetworkImage(
                              snapshot?.data?.images?.first?.url.toString() ??
                                  "Empty"),
                          fit: BoxFit.cover),
                    ),
                    child: Align(
                      child: Image.asset(
                          '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}'),
                    ),
                  ),
                );
              }
          }
        },
      ),
      title: Text(
        item.name ?? "null",
        key: Key(index.toString() + item.id.toString()),
        style: TextStyle(
            color: AppColorConstants.roseWhite,
            fontWeight: FontWeight.w600,
            fontSize: 17),
      ),
      subtitle: Text(
        item.artists?.last.name ?? "empty",
        key: Key("item" + index.toString()),
        style: TextStyle(color: AppColorConstants.paleSky, fontSize: 13),
      ),
    );
  }

  Future<void> play(String uri) async {
    try {
      await SpotifySdk.play(spotifyUri: uri);
      SpotifySdk.seekTo(positionedMilliseconds: 0);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
  }
}
