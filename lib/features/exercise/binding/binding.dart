import 'package:fit_and_fuel/features/exercise/controller/controller.dart';
import 'package:get/get.dart';

class ExerciseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExerciseController());
  }
}
