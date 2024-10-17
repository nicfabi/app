import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartKpi extends StatefulWidget {
  final Function fetchData;
  final String title;
  final String x;
  final String y;
  const PieChartKpi({
    super.key,
    required this.fetchData,
    required this.title,
    required this.x,
    required this.y,
  });

  @override
  _PieChartKpiState createState() => _PieChartKpiState();
}

class _PieChartKpiState extends State<PieChartKpi> {
  List<PieChartSectionData> pieSections = [];
  List<Map<String, String>> globalData = [];
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    pieSections = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.fetchData().then((data) {
        setState(() {
          globalData = data;
          pieSections = _parseData(data);
        });
      });
    });
  }

  void updateChart(List<PieChartSectionData> data) {
    setState(() {
      pieSections = data;
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
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: pieSections.isNotEmpty
                        ? PieChart(
                            PieChartData(
                              borderData: FlBorderData(
                                show: true,
                                border: const Border(
                                  bottom: BorderSide(
                                    color: Color.fromARGB(255, 52, 9, 77),
                                    width: 2,
                                  ),
                                  left: BorderSide.none,
                                  right: BorderSide.none,
                                  top: BorderSide.none,
                                ),
                              ),
                              pieTouchData: PieTouchData(
                                touchCallback: (FlTouchEvent event,
                                    PieTouchResponse? barTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        barTouchResponse == null ||
                                        barTouchResponse.touchedSection ==
                                            null) {
                                      _touchedIndex = -1;
                                      return;
                                    }
                                    _touchedIndex = barTouchResponse
                                        .touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              sectionsSpace: 0,
                              centerSpaceRadius: 40,
                              sections: _parseData(globalData),
                            ),
                          )
                        : const Center(child: Text("No data available")),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _getTitles(),
                ),
                SizedBox(
                  width: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRandomColor(int i, Random random) {
    double hue = (i * 137.5) % 360;
    return HSLColor.fromAHSL(1.0, hue, 0.5, 0.6).toColor();
  }

  List<Widget> _getTitles() {
    List<Widget> titles = [];
    for (int i = 0; i < pieSections.length; i++) {
      titles.add(
        Row(
          children: [
            Container(
              width: 15,
              height: 15,
              color: pieSections[i].color,
            ),
            const SizedBox(width: 5),
            Text(_convertLabel(globalData[i][widget.x] ?? "N/A"),
                style: const TextStyle(
                    color: Color.fromARGB(255, 52, 9, 77),
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }
    return titles;
  }

  List<PieChartSectionData> _parseData(List<Map<String, String>> data) {
    List<PieChartSectionData> pieSections = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i][widget.y] != null && data[i][widget.y]!.isNotEmpty) {
        pieSections.add(PieChartSectionData(
          color: _getRandomColor(i, Random()),
          value: double.tryParse(data[i][widget.y]!) ?? 0,
          title:
              "${(double.tryParse(data[i][widget.y]!) ?? 0).toStringAsFixed(1)}%",
          radius: 40,
          titleStyle: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ));
      }
    }
    return pieSections;
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
}
