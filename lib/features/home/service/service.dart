import 'dart:convert';
import 'package:fit_and_fuel/features/home/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeService {
  Future<List<QuoteModel>> getQuoteData() async {
    try {
      // var res = await Get.find<ApiClient>().getRequest<QuoteModel>('/api/qoutes/', isAuth: true);
      // var data = (res.data as List).map((item) => QuoteModel.fromJson(item as Map<String, dynamic>)).toList();
      final jsonString = await rootBundle.loadString('assets/data/quotes.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final data = jsonData.map((item) => QuoteModel.fromJson(item)).toList();

      return data;
    } catch (e) {
      debugPrint('[LOG] getQuoteData error: $e');
      rethrow;
    }
  }

  Future<List<ExerciseHomeModel>> getExerciseData() async {
    try {
      // var res = await Get.find<ApiClient>().getRequest<ExerciseHomeModel>('/api/exercise-home/', isAuth: true,);
      // var data = (res.data as List).map((item) => ExerciseHomeModel.fromJson(item as Map<String, dynamic>),).toList();
      final jsonString = await rootBundle.loadString(
        'assets/data/home_exercises.json',
      );
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final data =
          jsonData.map((item) => ExerciseHomeModel.fromJson(item)).toList();

      return data;
    } catch (e) {
      debugPrint('[LOG] getExerciseData error: $e');
      rethrow;
    }
  }
}
