// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_student_manager/models/ClassroomModel.dart';
import 'package:flutter_student_manager/repositories/TeacherRepository.dart';

final classroomsFutureProvider = FutureProvider((ref) async {
  return ref.watch(teacherRepositoryProvider).getClassrooms();
});

final classroomFutureProvider = FutureProvider.family<ClassroomModel, String>((ref, id) async {
  return await ref.read(teacherRepositoryProvider).getClassroomById(id);
});

class ClassroomStatusNotifier extends StateNotifier<ClassroomStatus> {
  final Ref ref;
  ClassroomStatusNotifier(this.ref): super(ClassroomStatus(loading: false)) {
    load();
  }

  Future load() async{
    state = ClassroomStatus(loading: true);
    final data = await ref.read(classroomsFutureProvider.future).onError((error, stackTrace) => []);
    if (data.isNotEmpty) {
      state = ClassroomStatus(loading: false, id: data[0].id);
    }
    else {
      state = ClassroomStatus(loading: false, id: 0);
    }
  }

  void changeStatus (int id) {
    state = ClassroomStatus(loading: false, id: id);
  }
}

final classroomStatusProvider = StateNotifierProvider<ClassroomStatusNotifier, ClassroomStatus>((ref) {
  return ClassroomStatusNotifier(ref);
});

class ClassroomStatus {
  final bool loading;
  final int? id;
  ClassroomStatus({
    required this.loading,
    this.id,
  });
}
