import 'dart:convert';
import 'package:fit_and_fuel/features/recipe/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecipeService {
  Future<List<RecipeListModel>> getRecipesData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/recipe.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final data =
          jsonData.map((item) => RecipeListModel.fromJson(item)).toList();

      return data;
    } catch (e) {
      debugPrint('[Log] getRecipesData error: $e');
      rethrow;
    }
  }

  Future<RecipeModel> getRecipeData({required int id}) async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/recipe.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final data = jsonData.map((item) => RecipeModel.fromJson(item)).toList();

      return data.firstWhere((r) => r.id == id);
    } catch (e) {
      debugPrint('[Log] getRecipeData error: $e');
      rethrow;
    }
  }
}
