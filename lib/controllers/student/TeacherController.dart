import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/models/TeacherModel.dart';
import 'package:flutter_student_manager/repositories/StudentRepository.dart';

final teacherFutureProvider = FutureProvider.family<TeacherModel, String>((ref, id) async {
  return await ref.read(studentRepositoryProvider).getTeacherById(id);
});