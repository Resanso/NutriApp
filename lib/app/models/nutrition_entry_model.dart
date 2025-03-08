/// Model untuk menyimpan informasi item makanan
/// Berisi detail nutrisi seperti kalori, protein, karbohidrat, dan lemak
// ignore_for_file: avoid_print, dangling_library_doc_comments

class FoodItem {
  final String name;
  final double quantity;
  final String unit;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  FoodItem({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  /// Mengubah object FoodItem menjadi Map untuk keperluan penyimpanan data
  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    'unit': unit,
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
  };

  /// Membuat object FoodItem dari data Map
  /// [json] adalah Map yang berisi data makanan
  /// Return object FoodItem dengan nilai default jika data tidak tersedia
  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'] ?? '',
      quantity: (json['quantity'] ?? 0.0).toDouble(),
      unit: json['unit'] ?? 'g',
      calories: (json['calories'] ?? 0.0).toDouble(),
      protein: (json['protein'] ?? 0.0).toDouble(),
      carbs: (json['carbs'] ?? 0.0).toDouble(),
      fat: (json['fat'] ?? 0.0).toDouble(),
    );
  }
}

/// Model untuk menyimpan catatan makanan harian pengguna
/// Berisi daftar makanan yang dikonsumsi dan total kalori dalam satu hari
class DailyEntry {
  final String userId;
  final DateTime date;
  final List<FoodItem> foods;
  final double totalCalories;

  DailyEntry({
    required this.userId,
    required this.date,
    required this.foods,
    required this.totalCalories,
  });

  /// Mengubah object DailyEntry menjadi Map untuk keperluan penyimpanan data
  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'date': date.toIso8601String(),
    'foods': foods.map((food) => food.toJson()).toList(),
    'total_calories': totalCalories,
  };

  /// Membuat object DailyEntry dari data Map
  /// [json] adalah Map yang berisi data catatan harian
  /// Return object DailyEntry kosong jika terjadi kesalahan parsing data
  factory DailyEntry.fromJson(Map<String, dynamic> json) {
    try {
      return DailyEntry(
        userId: json['user_id'] ?? '',
        date:
            json['date'] != null
                ? DateTime.parse(json['date'])
                : DateTime.now(),
        foods:
            (json['foods'] as List?)
                ?.map((food) => FoodItem.fromJson(food))
                .toList() ??
            [],
        totalCalories: (json['total_calories'] ?? 0.0).toDouble(),
      );
    } catch (e) {
      print('Error parsing DailyEntry: $e');
      // Return empty entry if parsing fails
      return DailyEntry(
        userId: '',
        date: DateTime.now(),
        foods: [],
        totalCalories: 0.0,
      );
    }
  }
}
