// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/models/TeacherModel.dart';
import 'package:flutter_student_manager/repositories/TeacherRepository.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/repositories/StudentRepository.dart';
import 'package:intl/intl.dart';

class StudentNotifier extends StateNotifier<StudentData> {
  final Ref ref;
  StudentNotifier(this.ref): super(StudentData.unknown()) {
    loadData();
  }
  
  Future loadData() async {
    state = state.changeState(true);
    final user = ref.watch(authControllerProvider).user as TeacherModel;
    var data = await ref.read(teacherRepositoryProvider).getStudents();
    state = StudentData(loading: false, current_page: data['current_page'], 
      per_page: data['per_page'], last_page: data['last_page'], students: data['da']);
  }

  Future refresh() async {

  }
}

final studentControllerProvider = StateNotifierProvider<StudentNotifier, StudentData>((ref) {
  return StudentNotifier(ref);
});

class StudentData {
  bool loading;
  int current_page;
  int per_page;
  int last_page;
  List<StudentModel> students;

  StudentData({
    required this.loading,
    required this.current_page,
    required this.per_page,
    required this.last_page,
    required this.students,
  });

  StudentData.unknown()
    : loading = false,
      students = [],
      current_page = 1,
      per_page = 1,
      last_page = 1;

  StudentData changeState (bool loading) {
    return StudentData(loading: loading, current_page: current_page, per_page: per_page, last_page: last_page, students: students);
  }

  StudentData addStudent (StudentModel breakSchool) {
    students.insert(0,breakSchool);
    return StudentData(loading: loading, current_page: current_page, per_page: per_page, last_page: last_page, students: students);
  }
}
