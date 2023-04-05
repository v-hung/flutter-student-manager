import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/models/ClassroomModel.dart';
import 'package:flutter_student_manager/repositories/TeacherRepository.dart';

final classroomsFutureProvider = FutureProvider((ref) async {
  return ref.watch(teacherRepositoryProvider).getClassrooms();
});

final classroomFutureProvider = FutureProvider.family<ClassroomModel, String>((ref, id) async {
  return await ref.read(teacherRepositoryProvider).getClassroomById(id);
});