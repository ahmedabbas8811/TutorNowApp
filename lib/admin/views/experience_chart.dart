import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/dashboard_controller.dart';

class ExperienceChart extends StatefulWidget {
  const ExperienceChart({super.key});

  @override
  State<ExperienceChart> createState() => _ExperienceChartState();
}

class _ExperienceChartState extends State<ExperienceChart> {
  final DashboardController _controller = DashboardController();
  late Future<List<int>> _experienceData;

  @override
  void initState() {
    super.initState();
    _experienceData = _loadExperienceData();
  }

  Future<List<int>> _loadExperienceData() async {
    final experience = await _controller.fetchTutorExperience();
    return experience.toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: _experienceData,
      builder: (context, snapshot) {
        final data = snapshot.data ?? List.filled(8, 0);
        final maxY = data.isNotEmpty ? data.reduce((a, b) => a > b ? a : b).toDouble() : 100.0;
        final interval = _calculateInterval(maxY);

        return Container(
          width: 820,
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
                    minY: 0,
                    maxY: maxY + interval,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.transparent,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            data[groupIndex].toString(),
                            const TextStyle(
                              color: Colors.black, // Always black for clear visibility
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: interval,
                          reservedSize: 45,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const style = TextStyle(fontSize: 12);
                            String text;
                            switch (value.toInt()) {
                              case 0: text = '0-2 Y'; break;
                              case 1: text = '3-4 Y'; break;
                              case 2: text = '5-6 Y'; break;
                              case 3: text = '7-8 Y'; break;
                              case 4: text = '9-10 Y'; break;
                              case 5: text = '<15 Y'; break;
                              case 6: text = '<20 Y'; break;
                              case 7: text = '>25 Y'; break;
                              default: text = '';
                            }
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(text, style: style),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(data.length, (index) {
                      final isZero = data[index] == 0;
                      final barColor = index % 2 == 0 
                          ? Colors.black 
                          : const Color(0xff87e64c);
                      final barHeight = isZero 
                          ? 0.1 // Small but visible height
                          : data[index].toDouble();

                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: barHeight,
                            color: barColor,
                            width: 18,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      );
                    }),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withOpacity(0.5),
                          strokeWidth: 1.2,
                        );
                      },
                    ),
                    alignment: BarChartAlignment.spaceAround,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _calculateInterval(double maxY) {
    if (maxY <= 10) return 1.0;
    if (maxY <= 20) return 2.0;
    if (maxY <= 50) return 5.0;
    if (maxY <= 100) return 10.0;
    return (maxY / 5).roundToDouble();
  }
}