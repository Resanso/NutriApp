import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NutritionRadialProgress extends StatelessWidget {
  final String title;
  final double progress;
  final Color color;
  final double radius;
  final double thickness;
  final bool showPercentage;
  final bool useBackground;

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

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}
