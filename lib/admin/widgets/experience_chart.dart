import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExperienceChart extends StatelessWidget {
  const ExperienceChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 620,
      height: 310,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffebebeb)),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tutors Experience',
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
                          case 0: text = '0 Y'; break;
                          case 1: text = '1-2 Y'; break;
                          case 2: text = '3-4 Y'; break;
                          case 3: text = '5-6 Y'; break;
                          case 4: text = '7-8 Y'; break;
                          case 5: text = '9-10 Y'; break;
                          case 6: text = '<15 Y'; break;
                          case 7: text = '<20 Y'; break;
                          case 8: text = '>25 Y'; break;
                          default: text = '';
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
                    barRods: [BarChartRodData(toY: 10, color: Colors.black, width: 18)]
                  ),
                  BarChartGroupData(
                    x: 1, 
                    barRods: [BarChartRodData(toY: 75, color: const Color(0xff87e64c), width: 18)]
                  ),
                  BarChartGroupData(
                    x: 2, 
                    barRods: [BarChartRodData(toY: 50, color: Colors.black, width: 18)]
                  ),
                  BarChartGroupData(
                    x: 3, 
                    barRods: [BarChartRodData(toY: 70, color: const Color(0xff87e64c), width: 18)]
                  ),
                  BarChartGroupData(
                    x: 4, 
                    barRods: [BarChartRodData(toY: 45, color: Colors.black, width: 18)]
                  ),
                  BarChartGroupData(
                    x: 5, 
                    barRods: [BarChartRodData(toY: 30, color: const Color(0xff87e64c), width: 18)]
                  ),
                  BarChartGroupData(
                    x: 6, 
                    barRods: [BarChartRodData(toY: 40, color: Colors.black, width: 18)]
                  ),
                  BarChartGroupData(
                    x: 7, 
                    barRods: [BarChartRodData(toY: 25, color: const Color(0xff87e64c), width: 18)]
                  ),
                  BarChartGroupData(
                    x: 8, 
                    barRods: [BarChartRodData(toY: 5, color: Colors.black, width: 18)]
                  ),
                ],
                gridData: FlGridData(show: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}