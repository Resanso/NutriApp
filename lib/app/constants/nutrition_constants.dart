/// Kelas yang berisi konstanta-konstanta untuk perhitungan nutrisi
// ignore_for_file: constant_identifier_names, dangling_library_doc_comments

class NutritionConstants {
  /// Rasio protein yang direkomendasikan (30% dari total kalori)
  static const double PROTEIN_RATIO = 0.3;

  /// Rasio karbohidrat yang direkomendasikan (40% dari total kalori)
  static const double CARBS_RATIO = 0.4;

  /// Rasio lemak yang direkomendasikan (30% dari total kalori)
  static const double FAT_RATIO = 0.3;

  /// Jumlah kalori per gram protein
  static const double CALORIES_PER_GRAM_PROTEIN = 4;

  /// Jumlah kalori per gram karbohidrat
  static const double CALORIES_PER_GRAM_CARBS = 4;

  /// Jumlah kalori per gram lemak
  static const double CALORIES_PER_GRAM_FAT = 9;

  /// Faktor pengali kalori berdasarkan tingkat aktivitas
  ///
  /// Keterangan:
  /// - sedentary: Gaya hidup tidak aktif/jarang bergerak
  /// - light: Aktivitas ringan (1-3 hari olahraga/minggu)
  /// - moderate: Aktivitas sedang (3-5 hari olahraga/minggu)
  /// - active: Aktivitas berat (6-7 hari olahraga/minggu)
  static const Map<String, double> ACTIVITY_MULTIPLIERS = {
    'sedentary': 1.2,
    'light': 1.375,
    'moderate': 1.55,
    'active': 1.725,
  };
}
