import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartKpi extends StatefulWidget {
  const LineChartKpi({super.key});

  @override
  _LineChartKpiState createState() => _LineChartKpiState();
}

class _LineChartKpiState extends State<LineChartKpi> {
  List<FlSpot> spots = [];

  @override
  void initState() {
    super.initState();
    // Optionally, you can load data on init or after date selection
  }

  void updateChart(List<FlSpot> data) {
    setState(() {
      spots = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: spots.isNotEmpty
          ? LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: true),
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        DateTime date =
                            DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        return Text('${date.day}/${date.month}');
                      },
                    ),
                  ),
                ),
              ),
            )
          : Center(child: Text("No data available")),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      // Fetch data for the selected date range
      final data = await fetchDataFromBackend(picked.start, picked.end);
      updateChart(data);
    }
  }
}
