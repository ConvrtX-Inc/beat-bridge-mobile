/*
  We do call the rest API to get, store data on a remote database for that we need to write the rest API call at a
  single place and need to return the data if the rest call is a success or need to return custom error exception on
  the basis of 4xx, 5xx status code. We can make use of http package to make the rest API call in the flutter
 */
import 'dart:io';

import 'package:beatbridge/constants/api_path.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/apis/response_to_user.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/utils/services/global_api_service.dart';
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

  /// API base url
  final String spotifyApiBaseUrl = AppAPIPath.spotifyApiBaseUrl;

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

  /// API service for user Queues
  Future<APIStandardReturnFormat> getUserQueues() async {
    final http.Response response =
        await http.get(Uri.http(apiBaseUrl, AppAPIPath.userQueues), headers: {
      HttpHeaders.authorizationHeader:
          'Bearer ${UserSingleton.instance.user.token}',
    });
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  /// API service for Queue Members
  Future<APIStandardReturnFormat> getQueueMember(String queueId) async {
    final http.Response response = await http.get(
        Uri.http(apiBaseUrl, '${AppAPIPath.queueMembers}$queueId'),
        headers: {
          HttpHeaders.authorizationHeader:
              'Bearer ${UserSingleton.instance.user.token}',
        });
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  /// API service for User Details
  Future<APIResponsedToUserObject> getUserDetailsById(String id) async {
    final http.Response response = await http
        .get(Uri.http(apiBaseUrl, '${AppAPIPath.userDetails}$id'), headers: {
      HttpHeaders.authorizationHeader:
          'Bearer ${UserSingleton.instance.user.token}',
    });
    return UserModel.formatResponseToStandardFormat(response);
  }

  /// API service for User playlist in spotify
  Future<APIStandardReturnFormat> getUserPlayList() async {
    print(spotifyApiBaseUrl + AppAPIPath.userPlayList);
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'spotifyAuthToken');
    final http.Response response = await http
        .get(Uri.http(spotifyApiBaseUrl, AppAPIPath.userPlayList), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    print(response.body);
    print(response.headers);
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  Future<APIStandardReturnFormat> fetchAlbum() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'spotifyAuthToken');
    final response = await http.get(
        Uri.parse('$apiBaseMode$spotifyApiBaseUrl/${AppAPIPath.userPlayList}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return GlobalAPIServices().formatResponseToStandardFormat(response);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
