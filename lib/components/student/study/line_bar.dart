import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/models/TestMarkModel.dart';
import 'package:intl/intl.dart';

class LineBar extends ConsumerStatefulWidget {
  final List<TestMarkModel> test_marks;
  const LineBar({required this.test_marks, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LineBarState();
}

class _LineBarState extends ConsumerState<LineBar> {
  final List<Color> gradientColors = [
    Colors.green,
    Colors.orange
  ];
  final first = DateTime(1990, 0, 0);
  List<FlSpot> spots = [];
  double minX = 0;
  double maxX = 0;

  void initState(){
    super.initState();
    for(var i = 0; i < widget.test_marks.length; i++) {
      double v = widget.test_marks[i].date.difference(first).inDays.toDouble();
      spots.add(FlSpot(v, widget.test_marks[i].point));

      if (i == 0) {
        minX = v;
        maxX = v;
      }
      else {
        if (minX > v) {
          minX = v;
        }
        if (maxX < v) {
          maxX = v;
        }
      }
    }

    if (widget.test_marks.length == 1) {
      minX -= 5;
      maxX += 5;
    }
  }


  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: 0,
        maxY: 10,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: LinearGradient(
              colors: gradientColors,
            ),
            barWidth: 5,
            isStrokeCapRound: true,
            // dotData: FlDotData(
            //   show: false,
    
            // ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              ),
            ),
          )
        ],
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: bottomTitleWidgets,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: leftTitleWidgets,
              // reservedSize: 42,
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[300],
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey[300],
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey[300]!, width: 1)
        )
      ),
      swapAnimationDuration: Duration(milliseconds: 150),
      swapAnimationCurve: Curves.linear,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w500,
      // fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 2:
        text = '2';
        break;
      case 4:
        text = '4';
        break;
      case 6:
        text = '6';
        break;
      case 8:
        text = '8';
        break;
      case 10:
        text = '10';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );
    Widget text;

    double distanceDay = (maxX - minX) / 4;

    if ((maxX - minX) <= 8) {
      final index = spots.indexWhere((e) => e.x == value);
      if (index >= 0) {
        final date = DateTime(1990, 0, spots[index].x.toInt());
        text = Text(DateFormat("dd/MM").format(date), style: style);
      }
      else {
        text = const Text('', style: style);
      }
    }
    else {
      // print({maxX, minX, value.toInt(), distanceDay.toInt()});
      if (value.toInt() ==  (minX + distanceDay).toInt() || value.toInt() == (minX + distanceDay * 2).toInt()
        || value.toInt() == (minX + distanceDay * 3).toInt()) {
        final date = DateTime(1990, 0, value.toInt());
        text = Text(DateFormat("dd/MM").format(date), style: style);
      }
      else {
        text = const Text('', style: style);
      }
    }


    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

}
