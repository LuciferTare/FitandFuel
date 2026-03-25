import 'package:fit_and_fuel/features/music/controller/controller.dart';
import 'package:get/get.dart';

class MusicBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MusicController(), permanent: true);
  }
}
