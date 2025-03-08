import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/user_goals_model.dart';
import '../../../controllers/auth_controller.dart';

class QuestionnaireController extends GetxController {
  final AuthController authC = Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  var age = 0.obs;
  var weight = 0.0.obs;
  var height = 0.0.obs;
  var gender = ''.obs;
  var activityLevel = ''.obs;
  var goal = ''.obs;

  Future<void> calculateAndSaveGoals() async {
    try {
      // Basic BMR calculation using Mifflin-St Jeor Equation
      double bmr;
      if (gender.value == 'male') {
        bmr = 10 * weight.value + 6.25 * height.value - 5 * age.value + 5;
      } else {
        bmr = 10 * weight.value + 6.25 * height.value - 5 * age.value - 161;
      }

      // Activity level multiplier
      double activityMultiplier = 1.2; // Default sedentary
      switch (activityLevel.value) {
        case 'light':
          activityMultiplier = 1.375;
          break;
        case 'moderate':
          activityMultiplier = 1.55;
          break;
        case 'active':
          activityMultiplier = 1.725;
          break;
        case 'very_active':
          activityMultiplier = 1.9;
          break;
      }

      double calories = bmr * activityMultiplier;

      // Menyesuaikan kalori berdasarkan tujuan
      // - Untuk menurunkan berat badan: kurangi 500 kalori
      // - Untuk menaikkan berat badan: tambah 500 kalori
      switch (goal.value) {
        case 'lose':
          calories -= 500;
          break;
        case 'gain':
          calories += 500;
          break;
      }

      // Membuat objek goals dengan perhitungan:
      // - Protein: 2 gram per kg berat badan
      // - Karbohidrat: 45% dari total kalori (dibagi 4 karena 1g karbo = 4 kalori)
      // - Lemak: 25% dari total kalori (dibagi 9 karena 1g lemak = 9 kalori)
      final goals = UserGoals(
        caloriesGoal: calories,
        proteinGoal: weight.value * 2.0, // 2g per kg berat badan
        carbsGoal: (calories * 0.45) / 4, // 45% dari total kalori
        fatGoal: (calories * 0.25) / 9, // 25% dari total kalori
        lastUpdated: DateTime.now(),
      );

      await _db
          .collection('users')
          .doc(authC.currentUser.value.id)
          .collection('goals')
          .doc('current')
          .set(goals.toJson());

      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save goals: $e');
    }
  }
}
