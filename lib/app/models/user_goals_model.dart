class UserGoals {
  final double caloriesGoal;
  final double proteinGoal;
  final double carbsGoal;
  final double fatGoal;
  final DateTime lastUpdated;

  UserGoals({
    required this.caloriesGoal,
    required this.proteinGoal,
    required this.carbsGoal,
    required this.fatGoal,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
    'caloriesGoal': caloriesGoal,
    'proteinGoal': proteinGoal,
    'carbsGoal': carbsGoal,
    'fatGoal': fatGoal,
    'last_updated': lastUpdated.toIso8601String(),
  };

  factory UserGoals.fromJson(Map<String, dynamic> json) {
    try {
      final caloriesGoal =
          json['caloriesGoal'] is int
              ? (json['caloriesGoal'] as int).toDouble()
              : json['caloriesGoal']?.toDouble() ?? 0.0;

      final proteinGoal =
          json['proteinGoal'] is int
              ? (json['proteinGoal'] as int).toDouble()
              : json['proteinGoal']?.toDouble() ?? 0.0;

      final carbsGoal =
          json['carbsGoal'] is int
              ? (json['carbsGoal'] as int).toDouble()
              : json['carbsGoal']?.toDouble() ?? 0.0;

      final fatGoal =
          json['fatGoal'] is int
              ? (json['fatGoal'] as int).toDouble()
              : json['fatGoal']?.toDouble() ?? 0.0;

      return UserGoals(
        caloriesGoal: caloriesGoal,
        proteinGoal: proteinGoal,
        carbsGoal: carbsGoal,
        fatGoal: fatGoal,
        lastUpdated:
            json['last_updated'] != null
                ? DateTime.parse(json['last_updated'])
                : DateTime.now(),
      );
    } catch (e) {
      print('Error parsing UserGoals: $e');
      print('Raw JSON data: $json');
      return UserGoals(
        caloriesGoal: 0.0,
        proteinGoal: 0.0,
        carbsGoal: 0.0,
        fatGoal: 0.0,
        lastUpdated: DateTime.now(),
      );
    }
  }
}
