// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/models/ClassroomModel.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/models/TeacherModel.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_student_manager/config/app.dart';
import 'package:flutter_student_manager/models/UserModel.dart';
import 'package:flutter_student_manager/services/shared_prefs_service.dart';

class ClassRepository {
  final Ref ref;

  ClassRepository({
    required this.ref,
  });

  Future<ClassroomModel> getClassroomById(int id) async {
    try {
      final token = ref.watch(authControllerProvider).token;
      var url = Uri.https(BASE_URL, '/api/classrooms/$id');
      var response = await http.get(url, headers: {
        'authorization': "Bearer $token",
      });

      print(response.statusCode);

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
}

final classroomRepositoryProvider = Provider((ref) {
  return ClassRepository(ref: ref);
});