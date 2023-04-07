import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/models/ClassroomModel.dart';
import 'package:flutter_student_manager/repositories/TeacherRepository.dart';

final subjectsFutureProvider = FutureProvider((ref) async {
  return ref.watch(teacherRepositoryProvider).getSubjects();
});