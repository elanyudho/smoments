import 'dart:convert';

class ErrorResponse {
  final int code;
  final String message;

  ErrorResponse(this.code, this.message);

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      json['code'] ?? 0, //
      json['message'] ?? 'Unknown error',
    );
  }
}

ErrorResponse parseErrorResponse(String responseBody) {
  final Map<String, dynamic> errorResponse = json.decode(responseBody);
  return ErrorResponse.fromJson(errorResponse);
}