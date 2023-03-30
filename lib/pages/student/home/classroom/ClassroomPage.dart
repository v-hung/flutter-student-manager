import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/student/bottom_navbar_student.dart';
import 'package:flutter_student_manager/components/student/classroom/classroom_info.dart';
import 'package:flutter_student_manager/components/student/classroom/classroom_students.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

class ClassroomPage extends ConsumerStatefulWidget {
  const ClassroomPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ClassroomPageState();
}

class ClassroomPageState extends ConsumerState<ClassroomPage> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
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
        title: const Text("Thông tin Lớp học"),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(CupertinoIcons.xmark),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black12
                // color: Color.fromARGB(255, 202, 202, 202)
              ),
              child: TabBar(
                controller: tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ]
                ),
                labelColor: Colors.blue[700],
                unselectedLabelColor: Colors.black,
                
                tabs: const [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text("Lớp học", style: TextStyle(fontWeight: FontWeight.w600),),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text("Giáo viên", style: TextStyle(fontWeight: FontWeight.w600),),
                  ),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: tabController,
              children: const [
                ClassroomInfo(),
                ClassroomStudents()
              ],
            ),
          ),
        ],
      )
    );
  }
}