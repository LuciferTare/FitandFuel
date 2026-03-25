import 'dart:async';
import 'package:fit_and_fuel/features/recipe/model/model.dart';
import 'package:fit_and_fuel/features/recipe/service/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecipeController extends GetxController {
  RxList<RecipeListModel> recipeList = <RecipeListModel>[].obs;
  Rx<RecipeModel> recipe = RecipeModel().obs;
  RxBool isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    getRecipes();
  }

  Future<void> getRecipes() async {
    isLoading.value = true;
    try {
      List<RecipeListModel> data = await RecipeService().getRecipesData();
      recipeList.assignAll(data);
    } catch (e) {
      debugPrint('[LOG] getRecipes error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getRecipe(int id) async {
    isLoading.value = true;
    try {
      RecipeModel data = await RecipeService().getRecipeData(id: id);
      recipe.value = data;
    } catch (e) {
      debugPrint('[LOG] getRecipe error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
