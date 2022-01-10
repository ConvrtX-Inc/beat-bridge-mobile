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
import 'package:http/http.dart' as http;

/// App API services
class APIServices {
  /// is debugging
  final bool isDebugging = true;

  /// API base mode
  final String apiBaseMode = AppAPIPath.apiBaseMode;

  /// API base url
  final String apiBaseUrl = AppAPIPath.apiBaseUrl;

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
    print(response.body);
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
}
