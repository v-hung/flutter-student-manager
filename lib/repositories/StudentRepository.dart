// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_student_manager/config/app.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/models/ClassroomModel.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/models/TeacherModel.dart';
import 'package:flutter_student_manager/models/TuitionModel.dart';
import 'package:flutter_student_manager/models/UserModel.dart';
import 'package:flutter_student_manager/services/shared_prefs_service.dart';

class TuitionData {
  final List<TuitionModel> tuitions;
  final int debt;
  final int paid;
  TuitionData({
    required this.tuitions,
    required this.debt,
    required this.paid,
  });
}

class StudentRepository {
  final Ref ref;

  StudentRepository({
    required this.ref,
  });

  Future<ClassroomModel> getClassroomById(int id) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/classrooms/$id');
      var response = await http.get(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        return ClassroomModel.fromMap(data['data']);
      } 
      else {
        return Future.error("Không thể tải lớp");
      }
    } catch (e) {
      print(e);
      return Future.error("Không thể tải lớp");
    }
  }

  Future<List<TeacherModel>> getTeachers() async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/teacher');
      var response = await http.get(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        final teachers =  List<TeacherModel>.from((data['data'] as List<dynamic>).map<TeacherModel>((x) => TeacherModel.fromMap(x as Map<String,dynamic>),),);
        return teachers;
      } 
      else {
        return Future.error("Không thể tải giáo viên");
      }
    } catch (e) {
      print(e);
      return Future.error("Không thể tải giáo viên");
    }
  }

  Future<TuitionData> getTuitionByUserId(int id) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/tuitions-history/$id');
      var response = await http.get(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        print(data['tuition']);

        final tuitions =  List<TuitionModel>.from((data['tuition'] as List<dynamic>).map<TuitionModel>((x) => TuitionModel.fromMap(x as Map<String,dynamic>),),);
        return TuitionData(tuitions: tuitions, debt: data['debt'], paid: data['paid']);
      } 
      else {
        return Future.error("Không thể tải học phí");
      }
    } catch (e) {
      print(e);
      return Future.error("Không thể tải học phí");
    }
  }
}

final studentRepositoryProvider = Provider((ref) {
  return StudentRepository(ref: ref);
});