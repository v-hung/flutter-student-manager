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
      per_page: data['per_page'], last_page: data['last_page'], students: data['data']);
  }

  Future loadDataSearch(String search) async {
    state = StudentData(loading: true, current_page: 1, 
      per_page: 1, last_page: 1, students: []);
    final user = ref.watch(authControllerProvider).user as TeacherModel;
    var data = await ref.read(teacherRepositoryProvider).getStudents(search: search);
    state = StudentData(loading: false, current_page: data['current_page'], search: search,
      per_page: data['per_page'], last_page: data['last_page'], students: data['data']);
  }

  Future loadMore() async {
    if (state.current_page >= state.last_page || state.moreLoading) {
      return;
    }

    state = state.changeMoreLoading(true);
    final user = ref.watch(authControllerProvider).user as TeacherModel;
    var data = await ref.read(teacherRepositoryProvider).getStudents(page: state.current_page + 1);
    state = state.addStudents(data['data'], data['current_page']);
  }

  Future deleteStudent(int id) async {
    state = state.delStudent(id);
  }
}

final studentControllerProvider = StateNotifierProvider<StudentNotifier, StudentData>((ref) {
  return StudentNotifier(ref);
});

final studentFutureProvider = FutureProvider.family<StudentModel, String>((ref, id) async {
  return await ref.read(teacherRepositoryProvider).getStudentById(id);
});

class StudentData {
  bool loading;
  bool moreLoading;
  int current_page;
  int per_page;
  int last_page;
  String search;
  List<StudentModel> students;

  StudentData({
    required this.loading,
    this.moreLoading = false,
    required this.current_page,
    required this.per_page,
    required this.last_page,
    this.search = "",
    required this.students,
  });

  StudentData.unknown()
    : loading = false,
      moreLoading = false,
      students = [],
      search = "",
      current_page = 1,
      per_page = 1,
      last_page = 1;

  StudentData changeState (bool loading) {
    return StudentData(loading: loading, current_page: current_page, per_page: per_page, last_page: last_page, students: students);
  }

  StudentData changeMoreLoading (bool moreLoading) {
    return StudentData(loading: loading, moreLoading: moreLoading, search: search, current_page: current_page, per_page: per_page, last_page: last_page, students: students);
  }

  StudentData changeSearch (String search) {
    return StudentData(loading: loading, moreLoading: moreLoading, search: search, current_page: current_page, per_page: per_page, last_page: last_page, students: students);
  }

  StudentData addStudents (List<StudentModel>  data, int current_page) {
    students.addAll(data);
    return StudentData(loading: loading, current_page: current_page, search: search, per_page: per_page, last_page: last_page, students: students);
  }

  StudentData delStudent (int id) {
    students = students.where((element) => element.id != id).toList();
    return StudentData(loading: loading, current_page: current_page, search: search, per_page: per_page, last_page: last_page, students: students);
  }
}
