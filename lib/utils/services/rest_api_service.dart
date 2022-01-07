/*
  We do call the rest API to get, store data on a remote database for that we need to write the rest API call at a
  single place and need to return the data if the rest call is a success or need to return custom error exception on
  the basis of 4xx, 5xx status code. We can make use of http package to make the rest API call in the flutter
 */
import 'dart:convert';
import 'dart:io';

import 'package:beatbridge/constants/api_path.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/utils/services/global_api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

/// App API services
class APIServices {
  /// is debugging
  final bool isDebugging = true;

  /// API base mode
  final String apiBaseMode = AppAPIPath.apiBaseMode;

  /// API base url
  final String apiBaseUrl = AppAPIPath.apiBaseUrl;

  ///Secure Storage
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  /// API service for register
  Future<APIStandardReturnFormat> register(UserModel userParams) async {
    final http.Response response = await http.post(
        Uri.parse('$apiBaseMode$apiBaseUrl/${AppAPIPath.registerUrl}'),
        body: {
          'username': userParams.username,
          'email': userParams.email,
          'phone_number': userParams.phoneNo
        });

    if (isDebugging) {
      GlobalAPIServices().debugging(
          'register',
          '$apiBaseMode$apiBaseUrl${AppAPIPath.registerUrl}',
          response.statusCode,
          response.body,
          userParams.phoneNo);
    }

    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  /// API service for login
  Future<APIStandardReturnFormat> login(
      String username, String password) async {
    final http.Response response = await http.post(
        Uri.parse('$apiBaseMode$apiBaseUrl/${AppAPIPath.loginUrl}'),
        body: {
          'username': username,
          'password': password,
          'latitude': '1.28210155945393',
          'longitude': '103.81722480263163'
        });
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  ///API service for User Connections / Friend list
  Future<APIStandardReturnFormat> getFriendList() async {
    final String? token = await secureStorage.read(key: 'token');
    final http.Response response = await http
        .get(Uri.http(apiBaseUrl, '/api/v1/user-connections'), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  ///API service for User Near You
  Future<APIStandardReturnFormat> findFriendsNearYou() async {
    final String? token = await secureStorage.read(key: 'token');
    final String latitude = UserSingleton.instance.user.latitude;
    final String longitude = UserSingleton.instance.user.longitude;

    debugPrint('latitude $latitude longitude $longitude');

    final http.Response response = await http.post(
        Uri.http(apiBaseUrl, '/api/v1/users/nearest-users'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: {
          'latitude': latitude,
          'longitude': longitude
        });

    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  ///API service for Add Friend
  Future<APIStandardReturnFormat> addFriend(String email) async {
    final String? token = await secureStorage.read(key: 'token');

    final http.Response response = await http.post(
        Uri.http(apiBaseUrl, '/api/v1/user-connections/send-friend-request'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: {
          'email': email,
        });

    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }
}
