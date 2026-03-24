// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeListModel _$RecipeListModelFromJson(Map<String, dynamic> json) =>
    RecipeListModel()
      ..id = (json['id'] as num?)?.toInt()
      ..heading = json['heading'] as String?
      ..cal = (json['cal'] as num?)?.toDouble()
      ..carbs = (json['carbs'] as num?)?.toDouble()
      ..fat = (json['fat'] as num?)?.toDouble()
      ..protien = (json['protien'] as num?)?.toDouble()
      ..serve = (json['serve'] as num?)?.toInt()
      ..image = json['image'] as String?;

Map<String, dynamic> _$RecipeListModelToJson(RecipeListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'heading': instance.heading,
      'cal': instance.cal,
      'carbs': instance.carbs,
      'fat': instance.fat,
      'protien': instance.protien,
      'serve': instance.serve,
      'image': instance.image,
    };

RecipeModel _$RecipeModelFromJson(Map<String, dynamic> json) =>
    RecipeModel()
      ..id = (json['id'] as num?)?.toInt()
      ..heading = json['heading'] as String?
      ..description = json['description'] as String?
      ..ingredients =
          (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
      ..tips =
          (json['tips'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..steps =
          (json['steps'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..cal = (json['cal'] as num?)?.toDouble()
      ..carbs = (json['carbs'] as num?)?.toDouble()
      ..fat = (json['fat'] as num?)?.toDouble()
      ..protien = (json['protien'] as num?)?.toDouble()
      ..serve = (json['serve'] as num?)?.toInt()
      ..image = json['image'] as String?;

Map<String, dynamic> _$RecipeModelToJson(RecipeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'heading': instance.heading,
      'description': instance.description,
      'ingredients': instance.ingredients,
      'tips': instance.tips,
      'steps': instance.steps,
      'cal': instance.cal,
      'carbs': instance.carbs,
      'fat': instance.fat,
      'protien': instance.protien,
      'serve': instance.serve,
      'image': instance.image,
    };
