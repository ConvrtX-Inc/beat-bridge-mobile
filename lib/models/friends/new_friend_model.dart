class NewFriendModel {
  String? id;
  var memberId;
  String? fromUserId;
  bool? isAdmin = false;
  bool? isSelected;
  String? toUserId;
  bool? isAccepted;
  String? createdDate;
  String? updatedDate;
  String? deletedDate;
  String? sEntity;
  ToUser? toUser;
  ToUser? fromUser;

  NewFriendModel(
      {this.id,
      this.isSelected,
      this.fromUserId,
      this.toUserId,
      this.isAccepted,
      this.memberId,
      this.createdDate,
      this.isAdmin,
      this.updatedDate,
      this.deletedDate,
      this.sEntity,
      this.toUser,
      this.fromUser});

  NewFriendModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isSelected = json['selected'] ?? false;
    memberId = json['memb'] ?? 0;
    isAdmin = json['admin'] ?? false;
    fromUserId = json['from_user_id'];
    toUserId = json['to_user_id'];
    isAccepted = json['is_accepted'] ?? false;
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    deletedDate = json['deleted_date'];
    sEntity = json['__entity'];
    toUser =
        json['to_user'] != null ? new ToUser.fromJson(json['to_user']) : null;
    fromUser = json['from_user'] != null
        ? new ToUser.fromJson(json['from_user'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['admin'] = isAdmin;
    data['memb'] = memberId;
    data['selected'] = this.isSelected;
    data['from_user_id'] = this.fromUserId;
    data['to_user_id'] = this.toUserId;
    data['is_accepted'] = this.isAccepted;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    data['deleted_date'] = this.deletedDate;
    data['__entity'] = this.sEntity;
    if (this.toUser != null) {
      data['to_user'] = this.toUser!.toJson();
    }
    if (this.fromUser != null) {
      data['from_user'] = this.fromUser!.toJson();
    }
    return data;
  }
}

class ToUser {
  String? id;
  String? username;
  String? email;
  String? provider;
  String? phoneNo;
  String? stripeCustomerId;
  String? avatarId;
  var image;
  String? socialId;
  String? latitude;
  String? longitude;
  String? createdDate;
  String? updatedDate;
  String? deletedDate;
  String? sEntity;

  ToUser(
      {this.id,
      this.username,
      this.email,
      this.provider,
      this.image,
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

  ToUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    image = json['image'] ?? "";
    email = json['email'];
    provider = json['provider'];
    phoneNo = json['phone_no'];
    stripeCustomerId = json['stripe_customer_id'];
    avatarId = json['avatar_id'];
    socialId = json['socialId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    deletedDate = json['deleted_date'];
    sEntity = json['__entity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
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
