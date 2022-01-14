import 'dart:convert';

import 'package:beatbridge/models/apis/response_to_user.dart';
import 'package:http/http.dart' as http;

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
    this.password = '',
    this.phoneNumber = ''
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
      password,
      phoneNumber,
      updatedDate;

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] ?? '',
      id: json['user']['id'],
      username: json['user']['username'],
      email: json['user']['email'],
      provider: json['user']['provider'],
      phoneNo: json['user']['phone_no'],
      avatarId:
          json['user']['avatar_id'] == null ? '' : json['user']['avatar_id'],
      hash: json['user']['hash'] ?? '',
      socialId:
          json['user']['socialId'] == null ? '' : json['user']['socialId'],
      latitude: json['user']['latitude'],
      longitude: json['user']['longitude'],
      createdDate: json['user']['created_date'],
      updatedDate: json['user']['updated_date'],
    );
  }

  /// return user object
  static Future<APIResponsedToUserObject> formatResponseToStandardFormat(
      http.Response response) async {
    /// List of all success codes
    final List<String> successCodes = <String>['200', '201'];
    if (successCodes.contains(response.statusCode.toString())) {
      final dynamic jsonData = jsonDecode(response.body);
      final UserModel userObject = UserModel.fromJson(jsonData);
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
  static final UserSingleton _singleton = new UserSingleton._internal();
  UserSingleton._internal();
  static UserSingleton get instance => _singleton;
  late UserModel user;
}
