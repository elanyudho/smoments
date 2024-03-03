import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'stories_response.g.dart';

StoriesResponse storiesResponseFromJson(String str) => StoriesResponse.fromJson(json.decode(str));

String storiesResponseToJson(StoriesResponse data) => json.encode(data.toJson());

@JsonSerializable()
class StoriesResponse {
  bool error;
  String message;

  List<ListStory> listStory;

  StoriesResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory StoriesResponse.fromJson(Map<String, dynamic> json) => _$StoriesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoriesResponseToJson(this);
}

@JsonSerializable()
class ListStory {
  String id;
  String name;
  String description;
  String photoUrl;
  DateTime createdAt;
  double? lat;
  double? lon;

  ListStory({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });

  factory ListStory.fromJson(Map<String, dynamic> json) => _$ListStoryFromJson(json);

  Map<String, dynamic> toJson() => _$ListStoryToJson(this);
}
