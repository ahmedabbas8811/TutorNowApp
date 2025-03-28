import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class QualificationChart extends StatelessWidget {
  const QualificationChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 310,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffebebeb)), // Fixed the issue
        borderRadius: BorderRadius.circular(10), // Moved this out of border
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tutors Qualification',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString(),
                            style: const TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(fontSize: 10);
                        String text;
                        switch (value.toInt()) {
                          case 0:
                            text = 'Under Matric';
                            break;
                          case 1:
                            text = 'Matric';
                            break;
                          case 2:
                            text = 'FSc';
                            break;
                          case 3:
                            text = 'PhD';
                            break;
                          default:
                            text = '';
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(text, style: style),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(toY: 15, color: Colors.black, width: 18)
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                          toY: 75, color: const Color(0xff87e64c), width: 18)
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(toY: 50, color: Colors.black, width: 18)
                    ],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(
                          toY: 70, color: const Color(0xff87e64c), width: 18)
                    ],
                  ),
                ],
                gridData: FlGridData(show: true),
                alignment: BarChartAlignment.spaceAround,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
