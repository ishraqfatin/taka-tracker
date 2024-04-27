import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomLineChart extends StatefulWidget {
  const CustomLineChart({super.key});

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
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
        String item = dataList[i]['item'];
        int price = dataList[i]['price'];
        barChartGroup.add(BarChartGroupData(
          x: i,
          barRods: [BarChartRodData(toY: price.toDouble())],
        ));
      }

      return barChartGroup;

      // return [
      //   BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 40)])
      // ];
    }

    return Scaffold(
      body: Center(
        child: AspectRatio(
            aspectRatio: 2.0,
            child: BarChart(BarChartData(
                barGroups: getBarChartGroupData(),
                titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) =>
                      Text(getItemAtIndex(value.toInt())),
                )))))),
      ),
    );
  }
}
