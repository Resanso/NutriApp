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

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    'unit': unit,
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
  };

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

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'date': date.toIso8601String(),
    'foods': foods.map((food) => food.toJson()).toList(),
    'total_calories': totalCalories,
  };

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
