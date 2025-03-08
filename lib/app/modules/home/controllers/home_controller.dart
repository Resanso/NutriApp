// ignore_for_file: avoid_types_as_parameter_names, unnecessary_overrides, avoid_print, invalid_use_of_protected_member

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutri_app/app/models/user_goals_model.dart';
import 'package:nutri_app/app/widgets/questionnaire_form.dart';
import '../../../services/nutrition_service.dart';
import '../../../models/nutrition_entry_model.dart';
import '../../../controllers/auth_controller.dart';

class HomeController extends GetxController {
  final NutritionService nutritionService;
  final foodInputController = TextEditingController();
  final AuthController authC = Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  HomeController({required this.nutritionService});

  var isLoading = false.obs;
  var foodItems = <FoodItem>[].obs;
  var userHistory = <DailyEntry>[].obs;
  final userGoals = Rxn<UserGoals>();
  final todayProgress = <String, double>{}.obs;

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Delay the fetch to avoid build phase issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUserHistory();
      fetchUserGoals();
      calculateTodayProgress();
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    foodInputController.dispose();
    super.onClose();
  }

  void increment() => count.value++;

  Future<void> calculateNutrition() async {
    if (foodInputController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter food items');
      return;
    }

    try {
      isLoading.value = true;
      final items = await nutritionService.getNutritionInfo(
        foodInputController.text,
      );
      foodItems.value = items;

      await saveToDailyEntries(items);

      foodInputController.clear();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveToDailyEntries(List<FoodItem> items) async {
    try {
      if (authC.currentUser.value.id == null) {
        Get.snackbar(
          'Error',
          'User not logged in',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final userId = authC.currentUser.value.id!;
      final date = DateTime.now();
      final totalCalories = items.fold(0.0, (sum, item) => sum + item.calories);

      final entry = DailyEntry(
        userId: userId,
        date: date,
        foods: items,
        totalCalories: totalCalories,
      );

      // Save to global daily_entries collection
      await _db.collection('daily_entries').add({
        ...entry.toJson(),
        'created_at': FieldValue.serverTimestamp(),
      });

      // Save to user's personal entries
      final userDoc = await _db.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        // Create user document if it doesn't exist
        await _db.collection('users').doc(userId).set({
          'email': authC.currentUser.value.email,
          'name': authC.currentUser.value.name,
          'created_at': FieldValue.serverTimestamp(),
        });
      }

      // Add entry to user's daily_entries subcollection
      await _db.collection('users').doc(userId).collection('daily_entries').add(
        {...entry.toJson(), 'created_at': FieldValue.serverTimestamp()},
      );

      await fetchUserHistory();
      calculateTodayProgress(); // Tambahkan ini

      Future.delayed(Duration.zero, () {
        Get.snackbar(
          'Success',
          'Food entries saved successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    } catch (e) {
      Future.delayed(Duration.zero, () {
        Get.snackbar(
          'Error',
          'Failed to save entry: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    }
  }

  Future<void> fetchUserHistory() async {
    try {
      if (authC.currentUser.value.id == null) {
        print('User not logged in');
        return;
      }

      final userId = authC.currentUser.value.id!;
      if (userId.isEmpty) {
        print('Empty user ID');
        return;
      }

      final snapshot =
          await _db
              .collection('users')
              .doc(userId)
              .collection('daily_entries')
              .orderBy('date', descending: true)
              .get();

      if (!snapshot.docs.isNotEmpty) {
        print('No entries found');
        userHistory.value = [];
        return;
      }

      userHistory.value =
          snapshot.docs
              .map((doc) {
                try {
                  final data = doc.data();
                  if (data.isEmpty) {
                    print('Empty document data');
                    return null;
                  }
                  return DailyEntry.fromJson(data);
                } catch (e) {
                  print('Error parsing document: $e');
                  return null;
                }
              })
              .whereType<DailyEntry>()
              .toList();

      calculateTodayProgress(); // Tambahkan ini
    } catch (e) {
      print('Error fetching history: $e');
      // Only show error if it's not due to normal conditions
      if (!e.toString().contains('null') && !e.toString().contains('empty')) {
        Future.delayed(Duration.zero, () {
          Get.snackbar(
            'Error',
            'Failed to fetch history: $e',
            snackPosition: SnackPosition.BOTTOM,
          );
        });
      }
    }
  }

  Future<void> deleteHistoryEntry(DailyEntry entry) async {
    try {
      final userId = authC.currentUser.value.id!;

      // Delete from user's daily entries
      final userEntriesSnapshot =
          await _db
              .collection('users')
              .doc(userId)
              .collection('daily_entries')
              .where('date', isEqualTo: entry.date.toIso8601String())
              .get();

      // Delete from global daily entries
      final globalEntriesSnapshot =
          await _db
              .collection('daily_entries')
              .where('user_id', isEqualTo: userId)
              .where('date', isEqualTo: entry.date.toIso8601String())
              .get();

      // Execute deletions
      final batch = _db.batch();

      // Add user entries to batch delete
      for (var doc in userEntriesSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Add global entries to batch delete
      for (var doc in globalEntriesSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Commit the batch
      await batch.commit();

      await fetchUserHistory();
      Get.snackbar(
        'Success',
        'Entry deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error deleting entry: $e');
      Get.snackbar(
        'Error',
        'Failed to delete entry: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<FoodItem?> updateFoodNutrition(String name, double quantity) async {
    try {
      final query = '${quantity}g $name';
      final items = await nutritionService.getNutritionInfo(query);
      if (items.isNotEmpty) {
        return items.first;
      }
      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to get nutrition info: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  Future<void> editHistoryEntry(
    DailyEntry oldEntry,
    List<FoodItem> newFoods,
  ) async {
    try {
      final userId = authC.currentUser.value.id!;
      final totalCalories = newFoods.fold(
        0.0,
        (sum, item) => sum + item.calories,
      );

      final updatedEntry = DailyEntry(
        userId: userId,
        date: oldEntry.date,
        foods: newFoods,
        totalCalories: totalCalories,
      );

      // Update in user's collection
      final userSnapshot =
          await _db
              .collection('users')
              .doc(userId)
              .collection('daily_entries')
              .where('date', isEqualTo: oldEntry.date.toIso8601String())
              .get();

      // Update in global collection
      final globalSnapshot =
          await _db
              .collection('daily_entries')
              .where('user_id', isEqualTo: userId)
              .where('date', isEqualTo: oldEntry.date.toIso8601String())
              .get();

      final batch = _db.batch();

      for (var doc in userSnapshot.docs) {
        batch.update(doc.reference, {
          ...updatedEntry.toJson(),
          'updated_at': FieldValue.serverTimestamp(),
        });
      }

      for (var doc in globalSnapshot.docs) {
        batch.update(doc.reference, {
          ...updatedEntry.toJson(),
          'updated_at': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      await fetchUserHistory();

      Get.snackbar(
        'Success',
        'Entry updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update entry: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> fetchUserGoals() async {
    try {
      final doc =
          await _db
              .collection('users')
              .doc(authC.currentUser.value.id)
              .collection('goals')
              .doc('current')
              .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        print('Raw goals data: $data');
        userGoals.value = UserGoals.fromJson(data);
        print('Parsed goals: ${userGoals.value?.toJson()}');
        calculateTodayProgress();
      } else {
        print('No goals document found, showing questionnaire');
        showGoalsQuestionnaireDialog();
      }
    } catch (e) {
      print('Error fetching goals: $e');
      showGoalsQuestionnaireDialog();
    }
  }

  void showGoalsQuestionnaireDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Set Your Nutrition Goals',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B3A4A),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  QuestionnaireForm(
                    onSubmit: (goals) {
                      calculateAndSaveGoals(goals);
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: true,
    );
  }

  void calculateTodayProgress() {
    if (userGoals.value == null) {
      print('No goals set yet');
      return;
    }

    final today = DateTime.now();
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    // Hitung nutrisi dari history hari ini
    final todayEntries =
        userHistory.where((entry) {
          return entry.date.year == today.year &&
              entry.date.month == today.month &&
              entry.date.day == today.day;
        }).toList();

    for (var entry in todayEntries) {
      for (var food in entry.foods) {
        totalCalories += food.calories;
        totalProtein += food.protein;
        totalCarbs += food.carbs;
        totalFat += food.fat;
      }
    }

    // Tambahkan juga nutrisi dari entri sementara (foodItems)
    for (var food in foodItems) {
      totalCalories += food.calories;
      totalProtein += food.protein;
      totalCarbs += food.carbs;
      totalFat += food.fat;
    }

    // Debug print untuk investigasi
    print('Raw values:');
    print(
      'Total calories: $totalCalories / Goal: ${userGoals.value!.caloriesGoal}',
    );
    print(
      'Total protein: $totalProtein / Goal: ${userGoals.value!.proteinGoal}',
    );
    print('Total carbs: $totalCarbs / Goal: ${userGoals.value!.carbsGoal}');
    print('Total fat: $totalFat / Goal: ${userGoals.value!.fatGoal}');

    // Hitung progress dan pastikan tidak melebihi 1.0
    final goals = userGoals.value!;

    final caloriesProgress =
        goals.caloriesGoal > 0 ? totalCalories / goals.caloriesGoal : 0.0;
    final proteinProgress =
        goals.proteinGoal > 0 ? totalProtein / goals.proteinGoal : 0.0;
    final carbsProgress =
        goals.carbsGoal > 0 ? totalCarbs / goals.carbsGoal : 0.0;
    final fatProgress = goals.fatGoal > 0 ? totalFat / goals.fatGoal : 0.0;

    // Debug print untuk progress
    print('Progress before clamping:');
    print('Calories: $caloriesProgress');
    print('Protein: $proteinProgress');
    print('Carbs: $carbsProgress');
    print('Fat: $fatProgress');

    todayProgress.value = {
      'calories': caloriesProgress.clamp(0.0, 1.0),
      'protein': proteinProgress.clamp(0.0, 1.0),
      'carbs': carbsProgress.clamp(0.0, 1.0),
      'fat': fatProgress.clamp(0.0, 1.0),
    };

    print('Final progress values: ${todayProgress.value}');
  }

  Future<void> calculateAndSaveGoals(Map<String, dynamic> formData) async {
    try {
      final goals = _calculateNutritionGoals(formData);
      await _saveGoalsToFirestore(goals);
      await _refreshGoalsAndProgress();
      _showSuccessMessage();
    } catch (e) {
      _handleError(e);
    }
  }

  /// Menghitung target nutrisi berdasarkan data form pengguna
  /// [formData] berisi data seperti berat, tinggi, umur, gender, level aktivitas, dan goal
  /// Return object UserGoals yang berisi target kalori, protein, karbohidrat, dan lemak
  UserGoals _calculateNutritionGoals(Map<String, dynamic> formData) {
    final bmr = _calculateBMR(formData);
    final tdee = _calculateTDEE(bmr, formData['activityLevel']);
    final targetCalories = _adjustCaloriesForGoal(tdee, formData['goal']);

    return UserGoals(
      caloriesGoal: targetCalories,
      // Protein: 30% dari total kalori, dibagi 4 karena 1g protein = 4 kalori
      proteinGoal: (targetCalories * 0.3) / 4,
      // Karbohidrat: 40% dari total kalori, dibagi 4 karena 1g karbo = 4 kalori
      carbsGoal: (targetCalories * 0.4) / 4,
      // Lemak: 30% dari total kalori, dibagi 9 karena 1g lemak = 9 kalori
      fatGoal: (targetCalories * 0.3) / 9,
      lastUpdated: DateTime.now(),
    );
  }

  /// Menghitung BMR (Basal Metabolic Rate) menggunakan formula Mifflin-St Jeor
  /// BMR adalah jumlah kalori yang dibakar tubuh saat istirahat
  /// [formData] berisi gender, berat (kg), tinggi (cm), dan umur (tahun)
  double _calculateBMR(Map<String, dynamic> formData) {
    if (formData['gender'] == 'male') {
      return (10 * formData['weight']) + // Faktor berat badan
          (6.25 * formData['height']) + // Faktor tinggi badan
          (5 * formData['age']) + // Faktor umur
          5; // Konstanta untuk pria
    } else {
      return (10 * formData['weight']) +
          (6.25 * formData['height']) -
          (5 * formData['age']) -
          161; // Konstanta untuk wanita
    }
  }

  /// Menghitung TDEE (Total Daily Energy Expenditure)
  /// TDEE adalah total kalori yang dibakar dalam sehari termasuk aktivitas
  /// [bmr] adalah nilai BMR yang sudah dihitung
  /// [activityLevel] adalah level aktivitas fisik pengguna
  double _calculateTDEE(double bmr, String activityLevel) {
    switch (activityLevel) {
      case 'sedentary': // Sangat jarang olahraga
        return bmr * 1.2;
      case 'light': // Olahraga ringan 1-3x seminggu
        return bmr * 1.375;
      case 'moderate': // Olahraga sedang 3-5x seminggu
        return bmr * 1.55;
      case 'active': // Olahraga berat 6-7x seminggu
        return bmr * 1.725;
      default:
        return bmr * 1.2;
    }
  }

  /// Menyesuaikan target kalori berdasarkan tujuan pengguna
  /// [tdee] adalah nilai TDEE yang sudah dihitung
  /// [goal] adalah tujuan pengguna (turun/naik/maintain berat badan)
  double _adjustCaloriesForGoal(double tdee, String goal) {
    switch (goal) {
      case 'lose': // Turun berat badan: kurangi 500 kalori
        return tdee - 500;
      case 'gain': // Naik berat badan: tambah 500 kalori
        return tdee + 500;
      default: // Maintain berat badan: TDEE tetap
        return tdee;
    }
  }

  Future<void> _saveGoalsToFirestore(UserGoals goals) async {
    await _db
        .collection('users')
        .doc(authC.currentUser.value.id)
        .collection('goals')
        .doc('current')
        .set(goals.toJson());
  }

  Future<void> _refreshGoalsAndProgress() async {
    await fetchUserGoals();
    calculateTodayProgress();
  }

  void _showSuccessMessage() {
    Get.snackbar(
      'Success',
      'Goals updated successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _handleError(dynamic e) {
    print('Error calculating goals: $e');
    Get.snackbar('Error', 'Failed to calculate goals');
  }
}
