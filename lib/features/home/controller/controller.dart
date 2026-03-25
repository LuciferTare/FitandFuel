import 'dart:async';
import 'package:fit_and_fuel/features/home/model/model.dart';
import 'package:fit_and_fuel/features/home/service/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxList<QuoteModel> quotes = <QuoteModel>[].obs;
  RxList<ExerciseHomeModel> exercises = <ExerciseHomeModel>[].obs;
  RxBool isLoading = false.obs;
  Timer? timer;
  bool snackbarShown = false;

  @override
  void onReady() {
    super.onReady();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        HomeService().getQuoteData(),
        HomeService().getExerciseData(),
      ]);
      quotes.assignAll(results[0] as List<QuoteModel>);
      exercises.assignAll(results[1] as List<ExerciseHomeModel>);
    } catch (e) {
      debugPrint('[LOG] loadHomeData error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
