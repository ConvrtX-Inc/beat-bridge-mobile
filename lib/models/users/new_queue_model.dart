class NewQueueModel {
  String? id;
  String? userId;
  String? name;
  String? platform;
  QueueData? queueData;
  String? image;
  String? createdDate;
  String? updatedDate;
  Null? deletedDate;
  String? sEntity;
  bool? isMember;
  bool? isAdmin;
  int? totalQueueTracks;
  User? user;
  var createdBy;

  NewQueueModel(
      {this.id,
      this.userId,
      this.name,
      this.createdBy,
      this.platform,
      this.queueData,
       this.image,
      this.createdDate,
      this.updatedDate,
      this.deletedDate,
      this.sEntity,
        this.isMember,
        this.isAdmin,
        this.totalQueueTracks,
      this.user});

  NewQueueModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by']??"";
    userId = json['user_id'];
    name = json['name'];
    platform = json['platform'];
    queueData = json['queueData'] != null
        ? new QueueData.fromJson(json['queueData'])
        : null;
    image = json['image'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    deletedDate = json['deleted_date'];
    sEntity = json['__entity'];

    isMember = json['is_member'];
    isAdmin = json['is_admin'];
    totalQueueTracks = json['total_queue_tracks'];

    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
      data['created_by']=createdBy  ;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['platform'] = this.platform;
    if (this.queueData != null) {
      data['queueData'] = this.queueData!.toJson();
    }
    //data['image'] = this.image;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    data['deleted_date'] = this.deletedDate;
    data['is_member'] = this.isMember;
    data['is_admin'] = this.isAdmin;
    data['total_queue_tracks'] = this.totalQueueTracks;
    data['__entity'] = this.sEntity;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class QueueData {
  String? id;
  String? uri;
  String? href;
  String? name;
  String? type;
  Owner? owner;
  List<Images>? images;
  bool? public;
  Tracks? tracks;
  String? description;
  String? snapshotId;
  bool? collaborative;
  ExternalUrls? externalUrls;
  Null? primaryColor;

  QueueData(
      {this.id,
      this.uri,
      this.href,
      this.name,
      this.type,
      this.owner,
      this.images,
      this.public,
      this.tracks,
      this.description,
      this.snapshotId,
      this.collaborative,
      this.externalUrls,
      this.primaryColor});

  QueueData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uri = json['uri'];
    href = json['href'];
    name = json['name'];
    type = json['type'];
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    public = json['public'];
    tracks =
        json['tracks'] != null ? new Tracks.fromJson(json['tracks']) : null;
    description = json['description'];
    snapshotId = json['snapshot_id'];
    collaborative = json['collaborative'];
    externalUrls = json['external_urls'] != null
        ? new ExternalUrls.fromJson(json['external_urls'])
        : null;
    primaryColor = json['primary_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uri'] = this.uri;
    data['href'] = this.href;
    data['name'] = this.name;
    data['type'] = this.type;
    if (this.owner != null) {
      data['owner'] = this.owner!.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    data['public'] = this.public;
    if (this.tracks != null) {
      data['tracks'] = this.tracks!.toJson();
    }
    data['description'] = this.description;
    data['snapshot_id'] = this.snapshotId;
    data['collaborative'] = this.collaborative;
    if (this.externalUrls != null) {
      data['external_urls'] = this.externalUrls!.toJson();
    }
    data['primary_color'] = this.primaryColor;
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

class Tracks {
  String? href;
  int? total;

  Tracks({this.href, this.total});

  Tracks.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    data['total'] = this.total;
    return data;
  }
}

class User {
  String? id;
  String? username;
  String? email;
  String? provider;
  String? phoneNo;
  String? stripeCustomerId;
  Null? avatarId;
  Null? socialId;
  String? latitude;
  String? longitude;
  String? createdDate;
  String? updatedDate;
  Null? deletedDate;
  String? sEntity;

  User(
      {this.id,
      this.username,
      this.email,
      this.provider,
      this.phoneNo,
      this.stripeCustomerId,
      this.avatarId,
      this.socialId,
      this.latitude,
      this.longitude,
      this.createdDate,
      this.updatedDate,
      this.deletedDate,
      this.sEntity});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    provider = json['provider'];
    phoneNo = json['phone_no'];
    stripeCustomerId = json['stripe_customer_id'];
    avatarId = json['avatar_id'];
    socialId = json['socialId'];
    latitude = json['latitude'] != null ? json['latitude'] : '0';
    longitude = json['longitude'] != null ? json['longitude'] : '0';
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    deletedDate = json['deleted_date'];
    sEntity = json['__entity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['provider'] = this.provider;
    data['phone_no'] = this.phoneNo;
    data['stripe_customer_id'] = this.stripeCustomerId;
    data['avatar_id'] = this.avatarId;
    data['socialId'] = this.socialId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    data['deleted_date'] = this.deletedDate;
    data['__entity'] = this.sEntity;
    return data;
  }
}
