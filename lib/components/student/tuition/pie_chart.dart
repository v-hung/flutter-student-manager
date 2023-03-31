// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartTuition extends ConsumerStatefulWidget {
  const PieChartTuition({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PieChartTuitionState();
}

class _PieChartTuitionState extends ConsumerState<PieChartTuition> {

  final List<PieData> list = [
    PieData(label: "Số tiền đã đóng", value: 45000, color: Colors.green),
    PieData(label: "Tổng số nợ", value: 5000000, color: Colors.orange),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 200,
      height: 200,
      // color: Colors.red,
      child: SfCircularChart(
        title: ChartTitle(text: "Thông kê số tiền đóng"),
        legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        margin: const EdgeInsets.all(0),
        series: [
          PieSeries<PieData, String>(
            dataSource: list,
            xValueMapper: (PieData data, _) => data.label,
            yValueMapper: (PieData data, _) => data.value,
            pointColorMapper: (data, index) => data.color,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              builder: (data, _, __, ___, ____) => 
                Text(formatCurrency(data.value), style: TextStyle(
                  color: Colors.white,
                  fontSize: 12
                ),),
            )
          )
        ],
      ),
    );
  }
}

class PieData {
  final String label;
  final double value;
  final Color color;

  PieData({
    required this.label,
    required this.value,
    required this.color,
  });
}
