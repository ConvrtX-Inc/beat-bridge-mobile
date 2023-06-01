// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:beatbridge/models/apis/response_to_user.dart';
import 'package:http/http.dart' as http;

/// Model for user
class UserModel {
  String? id;
  String? username;
  String? email;
  String? provider;
  String? phoneNo;
  String? stripeCustomerId;
  String? avatarId;
  String? image;
  String? socialId;
  String? latitude;
  String? longitude;
  String? createdDate;
  String? updatedDate;
  String? deletedDate;
  String? sEntity;

  UserModel(
      {this.id,
      this.username,
      this.email,
      this.provider,
      this.phoneNo,
      this.stripeCustomerId,
      this.avatarId,
      this.image,
      this.socialId,
      this.latitude,
      this.longitude,
      this.createdDate,
      this.updatedDate,
      this.deletedDate,
      this.sEntity});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    provider = json['provider'];
    phoneNo = json['phone_no'];
    stripeCustomerId = json['stripe_customer_id'];
    avatarId = json['avatar_id'];
    image = json['image'];
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
    data['username'] = this.username;
    data['email'] = this.email;
    data['provider'] = this.provider;
    data['phone_no'] = this.phoneNo;
    data['stripe_customer_id'] = this.stripeCustomerId;
    data['avatar_id'] = this.avatarId;
    data['image'] = this.image;
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

class UserModelTwo {
  /// Constructor
  const UserModelTwo(
      {this.token = '',
      this.id = '',
      this.username = '',
      this.email = '',
      this.provider = '',
      this.phoneNo = '',
      this.avatarId = '',
      this.image = '',
      this.hash = '',
      this.socialId = '',
      this.latitude = '',
      this.longitude = '',
      this.createdDate = '',
      this.updatedDate = '',
      this.password = '',
      this.phoneNumber = ''});

  /// Initialization
  final String token,
      id,
      username,
      email,
      provider,
      phoneNo,
      avatarId,
      image,
      hash,
      socialId,
      latitude,
      longitude,
      createdDate,
      password,
      phoneNumber,
      updatedDate;

  static UserModelTwo fromJson(Map<String, dynamic> json) {
    return UserModelTwo(
      token: json['token'] ?? '',
      id: json['user']['id'] ?? "",
      username: json['user']['username'] ?? "",
      email: json['user']['email'] ?? "",
      provider: json['user']['provider'] ?? "",
      phoneNo: json['user']['phone_no'] ?? "",
      avatarId:
          json['user']['avatar_id'] == null ? '' : json['user']['avatar_id'],
      image: json['user']['image'] == null ? '' : json['user']['image'],
      hash: json['user']['hash'] ?? '',
      socialId:
          json['user']['socialId'] == null ? '' : json['user']['socialId'],
      latitude:
          json['user']['latitude'] == null ? '' : json['user']['latitude'],
      longitude:
          json['user']['longitude'] == null ? '' : json['user']['longitude'],
      createdDate: json['user']['created_date'] ?? "",
      updatedDate: json['user']['updated_date'] ?? "",
      phoneNumber: json['user']['phone_no'] ?? "",
    );
  }

  /// return user object
  static Future<APIResponsedToUserObject> formatResponseToStandardFormat(
      http.Response response) async {
    /// List of all success codes
    final List<String> successCodes = <String>['200', '201'];
    if (successCodes.contains(response.statusCode.toString())) {
      final dynamic jsonData = jsonDecode(response.body);
      final UserModelTwo userObject = UserModelTwo.fromJson(jsonData);
      return APIResponsedToUserObject(
          statusCode: response.statusCode, status: 'success', user: userObject);
    } else {
      return APIResponsedToUserObject(
        statusCode: response.statusCode,
        errorResponse: response.body,
        status: 'error',
      );
    }
  }
}

class UserSingleton {
  static final UserSingleton _singleton = UserSingleton._internal();
  UserSingleton._internal();
  static UserSingleton get instance => _singleton;
  //late UserModelTwo user;
  late UserModelTwo user;
  var queueIndex = 0;
  var lat, long;
  var memberId = 0;
  var myaccessToken;
  var profileImage;
  var membersCount = 0;
  var queueName = "";
}
