// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/models/BreakSchoolModel.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/repositories/StudentRepository.dart';
import 'package:intl/intl.dart';

class BreakSchoolNotifier extends StateNotifier<BreakSchoolData> {
  final Ref ref;
  BreakSchoolNotifier(this.ref): super(BreakSchoolData.unknown()) {
    loadData();
  }
  
  Future loadData() async {
    state = state.changeState(true);
    final user = ref.watch(authControllerProvider).user as StudentModel;
    var data = await ref.read(studentRepositoryProvider).getAskForPermissionByUserId(user.id);
    state = BreakSchoolData(loading: false, breakSchools: data);
  }

  bool checkNowBreakSchool() {
    final String now = DateFormat("dd/MM/yyy").format(DateTime.now());
    return state.breakSchools.indexWhere((v) => DateFormat("dd/MM/yyy").format(v.date) == now) >= 0;
  }

  Future<bool> askForPermission(BuildContext context, String reason, DateTime date) async {
    final user = ref.watch(authControllerProvider).user as StudentModel;
    var data = await ref.read(studentRepositoryProvider).askForPermissionByUserId(user.id, reason, date);

    if (data != null) {
      state = state.addBreakSchool(data);
    }

    return data != null;
  }
}

final breakSchoolControllerProvider = StateNotifierProvider<BreakSchoolNotifier, BreakSchoolData>((ref) {
  return BreakSchoolNotifier(ref);
});

class BreakSchoolData {
  bool loading;
  List<BreakSchoolModel> breakSchools;

  BreakSchoolData({
    required this.loading,
    required this.breakSchools,
  });

  BreakSchoolData.unknown()
    : loading = false,
      breakSchools = [];

  BreakSchoolData changeState (bool loading) {
    return BreakSchoolData(loading: loading, breakSchools: breakSchools);
  }

  BreakSchoolData addBreakSchool (BreakSchoolModel breakSchool) {
    breakSchools.insert(0,breakSchool);
    return BreakSchoolData(loading: loading, breakSchools: breakSchools);
  }
}
