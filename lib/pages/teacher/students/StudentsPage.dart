import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/components/teacher/bottom_navbar_teacher.dart';

class TeacherStudentsPage extends ConsumerStatefulWidget {
  const TeacherStudentsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeacherStudentsPageState();
}

class _TeacherStudentsPageState extends ConsumerState<TeacherStudentsPage> {

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