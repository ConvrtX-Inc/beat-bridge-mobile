import 'package:beatbridge/models/apis/api_standard_return.dart';
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
  void debugging(functionName, url, statusCode, body, params) {
    print('FUNCTION NAME ---->>>>>>>> $functionName');
    print('RESPONSE URL ---->>>>>>>> $url');
    print('RESPONSE STATUS CODE ---->>>>>>>> $statusCode');
    print('RESPONSE BODY ---->>>>>>>> $body');
    print('RESPONSE PARAMETERS ---->>>>>>>> $params');
  }
}
