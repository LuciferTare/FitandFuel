import 'package:fit_and_fuel/features/calorie_calculator/calorie_calculator.dart';
import 'package:fit_and_fuel/features/exercise/binding/binding.dart';
import 'package:fit_and_fuel/features/exercise/exercise.dart';
import 'package:fit_and_fuel/features/home/binding/binding.dart';
import 'package:fit_and_fuel/features/home/home.dart';
import 'package:fit_and_fuel/features/main_shell/binding/binding.dart';
import 'package:fit_and_fuel/features/main_shell/main_shell.dart';
import 'package:fit_and_fuel/features/music/binding/binding.dart';
import 'package:fit_and_fuel/features/music/music.dart';
import 'package:fit_and_fuel/features/recipe/binding/binding.dart';
import 'package:fit_and_fuel/features/recipe/recipes.dart';
import 'package:get/get.dart';

class MyRoutes {
  static String initialRoute = "/Initial";
  static String shellRoute = "/MainShell";
  static String homeRoute = "/Home";
  static String exerciseRoute = "/Exercise";
  static String recipeListRoute = "/RecipeList";
  static String musicRoute = "/Music";
  static String calorieCalculatorRoute = "/CalorieCalculator";

  static List<GetPage> pages = [
    GetPage(
      name: initialRoute,
      page: () => MainShell(initialIdx: 0),
      binding: MainShellBinding(),
    ),
    GetPage(
      name: shellRoute,
      page: () => MainShell(initialIdx: Get.arguments?['idx'] ?? 0),
      binding: MainShellBinding(),
    ),
    GetPage(name: homeRoute, page: () => const Home(), binding: HomeBinding()),
    GetPage(
      name: exerciseRoute,
      page: () => const Exercise(),
      binding: ExerciseBinding(),
    ),
    GetPage(
      name: recipeListRoute,
      page: () => const RecipeList(),
      binding: RecipeBinding(),
    ),
    GetPage(
      name: musicRoute,
      page: () => const Music(),
      binding: MusicBinding(),
    ),
    GetPage(
      name: calorieCalculatorRoute,
      page: () => const CalorieCalculator(),
      binding: RecipeBinding(),
    ),
  ];
}
