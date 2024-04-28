import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomBarChart extends StatefulWidget {
  const CustomBarChart({super.key});

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  String jsonData = '''
  {
    "data": [
      {"item": "Food", "price": 23},
      {"item": "transport", "price": 45},
      {"item": "bills", "price": 200},
      {"item": "Movies", "price": 150}
    ]
  }
  ''';

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> jsonMap = json.decode(jsonData);
    List<dynamic> dataList = jsonMap['data'];

    String getItemAtIndex(int index) {
      if (index >= 0 && index < dataList.length) {
        return dataList[index]['item'];
      } else {
        return 'Index out of range';
      }
    }

    List<BarChartGroupData> getBarChartGroupData() {
      List<BarChartGroupData> barChartGroup = [];

      for (int i = 0; i < dataList.length; i++) {
        // String item = dataList[i]['item'];
        int price = dataList[i]['price'];
        barChartGroup.add(BarChartGroupData(
          showingTooltipIndicators: [0],
          x: i,
          barRods: [
            BarChartRodData(
                color: Color.fromARGB(255, 49, 231, 119),
                width: 10,
                toY: price.toDouble(),
                backDrawRodData: BackgroundBarChartRodData(
                    color: const Color.fromARGB(255, 220, 15, 15),
                    toY: 0.500,
                    show: false))
          ],
        ));
      }

      return barChartGroup;

      // return [
      //   BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 40)])
      // ];
    }

    double getMaxY() {
      return 250.0;
    }

    return Container(
      color: const Color.fromARGB(0, 244, 67, 54),
      child: Center(
        child: AspectRatio(
            aspectRatio: 2.0,
            child: BarChart(BarChartData(
                // maxY: getMaxY(),
                barTouchData: BarTouchData(
                  enabled: false,
                  touchTooltipData: BarTouchTooltipData(
                      tooltipPadding: EdgeInsets.zero,
                      tooltipMargin: 8,
                      getTooltipColor: (group) => Colors.transparent),
                ),
                alignment: BarChartAlignment.spaceEvenly,
                barGroups: getBarChartGroupData(),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => Text(
                      getItemAtIndex(value.toInt()),
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                gridData: const FlGridData(show: false)))),
      ),
    );
  }
}
