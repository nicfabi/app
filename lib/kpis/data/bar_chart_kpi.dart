import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartKpi extends StatefulWidget {
  final Function fetchData;
  final String title;
  final String x;
  final String y;
  final bool isTopProducts;
  final bool isAnotherTop;
  final bool most;
  final String tipTitle;

  const BarChartKpi(
      {super.key,
      required this.fetchData,
      required this.title,
      required this.x,
      required this.y,
      this.isTopProducts = false,
      this.isAnotherTop = false,
      this.most = true,
      this.tipTitle = "Cantidad"});

  @override
  _BarChartKpiState createState() => _BarChartKpiState();
}

class _BarChartKpiState extends State<BarChartKpi> {
  List<BarChartGroupData> barGroups = [];
  List<Map<String, String>> globalData = [];
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    barGroups = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.isTopProducts && !widget.isAnotherTop) {
        widget
            .fetchData(
          DateTime.now().subtract(const Duration(days: 30)).toString(),
          DateTime.now().toString(),
        )
            .then((data) {
          setState(() {
            globalData = data;
            barGroups = _parseData(data);
          });
        });
        return;
      } else if (widget.isAnotherTop) {
        widget.fetchData().then((data) {
          setState(() {
            globalData = data;
            barGroups = _parseData(data);
          });
        });
        return;
      }
      widget.fetchData(widget.most).then((data) {
        setState(() {
          globalData = data;
          barGroups = _parseData(data);
        });
      });
    });
  }

  void updateChart(List<BarChartGroupData> data) {
    setState(() {
      barGroups = data;
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
                !widget.isTopProducts ||
                        (!widget.isAnotherTop && !widget.isTopProducts)
                    ? IconButton(
                        icon: const Icon(Icons.date_range),
                        onPressed: () => _selectDateRange(context),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: barGroups.isNotEmpty
                  ? BarChart(
                      BarChartData(
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(
                          show: true,
                          border: const Border(
                            bottom: BorderSide(
                              color: Color.fromARGB(255, 52, 9,
                                  77), // Set the color of the bottom border
                              width: 2, // Set the width of the bottom border
                            ),
                            left: BorderSide.none,
                            right: BorderSide.none,
                            top: BorderSide.none,
                          ),
                        ),
                        maxY: globalData
                                .map((e) => double.tryParse(e[widget.y]!) ?? 0)
                                .reduce((value, element) =>
                                    value > element ? value : element) +
                            2,
                        barTouchData: BarTouchData(
                          touchCallback: (FlTouchEvent event,
                              BarTouchResponse? barTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  barTouchResponse == null ||
                                  barTouchResponse.spot == null) {
                                _touchedIndex = -1;
                                return;
                              }
                              _touchedIndex =
                                  barTouchResponse.spot!.touchedBarGroupIndex;
                            });
                          },
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (group) =>
                                const Color.fromARGB(255, 83, 82, 84),
                            tooltipPadding: const EdgeInsets.all(10),
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                "${_convertLabel(globalData[_touchedIndex][widget.x] ?? "N/A", alwaysShow: false)}\n",
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        "Cantidad: ${rod.toY.round().toString()}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        barGroups: barGroups,
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              reservedSize: 50,
                              showTitles: true,
                              getTitlesWidget: _getBottomTitles,
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                      ),
                    )
                  : const Center(child: Text("No data available")),
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

  List<BarChartGroupData> _parseData(List<Map<String, String>> data) {
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i][widget.y] != null && data[i][widget.y]!.isNotEmpty) {
        double? quantity = double.tryParse(data[i][widget.y]!);
        if (quantity != null) {
          barGroups.add(BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: quantity,
              ),
            ],
            showingTooltipIndicators:
                _touchedIndex != -1 ? [_touchedIndex] : [],
          ));
        }
      }
    }
    return barGroups;
  }

  String _convertLabel(String label, {bool alwaysShow = true}) {
    try {
      if (alwaysShow) {
        if (label.length < 4) {
          return label.toUpperCase();
        }
        return label.substring(0, 3).toUpperCase();
      }
      if (label.length > 20) {
        return "${label.substring(0, 20)} ...";
      }
      return label;
    } catch (e) {
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
        child: Text(
          _convertLabel(label),
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
