class AllUsers {
  String? id;
  String? username;
  String? email;
  String? provider;
  String? phoneNo;
  String? stripeCustomerId;
  Null? avatarId;
  var profileImage;
  Null? socialId;
  String? latitude;
  String? longitude;
  String? createdDate;
  String? updatedDate;
  Null? deletedDate;
  String? sEntity;
  int? trackCount;

  AllUsers(
      {this.id,
      this.username,
      this.email,
      this.provider,
      this.profileImage,
      this.phoneNo,
      this.stripeCustomerId,
      this.avatarId,
      this.socialId,
      this.latitude,
      this.longitude,
      this.createdDate,
      this.updatedDate,
      this.deletedDate,
      this.sEntity,
      this.trackCount});

  AllUsers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    profileImage = json['image'] ?? "";
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
    trackCount = json['track_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.profileImage;
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
    data['track_count'] = this.trackCount;
    return data;
  }
}
