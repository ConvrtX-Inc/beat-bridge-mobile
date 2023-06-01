import 'dart:io';

import 'package:beatbridge/constants/api_path.dart';
import 'package:beatbridge/models/faqsmodel.dart';
import 'package:beatbridge/models/songsmodel.dart';
import 'package:beatbridge/models/ticketResponseModel.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/recent_queue.dart';
import 'package:beatbridge/utils/approutes.dart';
import 'package:beatbridge/utils/services/api_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

TicketResponseModel ticketResponseModel =TicketResponseModel();

class BaseHelper {
  var baseUrl = "https://beat.softwarealliancetest.tk";
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  toast(context, message) {
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.grey,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<List<SongsData>> getUserSongs({context, queueId, isUser}) async {
    final String? userID;
    if (isUser == true) {
      userID = await secureStorage.read(key: 'userID');
    } else {
      userID = queueId;
    }

    print("user id  or queue id: $userID");
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    var header = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Bearer $userAuthToken",
      // "Authorization": "Bearer ${User.userData.token}",
    };
    List<SongsData> allsongs = [];
    var url = "$baseUrl${AppAPIPath.getUserSongs}$userID";
    print("$url");

    try {
      var body = {
        // "email": "$email",
      };
      print("body: $body");
      print("header $header");
      // EasyLoading.show();
      final response = await http.get(
        Uri.parse(url),
        headers: header,
      );
      var Jsons = json.decode(response.body);
      print("all songs response:$Jsons");
      if (response.statusCode == 200) {
        print("response status code: ${response.statusCode}");

        print(json.decode(response.body));
        if (Jsons.length > 0) {
          for (int i = 0; i < Jsons.length; i++) {
            Map<String, dynamic> map = Jsons[i];

            allsongs.add(SongsData.fromJson(map));

            // debugPrint('firstname-------${map['name']}');
            // print("coaches name: ${_coachesitems[i].name}");
            //  print(_coachesitems[i].tag[i]);

          }
          return allsongs;
        } else {
          return [];
        }
        // constValues().toast("${Json['message']}", context);

        return [];
      } else {
        // showAlertDialog(context, "Message");
        return [];
        // constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      // constValues().toast("${getTranslated(context, "no_internet")}", context);

      toast(context, "No Internet");
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      toast(context, "$error");
      // constValues().toast("$error", context);

      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);
      toast(context, "$error");
      // constValues().toast("$error", context);

      print("Bad response format 👎");
    } catch (value) {
      toast(context, "$value");
      // constValues().toast("$value", context);

      print(value);
    }
    return allsongs;
  }

  Future<dynamic> songsPLayed({context, uriId}) async {
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    var header = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Bearer $userAuthToken",
      // "Authorization": "Bearer ${User.userData.token}",
    };
    List<SongsData> allsongs = [];
    var url = "$baseUrl${AppAPIPath.songPLayed}$uriId";
    print("$url");
    var Jsons;
    try {
      var body = {
        // "email": "$email",
      };
      print("body: $body");
      print("header $header");
      // EasyLoading.show();
      final response = await http.get(
        Uri.parse(url),
        headers: header,
      );
      Jsons = json.decode(response.body);
      print("song played response:$Jsons");
      if (response.statusCode == 200) {
        print("response status code: ${response.statusCode}");

        // print(""+json.decode(response.body));
        // if (Jsons.length > 0) {
        //   for (int i = 0; i < Jsons.length; i++) {
        //     Map<String, dynamic> map = Jsons[i];

        //     allsongs.add(SongsData.fromJson(map));

        //     // debugPrint('firstname-------${map['name']}');
        //     // print("coaches name: ${_coachesitems[i].name}");
        //     //  print(_coachesitems[i].tag[i]);

        //   }
        //   return allsongs;
        // } else {
        //   return [];
        // }
        // constValues().toast("${Json['message']}", context);

        return Jsons;
      } else {
        // showAlertDialog(context, "Message");
        return Jsons;
        // constValues().toast("${Json['message']}", context);
      }
    } on SocketException {
      // constValues().toast("${getTranslated(context, "no_internet")}", context);

      toast(context, "No Internet");
      print('No Internet connection 😑');
    } on HttpException catch (error) {
      print(error);
      toast(context, "$error");
      // constValues().toast("$error", context);

      print("Couldn't find the post 😱");
    } on FormatException catch (error) {
      print(error);
      toast(context, "$error");
      // constValues().toast("$error", context);

      print("Bad response format 👎");
    } catch (value) {
      toast(context, "$value");
      // constValues().toast("$value", context);

      print(value);
    }
    return Jsons;
  }

  Future<dynamic> leaveQueueMember(String qid, String uid, context) async {
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    final String? userID = await secureStorage.read(key: 'userID');

    var _body = <String, dynamic>{
      'user_queue_id': qid,
      'user_id': userID,
      'is_admin': false
    };
    var body = json.encode(_body);
    var url =
        "https://beat.softwarealliancetest.tk${AppAPIPath.leaveQueue}$qid";
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
        'content-type': 'application/json'
      },
    );
    print(body);
    print('response from: ${response.body}');
    var jsons = json.decode(response.body);
    if (response.statusCode == 200) {
      // AppRoutes.makeFirst(context, RecentQueues());
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => RecentQueues(),
      //   ),
      // );
      return jsons;
    } else {
      return jsons;
    }
    // return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  Future<dynamic> deleteTrack(String qid, String trackId, context) async {
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    final String? userID = await secureStorage.read(key: 'userID');

    var _body = <String, dynamic>{"queueId": "$qid", "trackId": "$trackId"};
    var body = json.encode(_body);
    var url = "https://beat.softwarealliancetest.tk${AppAPIPath.deleteTracks}";
    print("deleete track url: $url");
    final http.Response response = await http.delete(
      Uri.parse(url),
      body: body,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
        'content-type': 'application/json'
      },
    );
    print(body);
    print('response from: ${response.body}');
    var jsons = json.decode(response.body);
    if (response.statusCode == 200) {
      // AppRoutes.makeFirst(context, RecentQueues());
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => RecentQueues(),
      //   ),
      // );
      return jsons;
    } else {
      return jsons;
    }
    // return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  Future<dynamic> checkFriend(friendId, context) async {
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    final String? userID = await secureStorage.read(key: 'userID');

    var _body = <String, dynamic>{'friend_id': '$friendId'};
    print("body of friend; $_body");
    var body = _body;
    var url = "$baseUrl/${AppAPIPath.checkFriend}";
    print("deleete track url: $url");
    print("auth token: $userAuthToken");
    final http.Response response = await http.post(
      Uri.parse(url),
      body: body,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
        // 'content-type': 'application/json'
      },
    );
    print(body);
    print('response from: ${response.body}');
    var jsons = json.decode(response.body);
    if (response.statusCode == 200) {
      // AppRoutes.makeFirst(context, RecentQueues());
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => RecentQueues(),
      //   ),
      // );
      return jsons;
    } else {
      return jsons;
    }
    // return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  Future<dynamic> addSupport(String title, String message, context) async {
    print('yyyyyyyyyyyyyy');

    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    final String? userID = await secureStorage.read(key: 'userID');
    print("token: $userAuthToken");
    try {} catch (e) {
      toast(context, "$e");
    }
    var _body = <String, dynamic>{
      "user_id": "$userID",
      "title": "$title",
      "message": "$message "
    };
    var body = json.encode(_body);
    var url = "https://beat.softwarealliancetest.tk${AppAPIPath.addSupport}";
    print("deleete track url: $url");
    final http.Response response = await http.post(
      Uri.parse(url),
      body: body,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
        'content-type': 'application/json'
      },
    );
    print(body);
    print('response from tickettttttttt: ${response.body}');
    var jsons = json.decode(response.body);
    if (response.statusCode == 200) {
      print('///////////////////////');

      return jsons;
    } else {
      ticketResponseModel = TicketResponseModel.fromJson(jsonDecode(response.body));
      print('8888888888888888888888');

      print('idktmlnmonnop');
      print(ticketResponseModel.id);
      print('messagenignbuignmnign');
      print(ticketResponseModel.message);
      print('elseeee ///////////////////////');

      return jsons;
    }
    // return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  Future<dynamic> getFaq(context) async {
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    final String? userID = await secureStorage.read(key: 'userID');
    print("token: $userAuthToken");
    try {} catch (e) {
      toast(context, "$e");
    }

    var url = "https://beat.softwarealliancetest.tk${AppAPIPath.getFaqs}";
    print("deleete track url: $url");
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
        'content-type': 'application/json'
      },
    );

    print('response from: ${response.body}');
    var jsons = json.decode(response.body);
    if (response.statusCode == 200) {
      // AppRoutes.makeFirst(context, RecentQueues());
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => RecentQueues(),
      //   ),
      // );
      return jsons;
    } else {
      return jsons;
    }
    // return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  Future<dynamic> getPrivacyPolicy(context) async {
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    final String? userID = await secureStorage.read(key: 'userID');
    print("token: $userAuthToken");
    try {} catch (e) {
      toast(context, "$e");
    }

    var url =
        "https://beat.softwarealliancetest.tk${AppAPIPath.getPrivacyPolicy}";
    print("deleete track url: $url");
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
        'content-type': 'application/json'
      },
    );

    var jsons = json.decode(response.body);
    if (response.statusCode == 200) {
      // AppRoutes.makeFirst(context, RecentQueues());
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => RecentQueues(),
      //   ),
      // );
      return jsons;
    } else {
      return jsons;
    }
    // return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  Future<dynamic> getFAQ(context) async {
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    final String? userID = await secureStorage.read(key: 'userID');
    print("token: $userAuthToken");
    try {} catch (e) {
      toast(context, "$e");
    }

    var url = "https://beat.softwarealliancetest.tk${AppAPIPath.getFaqs}";
    print("deleete track url: $url");
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
        'content-type': 'application/json'
      },
    );
    List<FaqResult> faqResult = [];

    var jsons = json.decode(response.body);
    if (response.statusCode == 200) {
      for (int i = 0; i < jsons.length; i++) {
        Map<String, dynamic> map = jsons[i];

        print("dataa: $map");
        faqResult.add(FaqResult.fromJson(map));
      }
      return faqResult;

      // return jsons;
    } else {
      return jsons;
    }
    // return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  Future<dynamic> getTermsCondition(context) async {
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    final String? userID = await secureStorage.read(key: 'userID');
    print("token: $userAuthToken");
    try {} catch (e) {
      toast(context, "$e");
    }

    var url =
        "https://beat.softwarealliancetest.tk${AppAPIPath.getTermsCondition}";
    print("deleete track url: $url");
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
        'content-type': 'application/json'
      },
    );

    print('response from: ${response.body}');
    var jsons = json.decode(response.body);
    if (response.statusCode == 200) {
      // AppRoutes.makeFirst(context, RecentQueues());
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => RecentQueues(),
      //   ),
      // );
      return jsons;
    } else {
      return jsons;
    }
    // return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

  Future<dynamic> getSupport(context) async {
    final String? userAuthToken =
        await secureStorage.read(key: 'userAuthToken');
    final String? userID = await secureStorage.read(key: 'userID');
    print("token: $userAuthToken");
    try {} catch (e) {
      toast(context, "$e");
    }

    var url =
        "https://beat.softwarealliancetest.tk${AppAPIPath.getSupport}$userID";
    print("deleete track url: $url");
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $userAuthToken',
        'content-type': 'application/json'
      },
    );

    print('response from: ${response.body}');
    var jsons = json.decode(response.body);
    if (response.statusCode == 200) {
      // AppRoutes.makeFirst(context, RecentQueues());
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => RecentQueues(),
      //   ),
      // );
      return jsons;
    } else {
      return jsons;
    }
    // return GlobalAPIServices().formatResponseToStandardFormat(response);
  }

}
