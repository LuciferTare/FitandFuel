import 'package:fit_and_fuel/features/exercise/model/model.dart';
import 'package:fit_and_fuel/features/exercise/service/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExerciseController extends GetxController {
  RxList<MuscleModel> muscles = <MuscleModel>[].obs;
  RxList<ExerciseModel> exercises = <ExerciseModel>[].obs;
  RxBool isLoading = false.obs;

  Future<void> loadMuscleData(String part) async {
    isLoading.value = true;
    try {
      final data = await ExerciseService().getMuscleData(part);
      muscles.assignAll(data);
    } catch (e) {
      debugPrint('[Log] loadMuscleData error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadExerciseData(String part) async {
    isLoading.value = true;
    try {
      final data = await ExerciseService().getExerciseData(part);
      exercises.assignAll(data);
    } catch (e) {
      debugPrint('[Log] loadExerciseData error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
