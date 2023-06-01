// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:beatbridge/models/users/user_model.dart';

/// Model for user
// class QueueModel {
//   String? id;
//   String? userId;
//   String? name;
//   String? platform;
//   QueueData? queueData;
//   String? image;
//   String? createdDate;
//   String? updatedDate;
//   String? deletedDate;
//   String? sEntity;
//   UserModel? creator;

//   QueueModel(
//       {this.id,
//       this.userId,
//       this.name,
//       this.platform,
//       this.queueData,
//       this.image,
//       this.createdDate,
//       this.updatedDate,
//       this.deletedDate,
//       this.sEntity,
//       this.creator});

//   QueueModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     name = json['name'];
//     platform = json['platform'];
//     queueData = json['queueData'] != null
//         ?  QueueData.fromJson(json['queueData'])
//         : null;
//     image = json['image'];
//     createdDate = json['created_date'];
//     updatedDate = json['updated_date'];
//     deletedDate = json['deleted_date'];
//     sEntity = json['__entity'];
//     creator = UserModel.fromJson(json);

//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['user_id'] = userId;
//     data['name'] = name;
//     data['platform'] = platform;
//     if (queueData != null) {
//       data['queueData'] = queueData!.toJson();
//     }
//     data['image'] = image;
//     data['created_date'] = createdDate;
//     data['updated_date'] = updatedDate;
//     data['deleted_date'] = deletedDate;
//     data['__entity'] = sEntity;
//     return data;
//   }
// }

// class QueueData {
//   String? id;
//   String? uri;
//   String? href;
//   String? name;
//   String? type;
//   Owner? owner;
//   List<Images> ?images;
//   bool ?public;
//   Tracks? tracks;
//   String? description;
//   String ?snapshotId;
//   bool? collaborative;
//   ExternalUrls? externalUrls;
//   String? primaryColor;

//   QueueData(
//       {this.id,
//       this.uri,
//       this.href,
//       this.name,
//       this.type,
//       this.owner,
//       this.images,
//       this.public,
//       this.tracks,
//       this.description,
//       this.snapshotId,
//       this.collaborative,
//       this.externalUrls,
//       this.primaryColor,
//       });

//   QueueData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     uri = json['uri'];
//     href = json['href'];
//     name = json['name'];
//     type = json['type'];
//     owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
//     if (json['images'] != null) {
//       images = [];
//       json['images'].forEach((v) {
//         images!.add(Images.fromJson(v));
//       });
//     }
//     public = json['public'];
//     tracks =
//         json['tracks'] != null ? Tracks.fromJson(json['tracks']) : null;
//     description = json['description'];
//     snapshotId = json['snapshot_id'];
//     collaborative = json['collaborative'];
//     externalUrls = json['external_urls'] != null
//         ? ExternalUrls.fromJson(json['external_urls'])
//         : null;
//     primaryColor = json['primary_color'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['uri'] = uri;
//     data['href'] = href;
//     data['name'] = name;
//     data['type'] = type;
//     if (owner != null) {
//       data['owner'] = owner!.toJson();
//     }
//     if (images != null) {
//       data['images'] = images!.map((Images v) => v.toJson()).toList();
//     }
//     data['public'] = public;
//     if (tracks != null) {
//       data['tracks'] = tracks!.toJson();
//     }
//     data['description'] = description;
//     data['snapshot_id'] = snapshotId;
//     data['collaborative'] = collaborative;
//     if (externalUrls != null) {
//       data['external_urls'] = externalUrls!.toJson();
//     }
//     data['primary_color'] = primaryColor;
//     return data;
//   }
// }

// class Owner {
//   String? id;
//   String? uri;
//   String? href;
//   String? type;
//   String? displayName;
//   ExternalUrls? externalUrls;

//   Owner(
//       {this.id,
//       this.uri,
//       this.href,
//       this.type,
//       this.displayName,
//       this.externalUrls});

//   Owner.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     uri = json['uri'];
//     href = json['href'];
//     type = json['type'];
//     displayName = json['display_name'];
//     externalUrls = json['external_urls'] != null
//         ?  ExternalUrls.fromJson(json['external_urls'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
//     data['id'] = id;
//     data['uri'] = uri;
//     data['href'] = href;
//     data['type'] = type;
//     data['display_name'] = displayName;
//     if (externalUrls != null) {
//       data['external_urls'] = externalUrls!.toJson();
//     }
//     return data;
//   }
// }

// class ExternalUrls {
//   String? spotify;

//   ExternalUrls({this.spotify});

//   ExternalUrls.fromJson(Map<String, dynamic> json) {
//     spotify = json['spotify'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['spotify'] = spotify;
//     return data;
//   }
// }

// class Images {
//   String? url;
//   int? width;
//   int? height;

//   Images({this.url, this.width, this.height});

//   Images.fromJson(Map<String, dynamic> json) {
//     url = json['url'];
//     width = json['width'];
//     height = json['height'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['url'] = url;
//     data['width'] = width;
//     data['height'] = height;
//     return data;
//   }
// }

// class Tracks {
//   String? href;
//   int? total;

//   Tracks({this.href, this.total});

//   Tracks.fromJson(Map<String, dynamic> json) {
//     href = json['href'];
//     total = json['total'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['href'] = href;
//     data['total'] = total;
//     return data;
//   }
// }







class QueueModel {
  /// Constructor
  const QueueModel({
    this.id = '',
    this.userId = '',
    this.name = '',
    this.createdDate = '',
    this.updatedDate = '',
    this.deletedDate = '',
    this.entity = '',
    this.creator = const UserModelTwo(),
  });

  /// Initialization
  final String id, userId, name, createdDate, updatedDate, deletedDate, entity;

  ///creator details
  final UserModelTwo creator;

  /// A good thing.
  static QueueModel fromJson(Map<String, dynamic> json) {
    return QueueModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      createdDate: json['created_date'],
      updatedDate: json['updated_date'],
      deletedDate: json['deleted_date'] ?? '',
      entity: json['__entity'],
      creator: UserModelTwo.fromJson(json),
    );
  }
}

/// Model for user
class QueueCreator {
  /// Constructor
  const QueueCreator({
    this.id = '',
    this.username = '',
    this.email = '',
  });

  /// Initialization
  final String id, username, email;

  /// A good thing.
  static QueueCreator fromJson(Map<dynamic, dynamic> json) {
    print(json);
    return QueueCreator(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }
}
