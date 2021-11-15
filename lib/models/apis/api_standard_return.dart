/// Model for API standard return format
class APIStandardReturnFormat {
  /// Constructor
  const APIStandardReturnFormat(
      {this.statusCode = 200,
      this.status = '',
      this.errorResponse = '',
      this.successResponse = ''});

  /// Status code
  final int statusCode;

  /// Status
  final String status;

  /// Error response
  final String errorResponse;

  /// Success response
  final String successResponse;
}
