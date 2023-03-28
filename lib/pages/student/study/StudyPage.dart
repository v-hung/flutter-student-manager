import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/bottom_navbar_student.dart';
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
        backgroundColor: Colors.white,
        centerTitle: true,
        titleSpacing: 0,
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1
          )
        ),
        title: const Text("Học tập"),
        actions: [
          IconButton(onPressed: () {
          }, icon: const Icon(Icons.more_vert_rounded))
        ],
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
                  child: Text("Học kỳ I", style: TextStyle(fontWeight: FontWeight.w600),),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text("Học kỳ II", style: TextStyle(fontWeight: FontWeight.w600),),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
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