/// Model for user
class UserModel {
  /// Constructor
  const UserModel({
    this.token = '',
    this.id = '',
    this.username = '',
    this.email = '',
    this.provider = '',
    this.phoneNo = '',
    this.avatarId = '',
    this.hash = '',
    this.socialId = '',
    this.latitude = '',
    this.longitude = '',
    this.createdDate = '',
    this.updatedDate = '',
  });

  /// Initialization
  final String token,
      id,
      username,
      email,
      provider,
      phoneNo,
      avatarId,
      hash,
      socialId,
      latitude,
      longitude,
      createdDate,
      updatedDate;

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        token: json['token'],
        id: json['user']['id'],
        username: json['user']['username'],
        email: json['user']['email'],
        provider: json['user']['provider'],
        phoneNo: json['user']['phone_no'],
        avatarId: json['user']['avatar_id'] ?? '',
        hash: json['user']['hash'],
        socialId: json['user']['socialId'] ?? '',
        latitude: json['user']['latitude'],
        longitude: json['user']['longitude'],
        createdDate: json['user']['created_date'],
        updatedDate: json['user']['updated_date'],
      );
}

class UserSingleton {
  static final UserSingleton _singleton = new UserSingleton._internal();
  UserSingleton._internal();
  static UserSingleton get instance => _singleton;
  late UserModel user;
}
