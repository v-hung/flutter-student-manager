import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/bottom_navbar_student.dart';
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        titleSpacing: 0,
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1
          )
        ),
        title: const Text("Lịch học"),
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: const Icon(CupertinoIcons.xmark),
        ),
        actions: [
          Center(
            child: InkWell(
              onTap: () {
                setState(() {
                  toDay = DateTime.now();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Text("Hôm nay"),
              ),
            ),
          ),
          const SizedBox(width: 10,)
        ],
      ),
      body: Column(
        children: [
         
        ],
      )
    );
  }
}