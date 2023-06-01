import 'dart:convert';
import 'dart:io';

import 'package:beatbridge/models/spotify/auth_tokens.dart';
import 'package:beatbridge/utils/services/api_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SpotifyAuthApi {
  final String clientId = '2e522304863a47b49febbb598d524472';
  // '2e522304863a47b49febbb598d524472';
  final String clientSecret = '540aa17a76224bdebc8e25cf3c24951b';
  // '540aa17a76224bdebc8e25cf3c24951b';
  final String base64Credential = utf8.fuse(base64).encode(
      '7f9bf13747164bbd999f79a1c91eb4b2:b4b49577b89b49af98b8e17f4f761283');

  static Future<AuthTokens> getAuthTokens(
      String code, String redirectUri) async {
    final response = await http.post(Uri.http(APIPath.requestToken), body: {
      'grant_type': 'authorization_code',
      'code': code,
      'redirect_uri': redirectUri,
    }, headers: {
      HttpHeaders.authorizationHeader:
          'Basic ${utf8.fuse(base64).encode('7f9bf13747164bbd999f79a1c91eb4b2:b4b49577b89b49af98b8e17f4f761283')}',
    }
        //headers: {HttpHeaders.authorizationHeader: 'Basic $base64Credential'},
        );

    if (response.statusCode == 200) {
      return AuthTokens.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to load token with status code ${response.statusCode}');
    }
  }

  static Future<AuthTokens> getNewTokens(
      {required AuthTokens originalTokens}) async {
    final response = await http.post(Uri.http(APIPath.requestToken), body: {
      'grant_type': 'refresh_token',
      'refresh_token': originalTokens.refreshToken,
    }, headers: {
      HttpHeaders.authorizationHeader:
          'Basic ${utf8.fuse(base64).encode('7f9bf13747164bbd999f79a1c91eb4b2:b4b49577b89b49af98b8e17f4f761283')}',
    });

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['refresh_token'] == null)
        responseBody['refresh_token'] = originalTokens.refreshToken;

      return AuthTokens.fromJson(responseBody);
    } else {
      throw Exception(
          'Failed to refresh token with status code ${response.statusCode}');
    }
  }
}
