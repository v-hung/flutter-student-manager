import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/student/bottom_navbar_student.dart';
import 'package:flutter_student_manager/components/study/main_info.dart';
import 'package:flutter_student_manager/components/study/study_user_info.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';

class StudyPage extends ConsumerStatefulWidget {
  const StudyPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudyPageState();
}

class _StudyPageState extends ConsumerState<StudyPage> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[600]!, Colors.green[400]!], 
              stops: [0.5, 1.0],
            ),
          ),
        ),
        title: const Text("Học tập"),
      ),
      body: Column(
        children: [
          const StudyUserInfoWidget(),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black12
              // color: Color.fromARGB(255, 202, 202, 202)
            ),
            child: TabBar(
              controller: tabController,
              tabs: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  child: Text("Học kỳ I", style: TextStyle(fontWeight: FontWeight.w600),),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  child: Text("Học kỳ II", style: TextStyle(fontWeight: FontWeight.w600),),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  child: Text("Cả năm", style: TextStyle(fontWeight: FontWeight.w600),),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: tabController,
              children: const [
                const StudyMainInfo(),
                Center(child: Text("Sử dụng")),
                Center(child: Text("Còn trống")),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBarStudent(),
    );
  }
}