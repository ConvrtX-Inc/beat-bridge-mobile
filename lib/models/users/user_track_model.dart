class UserTrackModel {
  String? id;
  String? name;
  String? uri;
  String? platform;
  String? queueId;
  String? userId;
  Owner? owner;
  Trackdata? trackdata;
  int? totalPlayCount;
  String? createdDate;
  String? updatedDate;
  Null? deletedDate;

  UserTrackModel(
      {this.id,
      this.name,
      this.uri,
      this.platform,
      this.queueId,
      this.userId,
      this.owner,
      this.trackdata,
      this.totalPlayCount,
      this.createdDate,
      this.updatedDate,
      this.deletedDate});

  UserTrackModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    uri = json['uri'];
    platform = json['platform'];
    queueId = json['queueId'];
    userId = json['user_id'];
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    trackdata = json['trackdata'] != null
        ? new Trackdata.fromJson(json['trackdata'])
        : null;
    totalPlayCount = json['total_play_count'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    deletedDate = json['deleted_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['uri'] = this.uri;
    data['platform'] = this.platform;
    data['queueId'] = this.queueId;
    data['user_id'] = this.userId;
    if (this.owner != null) {
      data['owner'] = this.owner!.toJson();
    }
    if (this.trackdata != null) {
      data['trackdata'] = this.trackdata!.toJson();
    }
    data['total_play_count'] = this.totalPlayCount;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    data['deleted_date'] = this.deletedDate;
    return data;
  }
}

class Owner {
  String? id;
  String? uri;
  String? href;
  String? type;
  String? displayName;
  ExternalUrls? externalUrls;

  Owner(
      {this.id,
      this.uri,
      this.href,
      this.type,
      this.displayName,
      this.externalUrls});

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uri = json['uri'];
    href = json['href'];
    type = json['type'];
    displayName = json['display_name'];
    externalUrls = json['external_urls'] != null
        ? new ExternalUrls.fromJson(json['external_urls'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uri'] = this.uri;
    data['href'] = this.href;
    data['type'] = this.type;
    data['display_name'] = this.displayName;
    if (this.externalUrls != null) {
      data['external_urls'] = this.externalUrls!.toJson();
    }
    return data;
  }
}

class ExternalUrls {
  String? spotify;

  ExternalUrls({this.spotify});

  ExternalUrls.fromJson(Map<String, dynamic> json) {
    spotify = json['spotify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spotify'] = this.spotify;
    return data;
  }
}

class Trackdata {
  Track? track;
  String? addedAt;
  AddedBy? addedBy;
  bool? isLocal;
  Null? primaryColor;
  VideoThumbnail? videoThumbnail;

  Trackdata(
      {this.track,
      this.addedAt,
      this.addedBy,
      this.isLocal,
      this.primaryColor,
      this.videoThumbnail});

  Trackdata.fromJson(Map<String, dynamic> json) {
    track = json['track'] != null ? new Track.fromJson(json['track']) : null;
    addedAt = json['added_at'];
    addedBy = json['added_by'] != null
        ? new AddedBy.fromJson(json['added_by'])
        : null;
    isLocal = json['is_local'];
    primaryColor = json['primary_color'];
    videoThumbnail = json['video_thumbnail'] != null
        ? new VideoThumbnail.fromJson(json['video_thumbnail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.track != null) {
      data['track'] = this.track!.toJson();
    }
    data['added_at'] = this.addedAt;
    if (this.addedBy != null) {
      data['added_by'] = this.addedBy!.toJson();
    }
    data['is_local'] = this.isLocal;
    data['primary_color'] = this.primaryColor;
    if (this.videoThumbnail != null) {
      data['video_thumbnail'] = this.videoThumbnail!.toJson();
    }
    return data;
  }
}

class Track {
  String? id;
  String? uri;
  String? href;
  String? name;
  String? type;
  Album? album;
  bool? track;
  List<Artists>? artists;
  bool? episode;
  bool? explicit;
  bool? isLocal;
  int? popularity;
  int? discNumber;
  int? durationMs;
  String? previewUrl;
  ExternalIds? externalIds;
  int? trackNumber;
  ExternalUrls? externalUrls;
  List<String>? availableMarkets;

  Track(
      {this.id,
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
      this.availableMarkets});

  Track.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uri = json['uri'];
    href = json['href'];
    name = json['name'];
    type = json['type'];
    album = json['album'] != null ? new Album.fromJson(json['album']) : null;
    track = json['track'];
    if (json['artists'] != null) {
      artists = <Artists>[];
      json['artists'].forEach((v) {
        artists!.add(new Artists.fromJson(v));
      });
    }
    episode = json['episode'];
    explicit = json['explicit'];
    isLocal = json['is_local'];
    popularity = json['popularity'];
    discNumber = json['disc_number'];
    durationMs = json['duration_ms'];
    previewUrl = json['preview_url'];
    externalIds = json['external_ids'] != null
        ? new ExternalIds.fromJson(json['external_ids'])
        : null;
    trackNumber = json['track_number'];
    externalUrls = json['external_urls'] != null
        ? new ExternalUrls.fromJson(json['external_urls'])
        : null;
    availableMarkets = json['available_markets'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uri'] = this.uri;
    data['href'] = this.href;
    data['name'] = this.name;
    data['type'] = this.type;
    if (this.album != null) {
      data['album'] = this.album!.toJson();
    }
    data['track'] = this.track;
    if (this.artists != null) {
      data['artists'] = this.artists!.map((v) => v.toJson()).toList();
    }
    data['episode'] = this.episode;
    data['explicit'] = this.explicit;
    data['is_local'] = this.isLocal;
    data['popularity'] = this.popularity;
    data['disc_number'] = this.discNumber;
    data['duration_ms'] = this.durationMs;
    data['preview_url'] = this.previewUrl;
    if (this.externalIds != null) {
      data['external_ids'] = this.externalIds!.toJson();
    }
    data['track_number'] = this.trackNumber;
    if (this.externalUrls != null) {
      data['external_urls'] = this.externalUrls!.toJson();
    }
    data['available_markets'] = this.availableMarkets;
    return data;
  }
}

class Album {
  String? id;
  String? uri;
  String? href;
  String? name;
  String? type;
  List<Images>? images;
  List<Artists>? artists;
  String? albumType;
  String? releaseDate;
  int? totalTracks;
  ExternalUrls? externalUrls;
  List<String>? availableMarkets;
  String? releaseDatePrecision;

  Album(
      {this.id,
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
      this.releaseDatePrecision});

  Album.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uri = json['uri'];
    href = json['href'];
    name = json['name'];
    type = json['type'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    if (json['artists'] != null) {
      artists = <Artists>[];
      json['artists'].forEach((v) {
        artists!.add(new Artists.fromJson(v));
      });
    }
    albumType = json['album_type'];
    releaseDate = json['release_date'];
    totalTracks = json['total_tracks'];
    externalUrls = json['external_urls'] != null
        ? new ExternalUrls.fromJson(json['external_urls'])
        : null;
    availableMarkets = json['available_markets'].cast<String>();
    releaseDatePrecision = json['release_date_precision'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uri'] = this.uri;
    data['href'] = this.href;
    data['name'] = this.name;
    data['type'] = this.type;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.artists != null) {
      data['artists'] = this.artists!.map((v) => v.toJson()).toList();
    }
    data['album_type'] = this.albumType;
    data['release_date'] = this.releaseDate;
    data['total_tracks'] = this.totalTracks;
    if (this.externalUrls != null) {
      data['external_urls'] = this.externalUrls!.toJson();
    }
    data['available_markets'] = this.availableMarkets;
    data['release_date_precision'] = this.releaseDatePrecision;
    return data;
  }
}

class Images {
  String? url;
  int? width;
  int? height;

  Images({this.url, this.width, this.height});

  Images.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}

class Artists {
  String? id;
  String? uri;
  String? href;
  String? name;
  String? type;
  ExternalUrls? externalUrls;

  Artists(
      {this.id, this.uri, this.href, this.name, this.type, this.externalUrls});

  Artists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uri = json['uri'];
    href = json['href'];
    name = json['name'];
    type = json['type'];
    externalUrls = json['external_urls'] != null
        ? new ExternalUrls.fromJson(json['external_urls'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uri'] = this.uri;
    data['href'] = this.href;
    data['name'] = this.name;
    data['type'] = this.type;
    if (this.externalUrls != null) {
      data['external_urls'] = this.externalUrls!.toJson();
    }
    return data;
  }
}

class ExternalIds {
  String? isrc;

  ExternalIds({this.isrc});

  ExternalIds.fromJson(Map<String, dynamic> json) {
    isrc = json['isrc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isrc'] = this.isrc;
    return data;
  }
}

class AddedBy {
  String? id;
  String? uri;
  String? href;
  String? type;
  ExternalUrls? externalUrls;

  AddedBy({this.id, this.uri, this.href, this.type, this.externalUrls});

  AddedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uri = json['uri'];
    href = json['href'];
    type = json['type'];
    externalUrls = json['external_urls'] != null
        ? new ExternalUrls.fromJson(json['external_urls'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uri'] = this.uri;
    data['href'] = this.href;
    data['type'] = this.type;
    if (this.externalUrls != null) {
      data['external_urls'] = this.externalUrls!.toJson();
    }
    return data;
  }
}

class VideoThumbnail {
  Null? url;

  VideoThumbnail({this.url});

  VideoThumbnail.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}
