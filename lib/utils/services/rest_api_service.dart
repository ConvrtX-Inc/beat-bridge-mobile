/*
  We do call the rest API to get, store data on a remote database for that we need to write the rest API call at a
  single place and need to return the data if the rest call is a success or need to return custom error exception on
  the basis of 4xx, 5xx status code. We can make use of http package to make the rest API call in the flutter
 */
import 'package:beatbridge/constants/api_path.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
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
          'password': userParams.password,
          'phone_number': userParams.phoneNumber
        });

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
}
