///Model for Near You
class NearYouModel {
  ///Constructor
  NearYouModel(
      {this.id = '',
        this.hasAccepted = false,
        this.username = '',
        this.profileImage = '',
        this.email = '',
        this.phoneNo = '',
        this.latitude = '',
        this.longitude = '',
        this.totalTracks = 0
      });

  ///Initialization for id
  String id;

  ///initialization for hasAccepted
  bool hasAccepted;

  ///initialization for username
  String username;

  ///initialization for profileImage
  String profileImage;

  ///initialization for email
  String email;

  ///initialization for phone no
  String phoneNo;

  ///initialization for latitude
  String latitude;

  ///initialization for longitude
  String longitude;

  ///Initialization for total tracks
  int totalTracks ;

  ///Serialize data
  static NearYouModel fromJson(Map<String, dynamic> json) => NearYouModel(
      username: json['username'] ,
      email: json['email'],
      phoneNo : json['phone_no'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      hasAccepted: json['has_accepted']);
}
