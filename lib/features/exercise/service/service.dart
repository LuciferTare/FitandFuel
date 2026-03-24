import 'dart:convert';
import 'package:fit_and_fuel/features/exercise/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExerciseService {
  Future<List<MuscleModel>> getMuscleData(String part) async {
    try {
      // var res = await Get.find<ApiClient>().getRequest<ExerciseModel>('/api/qoutes/', isAuth: true);
      // var data = (res.data as List).map((item) => ExerciseModel.fromJson(item as Map<String, dynamic>)).toList();
      final jsonString = await rootBundle.loadString('assets/data/muscle.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final data =
          jsonData
              .map((item) => MuscleModel.fromJson(item))
              .where((r) => r.part == part)
              .toList();

      return data;
    } catch (e) {
      debugPrint('[LOG] getExerciseData error: $e');
      rethrow;
    }
  }

  Future<List<ExerciseModel>> getExerciseData(String part) async {
    try {
      // var res = await Get.find<ApiClient>().getRequest<ExerciseModel>('/api/qoutes/', isAuth: true);
      // var data = (res.data as List).map((item) => ExerciseModel.fromJson(item as Map<String, dynamic>)).toList();
      final jsonString = await rootBundle.loadString(
        'assets/data/exercises.json',
      );
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final data =
          jsonData
              .map((item) => ExerciseModel.fromJson(item))
              .where((r) => r.part == part)
              .toList();

      return data;
    } catch (e) {
      debugPrint('[LOG] getExerciseData error: $e');
      rethrow;
    }
  }
}
