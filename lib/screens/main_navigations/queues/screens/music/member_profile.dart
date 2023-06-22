import 'package:beatbridge/helpers/basehelper.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/songsmodel.dart';
import 'package:beatbridge/models/users/new_queue_model.dart';
import 'package:beatbridge/models/users/queue_member_model.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../../../../../constants/app_constants.dart';
import 'package:spotify/spotify.dart' as spot;

import '../../../../../constants/asset_path.dart';
import '../../../../../utils/services/spotify_api_service.dart';

class MemberProfile extends StatefulWidget {
  MemberProfile(this.memberData);
  final QueueMemberModel memberData;

  @override
  State<MemberProfile> createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
  ValueNotifier<List<SongsData>> songsData = ValueNotifier<List<SongsData>>([]);
  var checkFriend;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserSongs();
    checkUser();
  }

  checkUser() async {
    setState(() {
      checkFriend = null;
    });
    await BaseHelper()
        .checkFriend(widget.memberData.user.id.toString(), context)
        .then((value) {
      print("check friend response: $value");
      setState(() {
        checkFriend = value['response']['code'];
      });
    });
  }

  getUserSongs() {
    print("other user id: ${widget.memberData.user.id}");
    BaseHelper()
        .getUserSongs(
            context: context, queueId: widget.memberData.user.id, isUser: false)
        .then((value) {
      setState(() {
        songsData.value = value;
      });
    });
  }

  bool isAPICallInProgress = false;
  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 1)));
  }

  Future<void> addFriend(email) async {
    setState(() {
      isAPICallInProgress = !isAPICallInProgress;
      // selectedFriendIndex = index;
    });

    final APIStandardReturnFormat result = await APIServices().addFriend(email);
    if (result.statusCode == 200) {
      _showToast(context, AppTextConstants.friendRequestSent);

      checkUser();
    } else {
      setState(() {
        isAPICallInProgress = false;
        // hasError = true;
      });

      _showToast(context, AppTextConstants.anErrorOccurred);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/member_background.png'),
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6), BlendMode.darken),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Image.asset(
                                'assets/images/cross.png',
                                height: 20,
                              )),
                        ],
                      ),
                      // ignore: prefer_if_elements_to_conditional_expressions
                      widget.memberData.user?.image != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(120)),
                                    child: Image.network(
                                      "${BaseHelper().baseUrl}${widget.memberData.user.image}",
                                      fit: BoxFit.cover,
                                      height: 130,
                                      width: 130,
                                    ))
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(120)),
                                      child: Image.asset(
                                        'assets/images/ellie.png',
                                        fit: BoxFit.cover,
                                        height: 130,
                                        width: 130,
                                      )),
                                ),
                              ],
                            ),

                      SizedBox(
                        height: 15,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.memberData.user.username,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColorConstants.roseWhite,
                                // fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'GilroyBold',
                              )),
                        ],
                      ),
                      checkFriend == null
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isAPICallInProgress == true
                                    ? CircularProgressIndicator()
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.purple,
                                        ),
                                        onPressed: () {
                                          if (checkFriend.toString().contains(
                                              "youAreNotFriendWithThisUser")) {
                                            addFriend(
                                                widget.memberData.user.email);
                                          } else {}
                                        },
                                        child: Text(
                                            checkFriend.toString().contains(
                                                    "youAreNotFriendWithThisUser")
                                                ? 'Add Friend'
                                                : checkFriend
                                                        .toString()
                                                        .contains(
                                                            "requestExists")
                                                    ? "Already Requested"
                                                    : 'Already Friend',
                                            style: TextStyle(
                                              color:
                                                  AppColorConstants.roseWhite,
                                              // fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              fontFamily: 'GilroyBold',
                                            )),
                                      ),
                              ],
                            ),
                      SizedBox(
                        height: 15,
                      ),
                      Text('Recently Played',
                          style: TextStyle(
                            color: AppColorConstants.roseWhite,
                            // fontWeight: FontWeight.bold,
                            fontSize: 22,
                            fontFamily: 'GilroyBold',
                          )),
                      SizedBox(
                        height: 15,
                      ),

                      // FutureBuilder<String>(
                      //   future: SpotifyApiService
                      //       .getAuthenticationToken(), // async work
                      //   builder:
                      //       (BuildContext context, AsyncSnapshot<String> snapshot) {
                      //     switch (snapshot.connectionState) {
                      //       case ConnectionState.waiting:
                      //         return const Center(
                      //           child: CircularProgressIndicator(),
                      //         );
                      //       case ConnectionState.done:
                      //         print('spotify token ${snapshot.data}');

                      //         return FutureBuilder<Iterable<spot.Track>>(
                      //           future: SpotifyApiService.getTopTracks(),
                      //           builder: (BuildContext context,
                      //               AsyncSnapshot<Iterable<spot.Track>>
                      //                   recentPlayed) {
                      //             switch (recentPlayed.connectionState) {
                      //               case ConnectionState.waiting:
                      //                 return const Center(
                      //                   child: CircularProgressIndicator(),
                      //                 );
                      //               case ConnectionState.done:
                      //                 if (recentPlayed.hasError) {
                      //                   return Text(recentPlayed.error.toString());
                      //                 } else {
                      //                   return Padding(
                      //                       padding: EdgeInsets.symmetric(
                      //                         horizontal: 11.w,
                      //                       ),
                      //                       child: buildTopPlayedItemList(
                      //                           recentPlayed.data!));
                      //                 }
                      //               // ignore: no_default_cases
                      //               default:
                      //                 return const Text('Unhandle State');
                      //             }
                      //           },
                      //         );
                      //       // ignore: no_default_cases
                      //       default:
                      //         return snapshot.hasError
                      //             ? Center(child: Text('Error: ${snapshot.error}'))
                      //             : Container();
                      //     }
                      //   },
                      // ),
                    ],
                  ),
                ),
                ValueListenableBuilder<List<SongsData>>(
                    valueListenable: songsData,
                    builder: (BuildContext context, value, Widget? child) {
                      // ignore: unnecessary_null_comparison
                      // print("hedsadsallo: $value");
                      if (value.isEmpty) {
                        return SliverToBoxAdapter(
                          child: SizedBox(
                            // height: MediaQuery.of(context).size.height * .06,
                            width: MediaQuery.of(context).size.width * .9,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (context, int index) {
                          return newSongsWidget(value[index], index);
                        }, childCount: value.length));
                        // Container(
                        //   width: MediaQuery.of(context).size.width * .9,
                        //   height: MediaQuery.of(context).size.height * .25,
                        //   child:
                        //   ),
                        // ListView.builder(
                        //   itemBuilder: (context, index) {
                        //     return newSongsWidget(value[index], index);
                        //   },
                        //   itemCount: value.length >= 3 ? 3 : value.length,
                        // )
                        // );
                      }
                    }),
              ],
            )),
      ),
    );
  }

  Future<void> play(String uri) async {
    try {
      await SpotifySdk.play(spotifyUri: uri);
      SpotifySdk.seekTo(positionedMilliseconds: 0);
      // await SpotifySdk.play(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      // setStatus(e.code, message: e.message);
    } on MissingPluginException {
      // setStatus('not implemented');
    }
  }

  Widget buildTopPlayedItem(spot.Track item, int index) {
    return InkWell(
      onTap: () async {
        BaseHelper()
            .songsPLayed(context: context, uriId: item.uri.toString())
            .then((value) {
          print("song played with uri");
        });
        await play(item.uri.toString());
      },
      child: ListTile(
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
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                else
                  return Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                            image: NetworkImage(
                                snapshot.data!.images!.first.url.toString()),
                            fit: BoxFit.cover),
                      ),
                      child: Align(
                        child: Image.asset(
                            '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}'),
                      ),
                    ),
                  );
            }
          },
        ),
        title: Text(
          item.name!,
          key: Key(index.toString() + item.id.toString()),
          style: TextStyle(
              color: AppColorConstants.roseWhite,
              fontWeight: FontWeight.w600,
              fontSize: 17),
        ),
        subtitle: Text(
          item.artists!.last.name!,
          key: Key("item" + index.toString()),
          style: TextStyle(color: AppColorConstants.paleSky, fontSize: 13),
        ),
      ),
    );
  }

  Widget newSongsWidget(SongsData songsResult, int index) {
    // print(
    //     "image url: ${songsResult.tracksData!.tracks!.album!.images![0].url}");
    return ListTile(
      onTap: () async {
        BaseHelper()
            .songsPLayed(context: context, uriId: songsResult.uri.toString())
            .then((value) {
          print("song played with uri");
        });
        var songName = songsResult.name.toString();
        var songURL = songsResult.uri.toString();
        await play(songURL);
      },
      contentPadding: EdgeInsets.zero,
      key: Key(songsResult.id.toString()),
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
              image: NetworkImage(songsResult
                  .tracksData!.tracks!.album!.images!.first.url
                  .toString()),
              fit: BoxFit.cover),
        ),
        child: Align(
          child: Image.asset(
              '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}'),
        ),
      ),

      // FutureBuilder<spot.Artist>(
      //   future: SpotifyApiService.getArtistDetails(
      //       songsResult.tracksData!.tracks.artists!.first.id!), // async work
      //   builder: (BuildContext context, AsyncSnapshot<spot.Artist> snapshot) {
      //     switch (snapshot.connectionState) {
      //       case ConnectionState.waiting:
      //         return const SizedBox(
      //           height: 50,
      //           width: 50,
      //           child: Center(child: CircularProgressIndicator()),
      //         );

      //       // ignore: no_default_cases
      //       default:
      //         if (snapshot.hasError)
      //           return Text('Error: ${snapshot.error}');
      //         else
      //           print(
      //               "uri images :  ${snapshot.data!.images!.first.url.toString()}");

      //         return Padding(
      //           padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
      //           child: Container(
      //             height: 50,
      //             width: 50,
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(8),
      //               image: DecorationImage(
      //                   image: NetworkImage(
      //                       snapshot.data!.images!.first.url.toString()),
      //                   fit: BoxFit.cover),
      //             ),
      //             child: Align(
      //               child: Image.asset(
      //                   '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}'),
      //             ),
      //           ),
      //         );
      //     }
      //   },
      // ),

      title: Text(
        "${songsResult.tracksData!.tracks!.album!.artist!.first.name}",
        key: Key(index.toString() + songsResult.id.toString()),
        style: TextStyle(
            color: AppColorConstants.roseWhite,
            fontWeight: FontWeight.w600,
            fontSize: 17),
      ),
      subtitle: Text(
        "${songsResult.tracksData!.tracks!.album!.name}",
        key: Key("item" + index.toString()),
        style: TextStyle(color: AppColorConstants.paleSky, fontSize: 13),
      ),
    );
  }

  Widget buildTopPlayedItemList(Iterable<spot.Track> rPlayed) {
    final Iterable<spot.Track> firstFour = rPlayed.take(rPlayed.length);
    //*scrollable top played items*//
    // return ListView.builder(
    //   shrinkWrap: true,
    //   key: const Key('topList'),
    //   itemCount: firstFour.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     // return Text(rPlayed.elementAt(index).id.toString());
    //     return buildTopPlayedItem(firstFour.elementAt(index), index);
    //   },
    // );
    return Column(
      // FIRST SPRINT DISABLED ITEM BELOW

      children: List.generate(firstFour.length,
          (int index) => buildTopPlayedItem(firstFour.elementAt(index), index)),

      // FIRST SPRINT DISABLED ITEM up
    );
  }
}
