import 'package:app/helper/month.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartKpi extends StatefulWidget {
  final Function fetchData;
  final String title;
  final String x;
  final String y;
  const LineChartKpi(
      {super.key,
      required this.fetchData,
      required this.title,
      required this.x,
      required this.y});

  @override
  _LineChartKpiState createState() => _LineChartKpiState();
}

class _LineChartKpiState extends State<LineChartKpi> {
  List<FlSpot> spots = [];
  List<Map<String, String>> globalData = [];

  @override
  void initState() {
    super.initState();
    spots = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget
          .fetchData(
        DateTime.now().subtract(const Duration(days: 30)).toString(),
        DateTime.now().toString(),
      )
          .then((data) {
        setState(() {
          globalData = data;
          spots = _parseData(data);
          print(spots);
        });
      });
    });
  }

  void updateChart(List<FlSpot> data) {
    setState(() {
      spots = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      height: 300,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 52, 9, 77),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.date_range),
                  onPressed: () => _selectDateRange(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: spots.isNotEmpty
                  ? LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: globalData.length.toDouble() - 1,
                        minY: 0,
                        maxY: globalData
                                .map((e) => double.tryParse(e[widget.y]!) ?? 0)
                                .reduce((value, element) =>
                                    value > element ? value : element) +
                            20000,
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: false,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(show: true),
                          ),
                        ],
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              reservedSize: 50,
                              showTitles: true,
                              getTitlesWidget: _getBottomTitles,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              reservedSize: 50,
                              showTitles: true,
                              getTitlesWidget: _getLeftTitles,
                            ),
                          ),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                      ),
                    )
                  : Center(child: Text("No data available")),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final data = await widget.fetchData(
        picked.start.toString(),
        picked.end.toString(),
      );
      if (data.isNotEmpty) {
        globalData = data;
      }
      updateChart(_parseData(data));
    }
  }

  List<FlSpot> _parseData(List<Map<String, String>> data) {
    List<FlSpot> spots = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i][widget.y] != null && data[i][widget.y]!.isNotEmpty) {
        double? amount = double.tryParse(data[i][widget.y]!);
        if (amount != null) {
          spots.add(FlSpot(i.toDouble(), amount));
        }
      }
    }
    return spots;
  }

  String _convertDate(String date) {
    try {
      DateTime dateTime = DateTime.parse(date);
      int month = dateTime.month;
      return "${dateTime.day} ${getMonth(month)}";
    } catch (e) {
      print("ERROR WHILE PARSING DATE: $e");
      return "N/A";
    }
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    try {
      if (value % 1 != 0) {
        return const SizedBox.shrink();
      }

      if (value < 0 ||
          value >= globalData.length ||
          globalData[value.toInt()][widget.x] == null) {
        return const SizedBox.shrink();
      }

      String label = globalData[value.toInt()][widget.x] ?? "N/A";
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 20,
        child: Transform.rotate(
          angle: -1.5708,
          child: Text(
            widget.x == "date" ? _convertDate(label) : label,
            style: const TextStyle(
                color: Color.fromARGB(255, 52, 9, 77),
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
    } catch (e) {
      print("ERROR WHILE PARSING TITLE: $e");
      return Container();
    }
  }

  Widget _getLeftTitles(double value, TitleMeta meta) {
    try {
      print(value);
      if (value % 1 != 0) {
        return const SizedBox.shrink();
      }

      String label = value.toInt().toString();
      if (value.toInt() / 1000 >= 1) {
        label = "${value.toInt() ~/ 1000}K";
      }
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        child: Text(
          label,
          style: const TextStyle(
              color: Color.fromARGB(255, 52, 9, 77),
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
      );
    } catch (e) {
      print("ERROR WHILE PARSING TITLE: $e");
      return Container();
    }
  }
}
