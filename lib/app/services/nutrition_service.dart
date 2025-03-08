// ignore_for_file: unintended_html_in_doc_comment

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/nutrition_entry_model.dart';

/// Service untuk mengelola informasi nutrisi makanan
/// Menggunakan API dari CalorieNinjas untuk mendapatkan data nutrisi
class NutritionService {
  /// API key untuk mengakses layanan CalorieNinjas
  static const String apiKey =
      'nRP8v5VJTXMMtYwHrCosOg==lkeUFs3Ej7YxoflS'; // Replace with your actual API key

  /// URL dasar untuk API CalorieNinjas
  static const String baseUrl = 'https://api.calorieninjas.com/v1/nutrition';

  /// Mendapatkan informasi nutrisi berdasarkan query makanan yang diberikan
  ///
  /// [query] adalah nama makanan yang ingin dicari informasi nutrisinya
  ///
  /// Mengembalikan List<FoodItem> yang berisi informasi nutrisi makanan
  /// Throws exception jika terjadi kesalahan dalam mengambil data
  Future<List<FoodItem>> getNutritionInfo(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?query=$query'),
        headers: {'X-Api-Key': apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Mengkonversi data JSON menjadi list objek FoodItem
        return (data['items'] as List)
            .map(
              (item) => FoodItem(
                name: item['name'], // Nama makanan
                quantity:
                    item['serving_size_g']
                        .toDouble(), // Ukuran porsi dalam gram
                unit: 'g', // Satuan berat (gram)
                calories: item['calories'].toDouble(), // Jumlah kalori
                protein: item['protein_g'].toDouble(), // Kandungan protein (g)
                carbs:
                    item['carbohydrates_total_g']
                        .toDouble(), // Kandungan karbohidrat (g)
                fat: item['fat_total_g'].toDouble(), // Kandungan lemak (g)
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
