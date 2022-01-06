///Model for Friend
class FriendModel {
  ///Constructor
  FriendModel(
      {this.id = '',
      this.fromUserId = '',
      this.toUserId = '',
      this.isAccepted = false,
      this.username = '',
      this.profileImage = '',
      this.createdDate = '',
      this.email = '',
      this.tracks = 0
      });

  ///Initialization for id
  String id;

  ///Initialization for fromUserId
  String fromUserId;

  ///Initialization for toUserId
  String toUserId;

  ///initialization for isAccepted
  bool isAccepted;

  ///initialization for username
  String username;

  ///initialization for profileImage
  String profileImage;

  ///initialization for created date
  String createdDate;

  ///initialization for email
  String email;

  ///initialization for tracks
  int tracks;

  ///Serialize data
  static FriendModel fromJson(Map<String, dynamic> json) => FriendModel(
      id: json['id'] ?? '',
      fromUserId: json['from_user_id'] ?? '',
      toUserId: json['to_user_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      isAccepted: json['is_accepted'],
      createdDate: json['created_date']);
}
