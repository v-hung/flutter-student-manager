// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_student_manager/models/TestMarkModel.dart';
import 'package:flutter_student_manager/repositories/TeacherRepository.dart';

class TestMarkNotifier extends StateNotifier<TestMarkData> {
  final Ref ref;
  final String id;
  TestMarkNotifier(this.ref, this.id): super(TestMarkData(loading: true, testMarks: [])) {
    load();
  }
  
  Future load() async {
    state = TestMarkData(loading: true, testMarks: []);
    final data = await ref.read(teacherRepositoryProvider).getTestMarks(id);
     state = TestMarkData(loading: false, testMarks: data);
  }

  Future add(TestMarkModel testMark) async {
    state = state.add(testMark);
  }

  Future delete(int id) async {
    state = state.delete(id);
    ref.read(teacherRepositoryProvider).deleteTestMarks(id.toString());
  }
}

final testMarksProvider = StateNotifierProvider.family<TestMarkNotifier, TestMarkData, String>((ref, id) {
  return TestMarkNotifier(ref, id);
});

class TestMarkData extends Equatable {
  final bool loading;
  List<TestMarkModel> testMarks;
  TestMarkData({
    required this.loading,
    required this.testMarks,
  });

  TestMarkData add(TestMarkModel testMark) {
    int index = testMarks.indexWhere((element) => element.id == testMark.id);
    if (index >= 0) {
      testMarks[index] = testMark;
    }
    else {
      testMarks.insert(0, testMark);
    }
    return TestMarkData(loading: loading, testMarks: testMarks);
  }

  TestMarkData delete(int id) {
    testMarks = testMarks.where((element) => element.id != id).toList();
    return TestMarkData(loading: loading, testMarks: testMarks);
  }

  @override
  List<Object> get props => [loading, testMarks];
}
