import 'dart:convert';
import 'package:fit_and_fuel/features/recipe/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecipeService {
  Future<List<RecipeListModel>> getRecipesData() async {
    try {
      // var res = await Get.find<ApiClient>().getRequest<RecipeListModel>('/api/qoutes/', isAuth: true);
      // var data = (res.data as List).map((item) => RecipeListModel.fromJson(item as Map<String, dynamic>)).toList();
      final jsonString = await rootBundle.loadString('assets/data/recipe.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final data =
          jsonData.map((item) => RecipeListModel.fromJson(item)).toList();

      return data;
    } catch (e) {
      debugPrint('[LOG] getRecipesData error: $e');
      rethrow;
    }
  }

  Future<RecipeModel> getRecipeData({required int id}) async {
    try {
      // var res = await Get.find<ApiClient>().getRequest<RecipeModel>('/api/exercise-home/', isAuth: true,);
      // var data = RecipeModel.fromJson(res.data);
      final jsonString = await rootBundle.loadString('assets/data/recipe.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final data = jsonData.map((item) => RecipeModel.fromJson(item)).toList();

      return data.firstWhere((r) => r.id == id);
    } catch (e) {
      debugPrint('[LOG] getRecipeData error: $e');
      rethrow;
    }
  }
}
