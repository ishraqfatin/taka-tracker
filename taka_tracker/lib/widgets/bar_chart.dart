import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class CustomBarChart extends StatefulWidget {
final String jsonData;

const CustomBarChart({super.key, required this.jsonData});

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  // String jsonData = '';

  // @override
  // void initState() {
  //   super.initState();
  //   getData();
  // }
  // String jsonData = '''
  // {
  //   "data": [
  //     {"item": "Food", "price": 23},
  //     {"item": "transport", "price": 45},
  //     {"item": "bills", "price": 200},
  //     {"item": "Movies", "price": 150}
  //   ]
  // }
  // ''';

//   void getData() async {
//   try {
//     String fetchedData = await DatabaseService().mapUserExpenseSnapshotToChartJson();
//     setState(() {
//       jsonData = fetchedData;
//     });
//   } catch (error) {}
// }

  @override
  Widget build(BuildContext context) {

    if (widget.jsonData.isEmpty) {
      return const Center(child: CircularProgressIndicator(),);
    }
    
    Map<String, dynamic> jsonMap = json.decode(widget.jsonData);
    List<dynamic> dataList = jsonMap['data'];

    String getItemAtIndex(int index) {
      if (index >= 0 && index < dataList.length) {
        return dataList[index]['item'];
      } else {
        return 'Index out of range';
      }
    }

  List<BarChartGroupData> getBarChartGroupData() {
    Map<String, int> categoryTotals = {}; // Map to store category totals

    for (int i = 0; i < dataList.length; i++) {
      String item = dataList[i]['item'];
      int? price = dataList[i]['price'] as int?;
      // total price calculation
      if (price != null) {
        if (categoryTotals.containsKey(item)) {
          categoryTotals[item] = (categoryTotals[item] ?? 0) + price;
        } else {
          categoryTotals[item] = price;
        }
      }
    }

    List<BarChartGroupData> barChartGroup = [];

    //category wise bars
    categoryTotals.forEach((item, total) {
      barChartGroup.add(BarChartGroupData(
        showingTooltipIndicators: [0],
        x: barChartGroup.length,
        barRods: [
          BarChartRodData(
            color: Color.fromARGB(255, 49, 231, 119),
            width: 10,
            toY: total.toDouble(),
            backDrawRodData: BackgroundBarChartRodData(
              color: const Color.fromARGB(255, 220, 15, 15),
              toY: 0.500,
              show: false,
            ),
          ),
        ],
      ));
    });

    return barChartGroup;
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
