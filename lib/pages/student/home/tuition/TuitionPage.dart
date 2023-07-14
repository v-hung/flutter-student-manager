import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/student/bottom_navbar_student.dart';
import 'package:flutter_student_manager/components/student/tuition/pie_chart.dart';
import 'package:flutter_student_manager/components/student/tuition/svg_bot.dart';
import 'package:flutter_student_manager/components/student/tuition/svg_top.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/repositories/StudentRepository.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final tuitionProvider = FutureProvider.autoDispose<TuitionData>((ref) async {
  final user = ref.watch(authControllerProvider).user as StudentModel;
  return await ref.read(studentRepositoryProvider).getTuitionByUserId(user.id);
});

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

    final heightSafeArea = size.height -
      AppBar().preferredSize.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom;

    final tuitionData = ref.watch(tuitionProvider);

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
            height: 200,
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
            child: Container(
              constraints: BoxConstraints(
                minHeight: heightSafeArea
              ),
              child: RefreshIndicator(
                onRefresh: () => ref.refresh(tuitionProvider.future),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: tuitionData.when(
                    data: (data) {
                      if (data.tuitions.length == 0) {
                        return Container(
                          constraints: BoxConstraints(
                            minHeight: heightSafeArea
                          ),
                          child: Center(child: Text("Không có lịch sử học phí nào"))
                        );
                      }

                      return Column(
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
                                const SizedBox(height: 10,),
                  
                                PieChartTuition(debt: data.debt, paid: data.paid,),
                              ],
                            ),
                          ),
                            
                          for(var i = 0; i < data.tuitions.length; i ++) ...[
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
                                  Text(data.tuitions[i].title, style: const TextStyle(
                                    fontWeight: FontWeight.w500
                                  ),),
                                  const SizedBox(height: 3,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Số tiền"),
                                      Text(formatCurrency(data.tuitions[i].tuition_fee), style: const TextStyle(
                                        color: Colors.brown,
                                        fontWeight: FontWeight.w500
                                      ),),
                                    ],
                                  ),
                                  const SizedBox(height: 3,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Trạng thái"),
                                      Text(data.tuitions[i].status == "paid" ? "Đã đóng" : "Chưa đóng", style: TextStyle(
                                        color: data.tuitions[i].status == "paid" ? Colors.green : Colors.deepOrange,
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
                      );
                    },
                    error: (e,__) => Container(
                      height: heightSafeArea,
                      child: Center(child: Text(e.toString()))
                    ), 
                    loading: () => SizedBox(
                      height: MediaQuery.of(context).size.height * .5,
                      child: const Center(child: CircularProgressIndicator())
                    )
                  )
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}

