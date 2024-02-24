
import 'dart:convert';

DefaultResponse defaultResponseFromJson(String str) => DefaultResponse.fromJson(json.decode(str));

String defaultResponseToJson(DefaultResponse data) => json.encode(data.toJson());

class DefaultResponse {
  bool error;
  String message;

  DefaultResponse({
    required this.error,
    required this.message,
  });

  factory DefaultResponse.fromJson(Map<String, dynamic> json) => DefaultResponse(
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
  };
}
