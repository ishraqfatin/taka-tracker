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
 
  @override
  Widget build(BuildContext context) {

    if (widget.jsonData.isEmpty) {
      return const Center(child: CircularProgressIndicator(),);
    }
    
    Map<String, dynamic> jsonMap = json.decode(widget.jsonData);
    List<dynamic> dataList = jsonMap['data'];

    String getItemAtIndex(int index) {
      if (index >= 0 && index < dataList.length) {
        return dataList[index]['category'];
      } else {
        return 'Index out of range';
      }
    }



    IconData getCategoryIcon(int index) {
      IconData iconData = Icons.error;
      String category = dataList[index]['category']!;

      switch (category) {
        case 'food':
          iconData = Icons.lunch_dining;
          break;
        case 'travel':
          iconData = Icons.emoji_transportation;
          break;
        case 'bills':
          iconData = Icons.receipt_long;
          break;
        case 'shopping':
          iconData = Icons.shopping_bag;
          break;
        default:
          break;
      }

      return iconData;
    }

  List<BarChartGroupData> getBarChartGroupData() {
    Map<String, int> categoryTotals = {}; // Map to store category totals

    for (int i = 0; i < dataList.length; i++) {
      String category = dataList[i]['category'];
      int? price = dataList[i]['price'] as int?;
      // total price calculation
      if (price != null) {
        if (categoryTotals.containsKey(category)) {
          categoryTotals[category] = (categoryTotals[category] ?? 0) + price;
        } else {
          categoryTotals[category] = price;
        }
      }
    }

    List<BarChartGroupData> barChartGroup = [];

    //category wise bars
    categoryTotals.forEach((category, total) {
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
                          getTitlesWidget: (value, meta) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  getCategoryIcon(value.toInt()),
                                  color: Colors.white,
                                ),
                              )
                          //     Text(
                          //   getItemAtIndex(value.toInt()),
                          //   style: TextStyle(color: Colors.white),
                          // ),
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
