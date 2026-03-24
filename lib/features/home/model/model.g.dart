// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteModel _$QuoteModelFromJson(Map<String, dynamic> json) =>
    QuoteModel()
      ..id = (json['id'] as num?)?.toInt()
      ..quote = json['quote'] as String?
      ..author = json['author'] as String?;

Map<String, dynamic> _$QuoteModelToJson(QuoteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quote': instance.quote,
      'author': instance.author,
    };

ExerciseHomeModel _$ExerciseHomeModelFromJson(Map<String, dynamic> json) =>
    ExerciseHomeModel()
      ..id = (json['id'] as num?)?.toInt()
      ..image = json['image'] as String?
      ..part = json['part'] as String?
      ..bgColor = json['bg_color'] as String?
      ..symbol = json['symbol'] as String?;

Map<String, dynamic> _$ExerciseHomeModelToJson(ExerciseHomeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'part': instance.part,
      'bg_color': instance.bgColor,
      'symbol': instance.symbol,
    };
