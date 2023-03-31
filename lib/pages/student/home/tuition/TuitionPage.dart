import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/student/bottom_navbar_student.dart';
import 'package:flutter_student_manager/components/student/tuition/pie_chart.dart';
import 'package:flutter_student_manager/components/student/tuition/svg_bot.dart';
import 'package:flutter_student_manager/components/student/tuition/svg_top.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TuitionPage extends ConsumerStatefulWidget {
  const TuitionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TuitionPageState();
}

class TuitionPageState extends ConsumerState<TuitionPage> {
  late DateTime toDay = DateTime.now();
  late bool extend = false;

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      toDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sizeLine = size.width - 60;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        titleSpacing: 0,
        title: const Text("Học phí", style: TextStyle(color: Colors.white),),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(CupertinoIcons.back, color: Colors.white,),
        ),
      ),
      body: Stack(
        children: [
          Container(),
          SizedBox(
            width: double.infinity,
            height: 100,
            child: CustomPaint(
              painter: SVGTuitionTopPainter(Colors.green[600]!, Colors.green[300]!),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                // color: Colors.red,
                width: double.infinity,
                height: 100,
                child: CustomPaint(
                  painter: SVGTuitionBottomPainter(Colors.orange[200]!, Colors.orange[400]!),
                ),
                // child: Text("fsadf"),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text("Thời gian", style: TextStyle(
                        //       fontWeight: FontWeight.w500
                        //     ),),
                        //     Text("300 Ngày", style: TextStyle(
                        //       color: Colors.grey[700],
                        //       fontWeight: FontWeight.w500
                        //     ),)
                        //   ],
                        // ),

                        const SizedBox(height: 10,),

                        const PieChartTuition(),
                      ],
                    ),
                  ),
          
                  for(var i = 0; i < 10; i ++) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        // border: Border.all(color: Colors.green[300]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Học phí tháng $i năm 2023", style: TextStyle(
                            fontWeight: FontWeight.w500
                          ),),
                          const SizedBox(height: 3,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Số tiền"),
                              Text(formatCurrency(350000), style: TextStyle(
                                color: Colors.brown,
                                fontWeight: FontWeight.w500
                              ),),
                            ],
                          ),
                          const SizedBox(height: 3,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Trạng thái"),
                              Text(i % 3 == 0 ? "Chưa đóng" : "Đã đóng", style: TextStyle(
                                color: i % 3 == 0 ? Colors.deepOrange : Colors.green,
                                fontWeight: FontWeight.w500
                              ),),
                            ],
                          )
                        ],
                      ),
                    ),
                    // const SizedBox(height: 10,)
                  ],
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}

