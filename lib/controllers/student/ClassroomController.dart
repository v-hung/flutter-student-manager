// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/models/ClassroomModel.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/repositories/ClassroomRepository.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_student_manager/models/AuthModel.dart';
import 'package:flutter_student_manager/repositories/AuthRepository.dart';
import 'package:flutter_student_manager/utils/utils.dart';

final classroomFutureProvider = FutureProvider<ClassroomModel?>((ref) async {
  final user = ref.watch(authControllerProvider).user as StudentModel;

  if (user.class_id == null) return null;

  return await ref.read(classroomRepositoryProvider).getClassroomById(user.id);
});