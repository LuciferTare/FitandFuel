// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseModel _$ExerciseModelFromJson(Map<String, dynamic> json) =>
    ExerciseModel()
      ..part = json['part'] as String?
      ..muscle = json['muscle'] as String?
      ..name = json['name'] as String?
      ..equipment = json['equipment'] as String?
      ..desc = json['desc'] as String?
      ..asset = json['asset'] as String?;

Map<String, dynamic> _$ExerciseModelToJson(ExerciseModel instance) =>
    <String, dynamic>{
      'part': instance.part,
      'muscle': instance.muscle,
      'name': instance.name,
      'equipment': instance.equipment,
      'desc': instance.desc,
      'asset': instance.asset,
    };

MuscleModel _$MuscleModelFromJson(Map<String, dynamic> json) =>
    MuscleModel()
      ..part = json['part'] as String?
      ..muscle = json['muscle'] as String?;

Map<String, dynamic> _$MuscleModelToJson(MuscleModel instance) =>
    <String, dynamic>{'part': instance.part, 'muscle': instance.muscle};
