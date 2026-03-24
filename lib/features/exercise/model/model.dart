import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class ExerciseModel {
  String? part;
  String? muscle;
  String? name;
  String? equipment;
  String? desc;
  String? asset;

  ExerciseModel();

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExerciseModelToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class MuscleModel {
  String? part;
  String? muscle;

  MuscleModel();

  factory MuscleModel.fromJson(Map<String, dynamic> json) =>
      _$MuscleModelFromJson(json);
  Map<String, dynamic> toJson() => _$MuscleModelToJson(this);
}
