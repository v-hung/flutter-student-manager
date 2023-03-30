import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/student/bottom_navbar_student.dart';
import 'package:flutter_student_manager/components/student/tuition/svg_bot.dart';
import 'package:flutter_student_manager/components/student/tuition/svg_top.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

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
                  painter: SVGTuitionBottomPainter(Colors.orange[200]!, Colors.orange[500]!),
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
                    height: 200,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1),
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
          
                  for(var i = 0; i < 5; i ++) ...[
                    Container(
                      height: 50,
                      margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        borderRadius: BorderRadius.circular(5)
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

