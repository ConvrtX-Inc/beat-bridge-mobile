class FriendRequestModel {
  String? id;
  String? username;
  String? email;
  String? provider;
  String? phoneNo;
  String? stripeCustomerId;
  Null? avatarId;
  String? hash;
  Null? socialId;
  String? latitude;
  String? longitude;
  var totalTracks;
  String? image;
  String? createdDate;
  String? updatedDate;
  Null? deletedDate;
  String? sEntity;
  Connection? connection;

  FriendRequestModel(
      {this.id,
      this.username,
      this.email,
      this.provider,
      this.phoneNo,
      this.stripeCustomerId,
      this.avatarId,
      this.hash,
      this.socialId,
      this.latitude,
      this.longitude,
      this.image,
      this.createdDate,
      this.updatedDate,
      this.deletedDate,
      this.sEntity,
      this.totalTracks,
      this.connection});

  FriendRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    totalTracks = json['total_track'] ?? "0";
    provider = json['provider'];
    phoneNo = json['phone_no'];
    stripeCustomerId = json['stripe_customer_id'];
    avatarId = json['avatar_id'];
    hash = json['hash'];
    socialId = json['socialId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    image = json['image'] ?? "";
    //  != null ? new Image.fromJson(json['image']) : null;
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    deletedDate = json['deleted_date'];
    sEntity = json['__entity'];
    connection = json['connection'] != null
        ? new Connection.fromJson(json['connection'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['total_track'] = this.totalTracks;
    data['username'] = this.username;
    data['email'] = this.email;
    data['provider'] = this.provider;
    data['phone_no'] = this.phoneNo;
    data['stripe_customer_id'] = this.stripeCustomerId;
    data['avatar_id'] = this.avatarId;
    data['hash'] = this.hash;
    data['socialId'] = this.socialId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    if (this.image != null) {
      data['image'] = this.image!;
    }
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    data['deleted_date'] = this.deletedDate;
    data['__entity'] = this.sEntity;
    if (this.connection != null) {
      data['connection'] = this.connection!.toJson();
    }
    return data;
  }
}

class Image {
  String? type;
  List<int>? data;

  Image({this.type, this.data});

  Image.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['data'] = this.data;
    return data;
  }
}

class Connection {
  String? id;
  String? fromUserId;
  String? toUserId;
  bool? isAccepted;
  String? createdDate;
  String? updatedDate;
  Null? deletedDate;
  String? sEntity;

  Connection(
      {this.id,
      this.fromUserId,
      this.toUserId,
      this.isAccepted,
      this.createdDate,
      this.updatedDate,
      this.deletedDate,
      this.sEntity});

  Connection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromUserId = json['from_user_id'];
    toUserId = json['to_user_id'];
    isAccepted = json['is_accepted'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    deletedDate = json['deleted_date'];
    sEntity = json['__entity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['from_user_id'] = this.fromUserId;
    data['to_user_id'] = this.toUserId;
    data['is_accepted'] = this.isAccepted;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    data['deleted_date'] = this.deletedDate;
    data['__entity'] = this.sEntity;
    return data;
  }
}
