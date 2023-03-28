import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/bottom_navbar_student.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CalendarPageState();
}

class CalendarPageState extends ConsumerState<CalendarPage> {
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
          Container(
            color: Colors.white,
            child: TableCalendar(
              locale: 'vi',
              rowHeight: 43,
              // headerVisible : false,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                // titleTextStyle: TextStyle(
                //   color: Colors.blue,
                //   fontSize: 16,
                //   fontWeight: FontWeight.w500
                // ),
                leftChevronIcon: Icon(CupertinoIcons.back, color: Colors.blue,),
                rightChevronIcon: Icon(CupertinoIcons.forward, color: Colors.blue,)
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarFormat: extend ? CalendarFormat.month : CalendarFormat.week,
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(day, toDay),
              focusedDay: toDay, 
              firstDay: DateTime.utc(2010,10,16), 
              lastDay: DateTime.utc(2030,3,14),
              calendarStyle: CalendarStyle(
                selectedDecoration : const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                todayDecoration : BoxDecoration(color: Colors.blue[300], shape: BoxShape.circle)
              ),
              onDaySelected: _onDaySelected,
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: InkWell(
                onTap: () => setState(() {extend = !extend;}),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: extend ? const [
                    Text("Mở lịch tuần"),
                    SizedBox(width: 5,),
                    Icon(CupertinoIcons.chevron_up, size: 12,)
                  ] : const [
                    Text("Mở lịch tháng"),
                    SizedBox(width: 5,),
                    Icon(CupertinoIcons.chevron_down, size: 12,)
                  ],
                ),
              ),
            ),
          ),

          ListView.builder(
            itemBuilder: (context, index) {
              return Container();
            },
          )
        ],
      )
    );
  }
}