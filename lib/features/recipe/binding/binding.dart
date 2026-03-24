import 'package:fit_and_fuel/features/recipe/controller/controller.dart';
import 'package:get/get.dart';

class RecipeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecipeController());
  }
}
