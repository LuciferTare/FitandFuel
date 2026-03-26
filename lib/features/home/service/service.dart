import 'dart:convert';
import 'package:fit_and_fuel/features/home/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeService {
  Future<List<QuoteModel>> getQuoteData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/quotes.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final data = jsonData.map((item) => QuoteModel.fromJson(item)).toList();

      return data;
    } catch (e) {
      debugPrint('[Log] getQuoteData error: $e');
      rethrow;
    }
  }

  Future<List<ExerciseHomeModel>> getExerciseData() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/home_exercises.json',
      );
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final data =
          jsonData.map((item) => ExerciseHomeModel.fromJson(item)).toList();

      return data;
    } catch (e) {
      debugPrint('[Log] getExerciseData error: $e');
      rethrow;
    }
  }
}
