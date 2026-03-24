import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class QuoteModel {
  int? id;
  String? quote;
  String? author;

  QuoteModel();

  factory QuoteModel.fromJson(Map<String, dynamic> json) =>
      _$QuoteModelFromJson(json);
  Map<String, dynamic> toJson() => _$QuoteModelToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class ExerciseHomeModel {
  int? id;
  String? image;
  String? part;
  String? bgColor;
  String? symbol;

  ExerciseHomeModel();

  factory ExerciseHomeModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseHomeModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExerciseHomeModelToJson(this);
}
