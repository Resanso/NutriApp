import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/nutrition_entry_model.dart';

class NutritionService {
  static const String apiKey =
      'nRP8v5VJTXMMtYwHrCosOg==lkeUFs3Ej7YxoflS'; // Replace with your actual API key
  static const String baseUrl = 'https://api.calorieninjas.com/v1/nutrition';

  Future<List<FoodItem>> getNutritionInfo(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?query=$query'),
        headers: {'X-Api-Key': apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['items'] as List)
            .map(
              (item) => FoodItem(
                name: item['name'],
                quantity: item['serving_size_g'].toDouble(),
                unit: 'g',
                calories: item['calories'].toDouble(),
                protein: item['protein_g'].toDouble(),
                carbs: item['carbohydrates_total_g'].toDouble(),
                fat: item['fat_total_g'].toDouble(),
              ),
            )
            .toList();
      }
      throw 'Failed to get nutrition info';
    } catch (e) {
      throw 'Error: $e';
    }
  }
}
