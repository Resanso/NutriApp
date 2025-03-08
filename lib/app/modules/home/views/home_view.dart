// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutri_app/app/models/nutrition_entry_model.dart';
import '../controllers/home_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../widgets/radial_progress.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/text_styles.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    // Membangun tampilan utama aplikasi
    return Scaffold(
      // Mengatur warna latar belakang menjadi abu-abu muda
      backgroundColor: Colors.grey[50],

      // Tombol floating untuk menambah makanan baru
      // Ketika ditekan akan menampilkan bottom sheet input makanan
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFoodBottomSheet(context);
        },
        backgroundColor: const Color(0xFF8BC34A),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      // Membangun app bar dengan fungsi terpisah
      appBar: _buildAppBar(authC),

      // Konten utama dengan scroll vertikal
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Widget untuk menampilkan progress nutrisi dalam bentuk diagram
            _buildProgressCard(),
            _buildSectionTitle('Recent Foods'),
            _buildTodayEntries(),
            _buildSectionTitle('History'),
            _buildHistorySection(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AuthController authC) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(8),
              color: const Color(0xFF8BC34A).withOpacity(0.1),
              child: const Icon(
                Icons.restaurant_menu,
                color: Color(0xFF8BC34A),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Nutrition Tracker',
            style: AppTextStyles.heading1.copyWith(
              color: const Color(0xFF2B3A4A),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => authC.logout(),
          icon: const Icon(Icons.logout_rounded, color: Color(0xFF2B3A4A)),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2B3A4A),
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Obx(() {
      if (controller.userGoals.value == null) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Loading goals...',
              style: TextStyle(fontSize: 18, color: AppColors.textLight),
            ),
          ),
        );
      }
      return Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: Get.width * 0.9, // 90% of screen width
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Today\'s Progress',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    IconButton(
                      onPressed:
                          () => controller.showGoalsQuestionnaireDialog(),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      tooltip: 'Update Goals',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 220,
                  width: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      NutritionRadialProgress(
                        title: '',
                        progress: controller.todayProgress['calories'] ?? 0.0,
                        color: AppColors.calories,
                        radius: 100,
                        thickness: 12,
                        showPercentage: false,
                      ),
                      NutritionRadialProgress(
                        title: '',
                        progress: controller.todayProgress['protein'] ?? 0.0,
                        color: AppColors.protein,
                        radius: 80,
                        thickness: 12,
                        showPercentage: false,
                      ),
                      NutritionRadialProgress(
                        title: '',
                        progress: controller.todayProgress['carbs'] ?? 0.0,
                        color: AppColors.carbs,
                        radius: 60,
                        thickness: 12,
                        showPercentage: false,
                      ),
                      NutritionRadialProgress(
                        title: '',
                        progress: controller.todayProgress['fat'] ?? 0.0,
                        color: AppColors.fat,
                        radius: 40,
                        thickness: 12,
                        showPercentage: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildLegendItem('Calories', AppColors.calories),
                    _buildLegendItem('Protein', AppColors.protein),
                    _buildLegendItem('Carbs', AppColors.carbs),
                    _buildLegendItem('Fat', AppColors.fat),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _showAddFoodBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Food',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B3A4A),
                  ),
                ),
                const SizedBox(height: 16),
                _buildFoodInputSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  Widget _buildFoodInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller.foodInputController,
          decoration: InputDecoration(
            labelText: 'Enter food items',
            hintText: 'e.g., 100g rice, 200g chicken',
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: Obx(
              () =>
                  controller.isLoading.value
                      ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          await controller.calculateNutrition();
                          if (controller.foodItems.isNotEmpty) {
                            Navigator.pop(
                              Get.context!,
                            ); // Close bottom sheet after successful addition
                          }
                        },
                      ),
            ),
          ),
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildTodayEntries() {
    return Obx(
      () =>
          controller.foodItems.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.foodItems.length,
                itemBuilder: (context, index) {
                  final food = controller.foodItems[index];
                  return Dismissible(
                    key: Key(food.name),
                    background: Container(
                      color: Colors.red[400],
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {},
                    child: Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[200]!),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFF8BC34A).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.restaurant,
                                color: Color(0xFF8BC34A),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    food.name.capitalize!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${food.calories.toStringAsFixed(0)} kcal • ${food.protein.toStringAsFixed(1)}g protein',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.restaurant_menu, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No foods added yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first meal',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 300,
        child: Obx(
          () =>
              controller.userHistory.isEmpty
                  ? Center(
                    child: Text(
                      'No history available',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  )
                  : ListView.builder(
                    itemCount: controller.userHistory.length,
                    itemBuilder: (context, index) {
                      final entry = controller.userHistory[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0.5,
                        child: Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            title: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF2196F3,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.calendar_today,
                                    color: Color(0xFF2196F3),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  entry.date.toString().substring(0, 10),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(left: 40, top: 4),
                              child: Text(
                                '${entry.totalCalories.toStringAsFixed(0)} kcal total',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                  onPressed:
                                      () => _showEditDialog(context, entry),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                  onPressed:
                                      () => _showDeleteConfirmation(entry),
                                ),
                              ],
                            ),
                            children:
                                entry.foods
                                    .map(
                                      (food) => ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 4,
                                            ),
                                        leading: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF8BC34A,
                                            ).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.restaurant,
                                            color: Color(0xFF8BC34A),
                                            size: 20,
                                          ),
                                        ),
                                        title: Text(
                                          food.name.capitalize!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Cal: ${food.calories.toStringAsFixed(0)} • P: ${food.protein.toStringAsFixed(1)}g • C: ${food.carbs.toStringAsFixed(1)}g • F: ${food.fat.toStringAsFixed(1)}g',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(DailyEntry entry) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Entry?'),
        content: const Text(
          'This action cannot be undone. Do you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteHistoryEntry(entry);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, DailyEntry entry) {
    final editedFoods = entry.foods.map((f) => f).toList();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: Get.height * 0.8, // 80% of screen height
            maxWidth: Get.width * 0.9, // 90% of screen width
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Entry',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          entry.date.toString().substring(0, 10),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // List of Foods
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: editedFoods.length,
                    itemBuilder: (context, index) {
                      final food = editedFoods[index];
                      final nameController = TextEditingController(
                        text: food.name,
                      );
                      final quantityController = TextEditingController(
                        text: food.quantity.toString(),
                      );

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey[200]!),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Food Name Input
                              TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  labelText: 'Food Name',
                                  prefixIcon: Container(
                                    margin: const EdgeInsets.all(8),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF8BC34A,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.restaurant,
                                      color: Color(0xFF8BC34A),
                                      size: 20,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Quantity Input
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: quantityController,
                                      decoration: InputDecoration(
                                        labelText: 'Quantity',
                                        suffixText: 'g',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final quantity =
                                          double.tryParse(
                                            quantityController.text,
                                          ) ??
                                          0.0;
                                      if (quantity <= 0) {
                                        Get.snackbar(
                                          'Error',
                                          'Invalid quantity',
                                        );
                                        return;
                                      }

                                      final updatedFood = await controller
                                          .updateFoodNutrition(
                                            nameController.text,
                                            quantity,
                                          );

                                      if (updatedFood != null) {
                                        editedFoods[index] = updatedFood;
                                        (context as Element).markNeedsBuild();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF8BC34A),
                                      padding: const EdgeInsets.all(12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Icon(Icons.refresh, size: 20),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Nutrition Info
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Cal: ${food.calories.toStringAsFixed(0)} kcal',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      'P: ${food.protein.toStringAsFixed(1)}g',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      'C: ${food.carbs.toStringAsFixed(1)}g',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      'F: ${food.fat.toStringAsFixed(1)}g',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Delete Button
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () => editedFoods.removeAt(index),
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.red[400],
                                    size: 20,
                                  ),
                                  label: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red[400]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Action Buttons
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                        if (editedFoods.isEmpty) {
                          controller.deleteHistoryEntry(entry);
                        } else {
                          controller.editHistoryEntry(entry, editedFoods);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8BC34A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
