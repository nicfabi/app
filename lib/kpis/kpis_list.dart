import 'package:app/kpis/data/bar_chart_kpi.dart';
import 'package:app/kpis/data/kpi_text_field.dart';
import 'package:app/kpis/data/line_chart_kpi.dart';
import 'package:app/kpis/kpis_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KpisList extends StatefulWidget {
  const KpisList({super.key});

  @override
  State<KpisList> createState() => _KpisListState();
}

class _KpisListState extends State<KpisList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas y KPIs',
            style: TextStyle(color: Color(0xFFFAFAFA))),
        backgroundColor: const Color(0xFF09184D),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: const [
            // Line chart KPI
            LineChartKpi(
                fetchData: KpisService.fetchSoldAmount,
                title: 'Ventas',
                x: 'date',
                y: 'total'),
            SizedBox(height: 16),
            KpiTextField(
                fetchData: KpisService.fetchAvgTransactionSize,
                title: 'ATS',
                icon: Icons.shopping_cart_rounded),
            SizedBox(height: 16),
            BarChartKpi(
                fetchData: KpisService.fetchProductsByDate,
                title: "Productos",
                x: "name",
                y: "quantity"),
            SizedBox(height: 16),
            KpiTextField(
              fetchData: KpisService.fetchSalesGrowth,
              title: 'Crecimiento en ventas',
              icon: Icons.trending_up_rounded,
              iconNegative: Icons.trending_down_rounded,
              isDate: true,
            ),
            // Bar chart KPI
          ],
        ),
      ),
    );
  }
}
