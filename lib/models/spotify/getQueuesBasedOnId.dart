// To parse this JSON data, do
//
//     final getTrackAgainstQueueId = getTrackAgainstQueueIdFromJson(jsonString);

import 'dart:convert';

List<GetTrackAgainstQueueId> getTrackAgainstQueueIdFromJson(String str) => List<GetTrackAgainstQueueId>.from(json.decode(str).map((x) => GetTrackAgainstQueueId.fromJson(x)));

String getTrackAgainstQueueIdToJson(List<GetTrackAgainstQueueId> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetTrackAgainstQueueId {
  GetTrackAgainstQueueId({
    this.id,
    this.name,
    this.totalPlayCount,
    this.uri,
    this.platform,
    this.queueId,
    this.userId,
    this.trackData,
    this.owner,
    this.createdDate,
    this.updatedDate,
    this.deletedDate,
    this.entity,
  });

  String ?id;
  String ?name;
  int ?totalPlayCount;
  String ?uri;
  dynamic platform;
  String ?queueId;
  String ?userId;
  TrackData ?trackData;
  Owner ?owner;
  DateTime ?createdDate;
  DateTime ?updatedDate;
  dynamic deletedDate;
  String ?entity;

  factory GetTrackAgainstQueueId.fromJson(Map<String, dynamic> json) => GetTrackAgainstQueueId(
    id: json["id"],
    name: json["name"],
    totalPlayCount: json["total_play_count"],
    uri: json["uri"],
    platform: json["platform"],
    queueId: json["queueId"],
    userId: json["user_id"],
    trackData: TrackData.fromJson(json["trackData"]),
    owner: Owner.fromJson(json["owner"]),
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    deletedDate: json["deleted_date"],
    entity: json["__entity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "total_play_count": totalPlayCount,
    "uri": uri,
    "platform": platform,
    "queueId": queueId,
    "user_id": userId,
    "trackData": trackData?.toJson(),
    "owner": owner?.toJson(),
    "created_date": createdDate?.toIso8601String(),
    "updated_date": updatedDate?.toIso8601String(),
    "deleted_date": deletedDate,
    "__entity": entity,
  };
}

class Owner {
  Owner({
    this.id,
    this.uri,
    this.href,
    this.type,
    this.displayName,
    this.externalUrls,
    this.name,
  });

  Id ?id;
  Uri ?uri;
  String ?href;
  Type ?type;
  String ?displayName;
  ExternalUrls ?externalUrls;
  String ?name;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    id: idValues.map![json["id"]],
    uri: uriValues.map![json["uri"]],
    href: json["href"],
    type: typeValues.map![json["type"]],
    displayName: json["display_name"] == null ? null : json["display_name"],
    externalUrls: ExternalUrls.fromJson(json["external_urls"]),
    name: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": idValues.reverse![id],
    "uri": uriValues.reverse![uri],
    "href": href,
    "type": typeValues.reverse![type],
    "display_name": displayName == null ? null : displayName,
    "external_urls": externalUrls?.toJson(),
    "name": name == null ? null : name,
  };
}

class ExternalUrls {
  ExternalUrls({
    this.spotify,
  });

  String ?spotify;

  factory ExternalUrls.fromJson(Map<String, dynamic> json) => ExternalUrls(
    spotify: json["spotify"],
  );

  Map<String, dynamic> toJson() => {
    "spotify": spotify,
  };
}

enum Id { THE_31_SGPXJ5_HWQTFUQQHSA2_FMF2_QVUQ, THE_03_S_ZMF_K_AG_YRQK_UWY0_EO_J_UA }

final idValues = EnumValues({
  "03SZmfKAgYRQKUwy0EoJUa": Id.THE_03_S_ZMF_K_AG_YRQK_UWY0_EO_J_UA,
  "31sgpxj5hwqtfuqqhsa2fmf2qvuq": Id.THE_31_SGPXJ5_HWQTFUQQHSA2_FMF2_QVUQ
});

enum Type { USER, ARTIST }

final typeValues = EnumValues({
  "artist": Type.ARTIST,
  "user": Type.USER
});

enum Uri { SPOTIFY_USER_31_SGPXJ5_HWQTFUQQHSA2_FMF2_QVUQ, SPOTIFY_ARTIST_03_S_ZMF_K_AG_YRQK_UWY0_EO_J_UA }

final uriValues = EnumValues({
  "spotify:artist:03SZmfKAgYRQKUwy0EoJUa": Uri.SPOTIFY_ARTIST_03_S_ZMF_K_AG_YRQK_UWY0_EO_J_UA,
  "spotify:user:31sgpxj5hwqtfuqqhsa2fmf2qvuq": Uri.SPOTIFY_USER_31_SGPXJ5_HWQTFUQQHSA2_FMF2_QVUQ
});

class TrackData {
  TrackData({
    this.track,
    this.addedAt,
    this.addedBy,
    this.isLocal,
    this.primaryColor,
    this.videoThumbnail,
  });

  Track? track;
  DateTime ?addedAt;
  Owner ?addedBy;
  bool? isLocal;
  dynamic primaryColor;
  VideoThumbnail ?videoThumbnail;

  factory TrackData.fromJson(Map<String, dynamic> json) => TrackData(
    track: Track.fromJson(json["track"]),
    addedAt: DateTime.parse(json["added_at"]),
    addedBy: Owner.fromJson(json["added_by"]),
    isLocal: json["is_local"],
    primaryColor: json["primary_color"],
    videoThumbnail: VideoThumbnail.fromJson(json["video_thumbnail"]),
  );

  Map<String, dynamic> toJson() => {
    "track": track?.toJson(),
    "added_at": addedAt?.toIso8601String(),
    "added_by": addedBy?.toJson(),
    "is_local": isLocal,
    "primary_color": primaryColor,
    "video_thumbnail": videoThumbnail?.toJson(),
  };
}

class Track {
  Track({
    this.id,
    this.uri,
    this.href,
    this.name,
    this.type,
    this.album,
    this.track,
    this.artists,
    this.episode,
    this.explicit,
    this.isLocal,
    this.popularity,
    this.discNumber,
    this.durationMs,
    this.previewUrl,
    this.externalIds,
    this.trackNumber,
    this.externalUrls,
    this.availableMarkets,
  });

  String ?id;
  String ?uri;
  String ?href;
  String ?name;
  String ?type;
  Album ?album;
  bool ?track;
  List<Owner> ?artists;
  bool ?episode;
  bool ?explicit;
  bool ?isLocal;
  int ?popularity;
  int ?discNumber;
  int ?durationMs;
  String ?previewUrl;
  ExternalIds ?externalIds;
  int ?trackNumber;
  ExternalUrls ?externalUrls;
  List<String> ?availableMarkets;

  factory Track.fromJson(Map<String, dynamic> json) => Track(
    id: json["id"],
    uri: json["uri"],
    href: json["href"],
    name: json["name"],
    type: json["type"],
    album: Album.fromJson(json["album"]),
    track: json["track"],
    artists: List<Owner>.from(json["artists"].map((x) => Owner.fromJson(x))),
    episode: json["episode"],
    explicit: json["explicit"],
    isLocal: json["is_local"],
    popularity: json["popularity"],
    discNumber: json["disc_number"],
    durationMs: json["duration_ms"],
    previewUrl: json["preview_url"],
    externalIds: ExternalIds.fromJson(json["external_ids"]),
    trackNumber: json["track_number"],
    externalUrls: ExternalUrls.fromJson(json["external_urls"]),
    availableMarkets: List<String>.from(json["available_markets"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uri": uri,
    "href": href,
    "name": name,
    "type": type,
    "album": album?.toJson(),
    "track": track,
    "artists": List<dynamic>.from(artists!.map((x) => x.toJson())),
    "episode": episode,
    "explicit": explicit,
    "is_local": isLocal,
    "popularity": popularity,
    "disc_number": discNumber,
    "duration_ms": durationMs,
    "preview_url": previewUrl,
    "external_ids": externalIds?.toJson(),
    "track_number": trackNumber,
    "external_urls": externalUrls?.toJson(),
    "available_markets": List<dynamic>.from(availableMarkets!.map((x) => x)),
  };
}

class Album {
  Album({
    this.id,
    this.uri,
    this.href,
    this.name,
    this.type,
    this.images,
    this.artists,
    this.albumType,
    this.releaseDate,
    this.totalTracks,
    this.externalUrls,
    this.availableMarkets,
    this.releaseDatePrecision,
  });

  String ?id;
  String ?uri;
  String ?href;
  String ?name;
  String ?type;
  List<Image> ?images;
  List<Owner> ?artists;
  String ?albumType;
  DateTime ?releaseDate;
  int ?totalTracks;
  ExternalUrls ?externalUrls;
  List<String> ?availableMarkets;
  String ?releaseDatePrecision;

  factory Album.fromJson(Map<String, dynamic> json) => Album(
    id: json["id"],
    uri: json["uri"],
    href: json["href"],
    name: json["name"],
    type: json["type"],
    images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
    artists: List<Owner>.from(json["artists"].map((x) => Owner.fromJson(x))),
    albumType: json["album_type"],
    releaseDate: DateTime.parse(json["release_date"]),
    totalTracks: json["total_tracks"],
    externalUrls: ExternalUrls.fromJson(json["external_urls"]),
    availableMarkets: List<String>.from(json["available_markets"].map((x) => x)),
    releaseDatePrecision: json["release_date_precision"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uri": uri,
    "href": href,
    "name": name,
    "type": type,
    "images": List<dynamic>.from(images!.map((x) => x.toJson())),
    "artists": List<dynamic>.from(artists!.map((x) => x.toJson())),
    "album_type": albumType,
    "release_date": "${releaseDate?.year.toString().padLeft(4, '0')}-${releaseDate?.month.toString().padLeft(2, '0')}-${releaseDate?.day.toString().padLeft(2, '0')}",
    "total_tracks": totalTracks,
    "external_urls": externalUrls?.toJson(),
    "available_markets": List<dynamic>.from(availableMarkets!.map((x) => x)),
    "release_date_precision": releaseDatePrecision,
  };
}

class Image {
  Image({
    this.url,
    this.width,
    this.height,
  });

  String ?url;
  int ?width;
  int ?height;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    url: json["url"],
    width: json["width"],
    height: json["height"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "width": width,
    "height": height,
  };
}

class ExternalIds {
  ExternalIds({
    this.isrc,
  });

  String ?isrc;

  factory ExternalIds.fromJson(Map<String, dynamic> json) => ExternalIds(
    isrc: json["isrc"],
  );

  Map<String, dynamic> toJson() => {
    "isrc": isrc,
  };
}

class VideoThumbnail {
  VideoThumbnail({
    this.url,
  });

  dynamic url;

  factory VideoThumbnail.fromJson(Map<String, dynamic> json) => VideoThumbnail(
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
  };
}

class EnumValues<T> {
  Map<String, T> ?map;
  Map<T, String> ?reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map?.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
