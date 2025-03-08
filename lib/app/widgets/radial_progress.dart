import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Widget untuk menampilkan progress dalam bentuk lingkaran (radial)
/// yang biasa digunakan untuk visualisasi nutrisi
class NutritionRadialProgress extends StatelessWidget {
  /// Judul atau label dari progress
  final String title;

  /// Nilai progress dalam bentuk desimal (0.0 - 1.0)
  final double progress;

  /// Warna yang digunakan untuk progress bar
  final Color color;

  /// Radius atau jari-jari dari lingkaran dalam pixel
  final double radius;

  /// Ketebalan dari progress bar dalam pixel
  final double thickness;

  /// Menentukan apakah persentase ditampilkan di tengah lingkaran
  final bool showPercentage;

  /// Menentukan apakah menggunakan latar belakang
  final bool useBackground;

  /// Constructor untuk NutritionRadialProgress
  ///
  /// [title] : Label yang ditampilkan
  /// [progress] : Nilai progress (0.0 - 1.0)
  /// [color] : Warna progress bar
  /// [radius] : Ukuran jari-jari lingkaran
  /// [thickness] : Ketebalan garis progress
  /// [showPercentage] : Opsi menampilkan persentase
  /// [useBackground] : Opsi menggunakan background
  const NutritionRadialProgress({
    super.key,
    required this.title,
    required this.progress,
    required this.color,
    required this.radius,
    required this.thickness,
    this.showPercentage = true,
    this.useBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: radius * 2,
      width: radius * 2,
      child: SfCircularChart(
        margin: EdgeInsets.zero,
        annotations:
            showPercentage
                ? [
                  CircularChartAnnotation(
                    widget: Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: radius * 0.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]
                : null,
        series: <CircularSeries>[
          RadialBarSeries<_ChartData, String>(
            dataSource: [_ChartData('Progress', progress * 100)],
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.y,
            cornerStyle: CornerStyle.bothFlat,
            gap: '0%',
            radius: '100%',
            innerRadius: '${100 - (thickness / radius * 100)}%',
            maximumValue: 100,
            pointColorMapper: (_, __) => color,
          ),
        ],
      ),
    );
  }
}

/// Class helper untuk menyimpan data chart
class _ChartData {
  _ChartData(this.x, this.y);

  /// Label pada sumbu X
  final String x;

  /// Nilai pada sumbu Y
  final double y;
}
