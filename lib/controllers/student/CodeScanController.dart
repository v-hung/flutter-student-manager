import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/models/CodeScanModel.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/repositories/StudentRepository.dart';

class CodeScansController {
  final Ref ref;
  List<CodeScanModel> codeScans = [];
  final StreamController<List<CodeScanModel>> _codeScansController = StreamController<List<CodeScanModel>>.broadcast();
  Stream<List<CodeScanModel>> get codeScanStream => _codeScansController.stream;
 
  CodeScansController(this.ref) {
    loadData();
  }

  Future<void> loadData() async {
    final user = ref.watch(authControllerProvider).user as StudentModel;
    final data = await ref.read(studentRepositoryProvider).getCodeScans(user.id);
    codeScans.addAll(data);
    _codeScansController.sink.add(codeScans);
  }

  void dispose() {
    _codeScansController.close();
  }
}

final codeScansProvider = Provider<CodeScansController>((ref) {
  return CodeScansController(ref);
});

final codeScansStreamProvider = StreamProvider<List<CodeScanModel>>((ref) {
  final codeScans = ref.watch(codeScansProvider);
  return codeScans.codeScanStream.map((e) {
    return e;
  });
});

