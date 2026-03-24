import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class SongModel {
  int? id;
  String? title;
  String? artist;
  String? thumb;
  String? asset;

  SongModel();

  factory SongModel.fromJson(Map<String, dynamic> json) =>
      _$SongModelFromJson(json);
  Map<String, dynamic> toJson() => _$SongModelToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class PlaylistModel {
  int? id;
  String? title;
  String? icon;
  String? cover;
  String? color;
  List<int>? songIds;

  PlaylistModel();

  factory PlaylistModel.fromJson(Map<String, dynamic> json) =>
      _$PlaylistModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistModelToJson(this);
}
