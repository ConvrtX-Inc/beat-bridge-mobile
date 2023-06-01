import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Global API services
class GlobalAPIServices {
  /// List of all success codes
  final List<String> successCodes = <String>['200', '201'];

  /// Global standard API return format
  Future<APIStandardReturnFormat> formatResponseToStandardFormat(
      http.Response response) async {
    if (successCodes.contains(response.statusCode.toString())) {
      return APIStandardReturnFormat(
        statusCode: response.statusCode,
        successResponse: response.body,
        status: 'success',
      );
    } else {
      return APIStandardReturnFormat(
        statusCode: response.statusCode,
        errorResponse: response.body,
        status: 'error',
      );
    }
  }

  /// debugging
  void debugging(String functionName, String url, int statusCode, dynamic body,
      dynamic params) {
    debugPrint('FUNCTION NAME ---->>>>>>>> $functionName');
    debugPrint('RESPONSE URL ---->>>>>>>> $url');
    debugPrint('RESPONSE STATUS CODE ---->>>>>>>> $statusCode');
    debugPrint('RESPONSE BODY ---->>>>>>>> $body');
    debugPrint('RESPONSE PARAMETERS ---->>>>>>>> $params');
  }
}
