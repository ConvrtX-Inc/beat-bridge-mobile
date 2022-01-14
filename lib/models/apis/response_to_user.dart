import 'package:beatbridge/models/users/user_model.dart';

/// Model for API standard return format
class APIResponsedToUserObject {
  /// Constructor
  const APIResponsedToUserObject(
      {this.statusCode = 200,
      this.status = '',
      this.errorResponse = '',
      this.user = const UserModel()});

  /// Status code
  final int statusCode;

  /// Status
  final String status;

  /// Error response
  final String errorResponse;

  /// Success response
  final UserModel user;
}
