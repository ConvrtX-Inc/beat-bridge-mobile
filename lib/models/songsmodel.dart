import 'package:beatbridge/models/spotify/getQueuesBasedOnId.dart';

class SongsData {
  var id, name, uri, platform, queueId, userId;
  TrackDataa? tracksData;
  // List<ProvinceResult> towns;
  SongsData(
      {this.name,
      this.platform,
      this.queueId,
      this.tracksData,
      this.uri,
      this.userId,
      this.id});
  factory SongsData.fromJson(Map json) {
    return SongsData(
      name: json['name'] ?? "",
      tracksData: TrackDataa.fromJson(json['trackdata']),
      //  .fromJson(json['department'])
      // json['trackdata'] ?? "",
      id: json['id'] ?? "",
      uri: json['uri'] ?? "",
      platform: json['platform'] ?? "",
      userId: json['user_id'] ?? "",
      queueId: json['queueId'] ?? "",
      // name: json['name'],
    );
  }
}

class TrackDataa {
  Tracks? tracks;
  // List<ProvinceResult> towns;
  TrackDataa({
    this.tracks,
  });
  factory TrackDataa.fromJson(Map json) {
    return TrackDataa(
      tracks: Tracks.fromJson(json['track']),
      //  ?? "",

      // name: json['name'],
    );
  }
}

class Tracks {
  var id, name, uri, type, href;
  Album? album;
  // List<ProvinceResult> towns;
  Tracks({this.name, this.album, this.href, this.id, this.type, this.uri});
  factory Tracks.fromJson(Map json) {
    return Tracks(
      name: json['name'] ?? "",
      album: Album.fromJson(json['album']),
      //  json['album'] ?? "",
      id: json['id'] ?? "",
      type: json['type'] ?? "",
      uri: json['uri'] ?? "",
      href: json['href'] ?? "",

      // name: json['name'],
    );
  }
}

class Album {
  List<Images>? images = [];
  List<Artist>? artist = [];
  var name;
  // List<ProvinceResult> towns;
  Album({this.images, this.name, this.artist});
  factory Album.fromJson(Map json) {
    return Album(
      images: (json['images'] as List).map((e) => Images.fromJson(e)).toList(),
      // json['images'] ?? "",
      name: json['name'] ?? "",
      artist: (json['artists'] as List).map((e) => Artist.fromJson(e)).toList(),
      //  json['artists'] ?? [],

      // name: json['name'],
    );
  }
}

class Artist {
  var id, uri, name;
  // List<ProvinceResult> towns;
  Artist({this.id, this.uri, this.name});
  factory Artist.fromJson(Map json) {
    return Artist(
      id: json['id'] ?? "",
      uri: json['uri'] ?? "",
      name: json['name'] ?? "",

      // name: json['name'],
    );
  }
}

class Images {
  var url;
  // List<ProvinceResult> towns;
  Images({this.url});
  factory Images.fromJson(Map json) {
    return Images(
      url: json['url'] ?? "",

      // name: json['name'],
    );
  }
}

// class SongsModel {
//   List<SongsResult>? result = [];

//   SongsModel({
//     this.result,
//   });

//   factory SongsModel.fromJson(Map<String, dynamic> json) {
//     return SongsModel(
//       withError: json['error'],
//       shortMessage: json['message'],

//       result:
//           (json['data'] as List).map((e) => BiddingResult.fromJson(e)).toList(),
//       // result:
//       //     (json['data'] as List).map((e) => Moodels.fromJson(e)).toList() ?? [],
//     );
//   }
// }

// class SongsResult {
//   var id, price, userId, departmentId;

//   SongsModel(
//       {this.productResult,
//       this.departmentId,
//       this.id,
//       this.depart,
//       this.price,
//       this.userId});
//   factory SongsResult.fromJson(Map<String, dynamic> json) {
//     return SongsResult(
//       productResult: ProductResult.fromLinkedHashMap(json['product']),
//       id: json['id'] ?? "",
//       depart: json['department'] == null
//           ? null
//           : department.fromJson(json['department']),
//       userId: json["user_id"] ?? "",
//       price: json['price'] ?? "",
//       // departmentId: json['department_id'] ?? "",
//     );
//   }
// }

// class TrackResult {
//   var id, price, userId, departmentId;

//   TrackResult(
//       {this.productResult,
//       this.departmentId,
//       this.id,
//       this.depart,
//       this.price,
//       this.userId});
//   factory TrackResult.fromJson(Map<String, dynamic> json) {
//     return SongsReTrackResultsult(
//       productResult: ProductResult.fromLinkedHashMap(json['product']),
//       id: json['id'] ?? "",
//       depart: json['department'] == null
//           ? null
//           : department.fromJson(json['department']),
//       userId: json["user_id"] ?? "",
//       price: json['price'] ?? "",
//       // departmentId: json['department_id'] ?? "",
//     );
//   }
// }
