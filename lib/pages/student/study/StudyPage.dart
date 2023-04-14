import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/student/bottom_navbar_student.dart';
import 'package:flutter_student_manager/components/student/study/study_user_info.dart';
import 'package:flutter_student_manager/components/student/study/test_mark_widget.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/models/SubjectModel.dart';
import 'package:flutter_student_manager/repositories/StudentRepository.dart';
import 'package:fl_chart/fl_chart.dart';

final testMarksProvider = FutureProvider<List<SubjectModel>>((ref) async {
  final user = ref.watch(authControllerProvider).user as StudentModel;
  return await ref.read(studentRepositoryProvider).getTestMarks(user.id);
});

class StudyPage extends ConsumerStatefulWidget {
  const StudyPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudyPageState();
}

class _StudyPageState extends ConsumerState<StudyPage> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final heightSafeArea = size.height -
      AppBar().preferredSize.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom;

    final testMarks = ref.watch(testMarksProvider);

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
          const StudyUserInfoWidget(moveInfo: false,),
          
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.refresh(testMarksProvider.future),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: testMarks.when(
                  data: (data) {
                    if (data.length == 0) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Center(child: Text("Chưa có dữ liệu học tập"),),
                      );
                    }
            
                    return Column(
                      children: [
                        const SizedBox(height: 5,),
                        for(var i = 0; i < data.length; i++) ...[
                          TestMarkWidget(index: i, testMark: data[i],)
                        ]
                      ],
                    );
                  },
                  error: (e,__) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text(e.toString()))
                  ), 
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator())
                  )
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBarStudent(),
    );
  }
}