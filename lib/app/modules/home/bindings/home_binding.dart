import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../services/nutrition_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NutritionService());
    Get.lazyPut(
      () => HomeController(nutritionService: Get.find<NutritionService>()),
    );
  }
}
