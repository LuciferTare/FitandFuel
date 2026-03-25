import 'package:fit_and_fuel/features/home/binding/binding.dart';
import 'package:fit_and_fuel/features/music/binding/binding.dart';
import 'package:fit_and_fuel/features/recipe/binding/binding.dart';
import 'package:get/get.dart';

class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    final int index = Get.arguments?['index'] ?? 0;

    switch (index) {
      case 0:
        HomeBinding().dependencies();
        break;
      case 1:
        RecipeBinding().dependencies();
        break;
      case 2:
        MusicBinding().dependencies();
        break;
      case 3:
        RecipeBinding().dependencies();
        break;
    }
  }
}
