// ignore_for_file: always_specify_types

/*
  We do call the rest API to get, store data on a remote database for that we need to write the rest API call at a
  single place and need to return the data if the rest call is a success or need to return custom error exception on
  the basis of 4xx, 5xx status code. We can make use of http package to make the rest API call in the flutter
 */

import 'dart:convert';
import 'dart:developer';

import 'dart:io';

import 'package:beatbridge/constants/api_path.dart';
import 'package:beatbridge/helpers/basehelper.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/apis/response_to_user.dart';
import 'package:beatbridge/models/queuecountNotifier.dart';
import 'package:beatbridge/models/users/new_queue_model.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/utils/logout_helper.dart';
import 'package:beatbridge/utils/logout_helper.dart';
import 'package:beatbridge/utils/logout_helper.dart';
import 'package:beatbridge/utils/services/global_api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';
import '../../models/users/user_track_model.dart';
import '../../screens/main_navigations/queues/screens/recent_queue.dart';
import '../logout_helper.dart';

/// App API services
class APIServices {
  /// is debugging
  final bool isDebugging = true;
  var baseurl = "https://api.beatbridge.app";
  // "https://beat.softwarealliancetest.tk";

  /// API base mode
  final String apiBaseMode = AppAPIPath.apiBaseMode;

  /// API base url
  final String apiBaseUrl = AppAPIPath.apiBaseUrl;

  /// API base url
  final String spotifyApiBaseUrl = AppAPIPath.spotifyApiBaseUrl;

  ///Secure Storage
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
//delete queue member
  Future<APIStandardReturnFormat> deleteQueueMember(String memberId) async {
    print("the mmeber id s: $memberId");
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    print("auth token: $userAuthToken");
    //final String? userID = await secureStorage.read(key: 'userID');
    final String? queueID = await secureStorage.read(key: 'tempQueueID');
    var url = "${BaseHelper().baseUrl}/${AppAPIPath.addQueueMembers}/$memberId";
    print("the url or remove member is: $url");
    log(queueID.toString());

    final http.Response response = await http.delete(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
        'content-type': 'application/json'
      },
    );

    print("remove member: ${response.body}");
    print("remove member status code: ${response.statusCode}");
    // var jsons = json.decode(response.body);
    // print("remove member   response is: ${jsons}");
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  /// API service to Add Queue Members
  Future<APIStandardReturnFormat> addQueueMember(
      var qid, bool is_admin, String userId) async {
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    print("auth token: $userAuthToken");
    //final String? userID = await secureStorage.read(key: 'userID');
    final String? queueID = await secureStorage.read(key: 'tempQueueID');

    log(queueID.toString());
    log(userId.toString());

    var _body = <String, dynamic>{
      'user_queue_id': queueID,
      'user_id': userId,
      'is_admin': is_admin
    };
    print("make admin body: $_body");
    var body = json.encode(_body);

    final http.Response response =
        await http.post(Uri.https(apiBaseUrl, AppAPIPath.addQueueMembers),
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
              'content-type': 'application/json'
            },
            body: body);

    print("making admin: ${response.body}");
    var jsons = json.decode(response.body);
    print("adding member response is: ${jsons}");
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  Future<APIStandardReturnFormat> updateAdmin(
      var qid, bool is_admin, otherId) async {
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    final String? userID = await secureStorage.read(key: 'userID');

    var _body = json.encode(
        {'user_queue_id': qid, 'user_id': userID, 'is_admin': is_admin});
    print("make admin body: $_body");
    var body = _body;
    var url = "${BaseHelper().baseUrl}/${AppAPIPath.addQueueMembers}/$otherId";
    print("url of making admin: $url");
    final http.Response response = await http.patch(
      Uri.parse(url),
      body: body,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
        'content-type': 'application/json'
      },
    );

    print("making admin: ${response.body}");
    var jsons = json.decode(response.body);
    print("adding member update response issssss: ${jsons}");
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  Future<APIStandardReturnFormat> makeAdmin(
      var qid, bool is_admin, String userId, otherId) async {
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    final String? userID = await secureStorage.read(key: 'userID');
    final String? queueID = await secureStorage.read(key: 'tempQueueID');

    log(queueID.toString());
    log(userId.toString());

    var _body = <String, dynamic>{
      'user_queue_id': "$queueID",
      'user_id': "$userID",
      'is_admin': "$is_admin"
    };
    print("make admin body: $_body");
    var body = _body;
    var url = "${BaseHelper().baseUrl}/${AppAPIPath.addQueueMembers}/$otherId";
    print("url of making admin: $url");
    final http.Response response = await http.patch(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',

        // 'content-type': 'application/json'
      },
      body: body,
    );

    print("making admin: ${response.body}");
    var jsons = json.decode(response.body);
    print("adding member response issssss: ${jsons}");
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  /// API service to leave Queue

  /// API service to join Queue
  Future<APIStandardReturnFormat> joinQueueMember(
      String qid, String uid) async {
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    final String? userID = await secureStorage.read(key: 'userID');

    var _body = <String, dynamic>{
      'user_queue_id': qid,
      'user_id': userID,
      'is_admin': false
    };
    var body = json.encode(_body);

    final http.Response response =
        await http.post(Uri.https(apiBaseUrl, AppAPIPath.addQueueMembers),
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
              'content-type': 'application/json'
            },
            body: body);
    print(body);
    print('response from: ${response.body}');
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  _asyncMethod() async {
    log("initState Called");
    final String? userAuthToken = await storage.read(key: 'userAuthToken');
    final String? spotifyAuthToken =
        await storage.read(key: 'spotifyAuthToken');
    var userid = await storage.read(key: 'userID');
  }

  /// API service to Add Friend
  Future<APIStandardReturnFormat> addFriends(String id) async {
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    final http.Response response =
        await http.post(Uri.https(apiBaseUrl, AppAPIPath.addFriend), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
    }, body: {
      'id': id,
    });
    print(response.body);
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  //patch api

  /// API service for register
  Future<APIStandardReturnFormat> register(UserModelTwo userParams) async {
    final http.Response response = await http.post(
        Uri.parse('$apiBaseMode$apiBaseUrl/${AppAPIPath.registerUrl}'),
        body: {
          'username': userParams.username,
          'image': '${userParams.image}',
          'email': userParams.email,
          'phone_no': userParams.phoneNumber,
          'password': userParams.password,
        });
    var jsons = json.decode(response.body);
    print("register response: $jsons");

    if (isDebugging) {
      GlobalAPIServices().debugging(
          'register',
          '$apiBaseMode$apiBaseUrl${AppAPIPath.registerUrl}',
          response.statusCode,
          response.body,
          userParams.phoneNumber);
    }

    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  /// API service track data
  Future<APIStandardReturnFormat> userTrackData(
      UserTrackModel userTrackModel) async {
    print('inside track post');
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');

    Map<String, dynamic> trackData = {
      'id': userTrackModel.id,
      'name': userTrackModel.name,
      'user_id': userTrackModel.userId,
      'queueId': userTrackModel.queueId,
      'totalPlayCount': userTrackModel.totalPlayCount,
      'uri': userTrackModel.uri,
      'platform': 'Spotify',
      'trackData': userTrackModel.trackdata,
      'owner': userTrackModel.owner,
      'createdDate': userTrackModel.createdDate,
      'updatedDate': userTrackModel.updatedDate,
      'deletedDate': userTrackModel.deletedDate,
      'sEntity': "userTrackModel.sEntity",
    };

    var body = json.encode(trackData);
    log(body);

    final http.Response response =
        await http.post(Uri.parse('${BaseHelper().baseUrl}/api/track'),
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
              'content-type': 'application/json'
            },
            body: body);

    print('object queueId : ${userTrackModel.queueId}');
    print('object userId: ${userTrackModel.userId}');
    print("Add music response: ${response.body}");

    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  /// API service for login with email
  Future<APIStandardReturnFormat> loginWithEmail(
      String email, String password, lattitude, longitude) async {
    var body = {
      'email': email,
      'password': password,
      'latitude': '$lattitude',
      'longitude': '$longitude'
    };
    print("login body: $body");
    print(
        "my login url is: ${Uri.parse('$apiBaseMode$apiBaseUrl/${AppAPIPath.loginUrlEmail}')}");
    final http.Response response = await http.post(
        Uri.parse('$apiBaseMode$apiBaseUrl/${AppAPIPath.loginUrlEmail}'),
        body: body);
    var jsons = json.decode(response.body);
    print("login response: $jsons");
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  /// API service for login with phone
  Future<APIStandardReturnFormat> loginWithPhone(
      String phoneNumber, String password, lattitude, longitude) async {
    final http.Response response = await http.post(
        Uri.parse('$apiBaseMode$apiBaseUrl/${AppAPIPath.loginUrlPhone}'),
        body: {
          'phone_no': phoneNumber,
          'password': password,
          'latitude': '$lattitude',
          'longitude': '$longitude'
        });

    log(response.body);
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  /// API service for finding nearest user
  // Future<APIStandardReturnFormat> nearestUser(String username,
  //     String email, String phoneNumber) async {
  //   final http.Response response = await http.post(
  //       Uri.parse('$apiBaseMode$apiBaseUrl/${AppAPIPath.nearestUserApiUrl}'),
  //       body: {
  //         'username': username,
  //         'email': email,
  //         'password': phoneNumber,
  //         'latitude': '1.28210155945393',
  //         'longitude': '103.81722480263163'
  //       });
  //   return GlobalAPIServices().formatResponseToStandardFormat(response);
  // }

  Future<APIStandardReturnFormat> addQueue(
    var body,
  ) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? userAuthToken = await storage.read(key: 'userAuthToken');

    final http.Response response =
        await http.post(Uri.https(apiBaseUrl, AppAPIPath.userQueues),
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
              'content-type': 'application/json'
            },
            body: body);
    print("success step one response: ${response.body}");
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  Future<APIStandardReturnFormat> userQueueAdd(
    String token,
    var body,
  ) async {
    final http.Response response =
        await http.post(Uri.http(apiBaseUrl, AppAPIPath.addUserQueues),
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $token',
              'content-type': 'application/json'
            },
            body: body);
    print("spotify add response: ${response.body}");
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  /// API service for update user Queues Image
  Future<APIStandardReturnFormat> updateUserQueueImage(
      String qid, var img) async {
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    final http.Response response = await http
        .patch(Uri.https(apiBaseUrl, '/api/v1/user-queues/image'), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
    }, body: {
      'id': qid,
      'image': img.toString()
    });
    log('updateUserQueueImage');
    print(response.body);
    var jsons = json.decode(response.body);
    print("adding queue: $jsons");
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

//recent queue
  Future<dynamic> recentQueue({String? userIdd}) async {
    //1. Add id param, default value = null
    //2, if id value is set URI will be AppAPIPath.userQueues/data/id
    //3. if id is null URI will be AppAPIPath.userQueues

    //Todo: issue if we increase limit
    var userId;
    if (userIdd.toString() == "0") {
      userId = await storage.read(key: 'userID');
    } else {
      userId = null;
    }
    print("my user id is: $userId");
    final Map<String, String> _queryParameters = <String, String>{
      'limit': '',
    };
    print("queue parameters: ${_queryParameters}");

    var uriPath = userId != null
        ? Uri.https(apiBaseUrl, '${AppAPIPath.userQueues}/data/$userId')
        :
        //  Uri.parse(
        //     'https://beat.softwarealliancetest.tk/api/v1/user-queues?limit=5');
        Uri.https(
            apiBaseUrl,
            AppAPIPath.userQueues,
          );
    if (userId != null) {
      print('if is : $uriPath');

      uriPath = Uri.https(apiBaseUrl, '${AppAPIPath.userQueues}/data/$userId');
    } else {
      print('else is : $uriPath');

      //uriPath = Uri.https(apiBaseUrl, '${AppAPIPath.userQueues}?limit=5');
      uriPath = Uri.parse('${BaseHelper().baseUrl}/api/v1/user-queues?');
    }

    print('else is : $uriPath');

    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    print("auth token: $userAuthToken");

    final http.Response response = await http.get(uriPath, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
    });
    print("my queue response: ${response.body}");
    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      print("jsons data from api is: ${jsonData}");
      final List<NewQueueModel> userQueues = <NewQueueModel>[];
      final qs =
          (jsonData as List).map((i) => NewQueueModel.fromJson(i)).toList();
      userQueues.addAll(qs);
      return userQueues;
    } else {
      return null;
    }

    log('**********');
    // print(response.body);
    // return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  /// API service for user Queues
  Future<APIStandardReturnFormat> getUserQueues({String? userIdd}) async {
    //1. Add id param, default value = null
    //2, if id value is set URI will be AppAPIPath.userQueues/data/id
    //3. if id is null URI will be AppAPIPath.userQueues

    //Todo: issue if we increase limit
    var userId;
    if (userIdd.toString() == "0") {
      userId = await storage.read(key: 'userID');
    } else {
      userId = null;
    }
    print("my user id is: $userId");
    final Map<String, String> _queryParameters = <String, String>{
      'limit': '10',
    };
    print("queue parameters: ${_queryParameters}");

    var uriPath = userId != null
        ? Uri.https(apiBaseUrl, '${AppAPIPath.userQueues}/data/$userId')
        :
        //  Uri.parse(
        //     'https://beat.softwarealliancetest.tk/api/v1/user-queues?limit=5');
        Uri.https(
            apiBaseUrl,
            AppAPIPath.userQueues,
          );
    if (userId != null) {
      print('if is : $uriPath');

      uriPath = Uri.https(apiBaseUrl, '${AppAPIPath.userQueues}/data/$userId');
    } else {
      // print('else is : $uriPath');

      //uriPath = Uri.https(apiBaseUrl, '${AppAPIPath.userQueues}?limit=5');
      uriPath = Uri.https(apiBaseUrl, '/api/v1/user-queues/nearby');
      // Uri.parse(
      //     'https://beat.softwarealliancetest.tk/api/v1/user-queues/nearby');
      // Uri.parse('https://beat.softwarealliancetest.tk/api/v1/user-queues?');
    }

    print('else is : $uriPath');

    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    print("auth token: $userAuthToken");
    var body = {
      "latitude": "${UserSingleton.instance.lat}",
      "longitude": "${UserSingleton.instance.long}"
    };
    print("our lat long body of near by queues: $body");
    final http.Response response = userId != null
        ? await http.get(uriPath, headers: {
            HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
          })
        : await http.post(uriPath, body: body, headers: {
            HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
          });
    print("my queue response: ${response.body}");

    log('**********');
    // print(response.body);
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  /// API service for All Support List
  Future<APIStandardReturnFormat> getSupportList() async {
    log('getSupportList');
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'userAuthToken');
    final http.Response response = await http.get(
        Uri.https(apiBaseUrl, 'api/v1/master-support'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer ${token}'});
    print("my support list response: ${response.body}");
    log(response.body);
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  /// API service for All Support List
  Future<APIStandardReturnFormat> saveSupport(String subj, String desc) async {
    log('saveSupport');

    final String? token = await secureStorage.read(key: 'userAuthToken');
    final String? userID = await secureStorage.read(key: 'userID');
    final http.Response response = await http
        .post(Uri.https(apiBaseUrl, '/api/v1/master-support'), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    }, body: {
      'user_id': userID,
      'admin_id': '',
      'subject': subj,
      'description': desc,
    });
    print("saving my ticket response: ${response.body}");

    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  /// API service for Queue Members
  Future<APIStandardReturnFormat> getAllUsers() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'userAuthToken');
    final http.Response response = await http.get(
        Uri.https(apiBaseUrl, AppAPIPath.usersAll),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    log(response.body);
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  Future<dynamic> getQueueMemberCount(String queueId) async {
    UserSingleton.instance.membersCount = 0;
    QueueNotifier().membersCounts.value = 0;
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    print("my queue id: $queueId");
    final http.Response response = await http.get(
        Uri.https(apiBaseUrl, '${AppAPIPath.queueMembers}$queueId'),
        //Uri.http(apiBaseUrl, '${AppAPIPath.queueMembers}fa6f6995-4980-4111-8030-5843fa2f1b9f'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
        });
    print('objectobjectobject ${response.body}');
    var jsons = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsons.length;
    } else {
      return 0;
    }
  }

  /// API service for Queue Members
  Future<APIStandardReturnFormat> getQueueMember(String queueId) async {
    UserSingleton.instance.membersCount = 0;
    QueueNotifier().membersCounts.value = 0;
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    print("tokenn: $userAuthToken");
    print("my queue id: $queueId");
    final http.Response response = await http.get(
        Uri.https(apiBaseUrl, '${AppAPIPath.queueMembers}$queueId'),
        //Uri.http(apiBaseUrl, '${AppAPIPath.queueMembers}fa6f6995-4980-4111-8030-5843fa2f1b9f'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
        });
    print('objectobjectobject ${response.body}');
    var jsons = json.decode(response.body);
    // UserSingleton.instance.membersCount = jsons.length;
    // QueueNotifier().membersCounts.value = jsons.length;
    QueueNotifier().setMembersCount(jsons.length);
    UserSingleton.instance.membersCount = jsons.length;
    // print("members count: ${UserSingleton.instance.membersCount}");
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  /// API service for Queue List Songs
  Future<APIStandardReturnFormat> getQueueListSong(String queueId) async {
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    final http.Response response = await http.get(
        Uri.https(apiBaseUrl, '${AppAPIPath.queueSongs}$queueId'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
        });
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  /// API service for Queue List Songs
  Future<APIStandardReturnFormat> getAllUserTrackAgainstUserId() async {
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    final String? userID = await secureStorage.read(key: 'userID');
    log('${BaseHelper().baseUrl}/api/track/user/$userID');
    final http.Response response = await http.get(
        Uri.parse('${BaseHelper().baseUrl}/api/track/user/$userID'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
        });
    print('object object object ${response.body}');
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  /// API service for Queue Members
  Future<APIStandardReturnFormat> getQueueListAllSong(String queueId) async {
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    final http.Response response = await http.get(
        Uri.parse('${BaseHelper().baseUrl}/api/v1/user-queues/data/$queueId'),
        //Uri.http(apiBaseUrl, '${AppAPIPath.queueMembers}fa6f6995-4980-4111-8030-5843fa2f1b9f'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
        });
    print('objectobjectobject ${response.body}');
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  /// API service for User Details
  Future<APIResponsedToUserObject> getUserDetailsById(String id) async {
    final http.Response response = await http
        .get(Uri.https(apiBaseUrl, '${AppAPIPath.userDetails}$id'), headers: {
      HttpHeaders.authorizationHeader:
          'Bearer ${UserSingleton.instance.user.token}',
    });
    return UserModelTwo.formatResponseToStandardFormat(response);
  }

  Future<dynamic> removeFriend(String id) async {
    final String? token = await secureStorage.read(key: 'userAuthToken');

    print("base url: $apiBaseUrl");
    var url = "$baseurl${AppAPIPath.removeFriend}$id";
    print("my url is: $url");
    final http.Response response = await http.delete(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${token}',
      },
    );
    print("remove friend response: ${response.body}");

    return response;
    // UserModelTwo.formatResponseToStandardFormat(response);
  }

  /// API service for User playlist in spotify
  Future<APIStandardReturnFormat> getUserPlayList() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'spotifyAuthToken');
    log('$spotifyApiBaseUrl/${AppAPIPath.userPlayList}');
    final http.Response response = await http.get(
        Uri.parse('$spotifyApiBaseUrl/${AppAPIPath.userPlayList}'),
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

  /// API service for User playlist tracks in spotify
  Future<APIStandardReturnFormat> getTracksInPlayList(String playListId) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'spotifyAuthToken');
    final http.Response response = await http.get(
        Uri.parse('$spotifyApiBaseUrl/playlists/$playListId/tracks'),
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

  ///API service for User Connections / Friend list
  Future<APIStandardReturnFormat> getFriendList() async {
    final String? token = await secureStorage.read(key: 'userAuthToken');
    final String? id = await secureStorage.read(key: 'userID');
    //final http.Response response = await http.get(Uri.http(apiBaseUrl, '/api/v1/user-connections'), headers: {
    final http.Response response = await http.get(
        Uri.https(apiBaseUrl, '/api/v1/user-connections/friends/$id'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    log('getFriendList');
    log(response.body);
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  ///API service for User Near You
  Future<APIStandardReturnFormat> findFriendsNearYou() async {
    // Todo: Get Lat/Lng from sharedpref
    final String latitude = '0';
    final String longitude = '0';
    print("find friends body: $longitude");
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    var long = position.longitude.toString();
    var lat = position.latitude.toString();
    print("lattitude: ${lat}: longitude: $long");
    final String? token = await secureStorage.read(key: 'userAuthToken');

    debugPrint('latitude $lat longitude $long');
    var body = {'latitude': lat, 'longitude': long};
    print("find friends body: $body");
    final http.Response response =
        await http.post(Uri.https(apiBaseUrl, '/api/v1/users/nearest-users'),
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $token',
            },
            body: body);
    print("friends response: ${response.body}");
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  ///API service for Accept Friend Request
  Future<APIStandardReturnFormat> confirmFriend(String id) async {
    final String? token = await secureStorage.read(key: 'userAuthToken');

    final http.Response response = await http.post(
        Uri.https(apiBaseUrl, '/api/v1/user-connections/confirm'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: {
          'id': id,
        });

    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  ///API service for Decline Friend Request
  Future<APIStandardReturnFormat> declineFriend(String id) async {
    final String? token = await secureStorage.read(key: 'userAuthToken');

    final http.Response response = await http.delete(
        Uri.https(apiBaseUrl, '/api/v1/user-connections/remove-friend/$id'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: {
          'id': id,
        });

    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  ///API service for Add Friend
  Future<APIStandardReturnFormat> addFriend(String email) async {
    // final String? token = await secureStorage.read(key: 'token');
    final String? token = await secureStorage.read(key: 'userAuthToken');
    final http.Response response = await http.post(
        Uri.https(apiBaseUrl, '/api/v1/user-connections/send-friend-request'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: {
          'email': email,
        });

    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  ///API service for User Connections / Friend Request list
  Future<APIStandardReturnFormat> getFriendRequest() async {
    final String? token = await secureStorage.read(key: 'userAuthToken');
    final String? id = await secureStorage.read(key: 'userID');
    //final http.Response response = await http.get(Uri.http(apiBaseUrl, '/api/v1/user-connections'), headers: {
    log(id!);
    final http.Response response = await http.get(
        Uri.https(apiBaseUrl, '/api/v1/user-connections/friends/received/$id'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    print("my friend request: ${response.body}");
    log('getFriendList');
    // log(response.body);
    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  ///API service for Payment
  Future<APIStandardReturnFormat> pay(
      int amount, String paymentMethodID) async {
    // final String? token = await secureStorage.read(key: 'token');
    final String token = UserSingleton.instance.user.token;
    final http.Response response = await http.post(
        Uri.parse('$apiBaseMode$apiBaseUrl/${AppAPIPath.paymentApiUrl}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'content-type': 'application/json'
        },
        body: jsonEncode({
          'payment_method_id': paymentMethodID,
          'amount': amount,
        }));

    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  ///API service for saving user subscription
  Future<APIStandardReturnFormat> addUserSubscription(
      String startDate, String endDate, String code, double price) async {
    // final String? token = await secureStorage.read(key: 'token');
    // final String? user_id = await secureStorage.read(key: 'user_id');
    final String token = UserSingleton.instance.user.token;
    final String userId = UserSingleton.instance.user.id;
    final http.Response response = await http.post(
        Uri.parse(
            '$apiBaseMode$apiBaseUrl/${AppAPIPath.userSubscriptionApiUrl}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'content-type': 'application/json'
        },
        body: jsonEncode({
          'user_id': userId,
          'start_date': startDate,
          'end_date': endDate,
          'code': code,
          'cost': price
        }));

    return GlobalAPIServices().formatResponseToStandardFormat(response);
  }
}
