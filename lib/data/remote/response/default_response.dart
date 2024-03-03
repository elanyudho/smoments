
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'default_response.g.dart';

DefaultResponse defaultResponseFromJson(String str) => DefaultResponse.fromJson(json.decode(str));

String defaultResponseToJson(DefaultResponse data) => json.encode(data.toJson());

@JsonSerializable()
class DefaultResponse {
  bool error;
  String message;

  DefaultResponse({
    required this.error,
    required this.message,
  });

  factory DefaultResponse.fromJson(Map<String, dynamic> json) => _$DefaultResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DefaultResponseToJson(this);
}
