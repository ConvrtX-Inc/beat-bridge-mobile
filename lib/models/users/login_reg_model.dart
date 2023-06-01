class UserValidResponse {
  String? token;
  User? user;

  UserValidResponse({this.token, this.user});

  UserValidResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? username;
  String? email;
  String? phoneNo;
  String? password;
  String? profileimage;

  String? stripeCustomerId;
  String? hash;
  Null? avatarId;
  Null? socialId;
  String? latitude;
  String? longitude;
  Null? deletedDate;
  String? id;
  String? provider;
  String? createdDate;
  String? updatedDate;
  

  User(
      {this.username,
      this.email,
      this.profileimage,

      this.phoneNo,
      this.password,
      this.stripeCustomerId,
      this.hash,
      this.avatarId,
      this.socialId,
      this.latitude,
      this.longitude,
      this.deletedDate,
      this.id,
      this.provider,
      this.createdDate,
      this.updatedDate});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    phoneNo = json['phone_no'];
    password = json['password'];
    password = json['profileimage'];

    stripeCustomerId = json['stripe_customer_id'];
    hash = json['hash'];
    avatarId = json['avatar_id'];
    socialId = json['socialId'];
    latitude = json['latitude'] != null ? json['latitude'] : '0';
    longitude = json['longitude'] != null ? json['longitude'] : '0';
    deletedDate = json['deleted_date'];
    id = json['id'];
    provider = json['provider'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['profielimage'] = this.profileimage;

    data['phone_no'] = this.phoneNo;
    data['password'] = this.password;
    data['stripe_customer_id'] = this.stripeCustomerId;
    data['hash'] = this.hash;
    data['avatar_id'] = this.avatarId;
    data['socialId'] = this.socialId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['deleted_date'] = this.deletedDate;
    data['id'] = this.id;
    data['provider'] = this.provider;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    return data;
  }
}
