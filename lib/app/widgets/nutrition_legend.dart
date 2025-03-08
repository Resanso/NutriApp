import 'package:flutter/material.dart';

/// Widget untuk menampilkan legenda nutrisi yang terdiri dari label dan indikator warna
///
/// Widget ini menampilkan sebuah container dengan latar belakang transparan,
/// sebuah titik warna sebagai indikator, dan label teks di sebelahnya
class NutritionLegend extends StatelessWidget {
  /// Teks yang akan ditampilkan sebagai label legenda
  final String label;

  /// Warna yang digunakan untuk indikator dan tema legenda
  final Color color;

  /// Membuat instance baru dari NutritionLegend
  ///
  /// Parameter [label] dan [color] wajib diisi (required)
  const NutritionLegend({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
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
}
