// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SongModel _$SongModelFromJson(Map<String, dynamic> json) =>
    SongModel()
      ..id = (json['id'] as num?)?.toInt()
      ..title = json['title'] as String?
      ..artist = json['artist'] as String?
      ..thumb = json['thumb'] as String?
      ..asset = json['asset'] as String?;

Map<String, dynamic> _$SongModelToJson(SongModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'artist': instance.artist,
  'thumb': instance.thumb,
  'asset': instance.asset,
};

PlaylistModel _$PlaylistModelFromJson(Map<String, dynamic> json) =>
    PlaylistModel()
      ..id = (json['id'] as num?)?.toInt()
      ..title = json['title'] as String?
      ..icon = json['icon'] as String?
      ..cover = json['cover'] as String?
      ..color = json['color'] as String?
      ..songIds =
          (json['song_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList();

Map<String, dynamic> _$PlaylistModelToJson(PlaylistModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'icon': instance.icon,
      'cover': instance.cover,
      'color': instance.color,
      'song_ids': instance.songIds,
    };
