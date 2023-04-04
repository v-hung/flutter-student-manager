import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/components/teacher/bottom_navbar_teacher.dart';

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
        title: const Text("Bản tin"),
      ),
      body: SingleChildScrollView(),
      bottomNavigationBar: const BottomNavBarTeacher(),
    );
  }
}