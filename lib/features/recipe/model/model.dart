import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class RecipeListModel {
  int? id;
  String? heading;
  double? cal;
  double? carbs;
  double? fat;
  double? protien;
  int? serve;
  String? image;

  RecipeListModel();

  factory RecipeListModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeListModelFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeListModelToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class RecipeModel {
  int? id;
  String? heading;
  String? description;
  List<String>? ingredients;
  List<String>? tips;
  List<String>? steps;
  double? cal;
  double? carbs;
  double? fat;
  double? protien;
  int? serve;
  String? image;

  RecipeModel();

  factory RecipeModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeModelFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeModelToJson(this);
}
