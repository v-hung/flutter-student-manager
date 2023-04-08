import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/components/teacher/bottom_navbar_teacher.dart';
import 'package:flutter_student_manager/components/teacher/study/study_user_info.dart';
import 'package:flutter_student_manager/controllers/teacher/ClassroomsController.dart';
import 'package:go_router/go_router.dart';

class TeacherStudyPage extends ConsumerStatefulWidget {
  const TeacherStudyPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeacherStudyPageState();
}

class _TeacherStudyPageState extends ConsumerState<TeacherStudyPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          const StudyClassroomWidget(),
          
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final classroomStatus = ref.watch(classroomStatusProvider);
          
                if (classroomStatus.loading || classroomStatus.id == null) {
                  return const Center(child: CircularProgressIndicator(),);
                }

                if (classroomStatus.id == 0) {
                  return const Center(child: Text("Không có lớp nào"),);
                }

                final classroom = ref.watch(classroomFutureProvider(classroomStatus.id.toString()));

                return classroom.when(
                  data: (data) {
                    final students = data.students;
                    
                    return ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return InkWell(
                          onTap: () => context.go('/teacher/study/${student.id}'),
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            color: Colors.white ,
                            child: Text(student.name),
                          ),
                        );
                      },
                    );
                  },
                  error: (_,__) => const Center(child: Text("Không có lớp nào"),),
                  loading: () => const Center(child: CircularProgressIndicator(),)
                );
              }
            )
          )
        ],
      ),
      bottomNavigationBar: const BottomNavBarTeacher(),
    );
  }
}