import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/models/CodeScanModel.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/repositories/StudentRepository.dart';

class CodeScanController {
  Ref ref;
  late StreamSubscription subscription;
  StreamController<List<CodeScanModel>> controller = StreamController<List<CodeScanModel>>.broadcast();
  Stream get codeScanStream => controller.stream;
 
  CodeScanController(this.ref) {
    // loadData();

    // controller.stream.asyncMap((event) async => await loadData());
    subscription = _setUp()
    .asyncMap((event) async => await loadData())
    .listen((event) {
      print(event);
    });
  }


 
  resume() {
    subscription.resume();
  }

  Future<List<CodeScanModel>> loadData() async {
    final user = ref.watch(authControllerProvider).user as StudentModel;
    final data = ref.read(studentRepositoryProvider).getCodeScans(user.id);
    print(data);
    return data;
  }
 
  Stream<List<CodeScanModel>> _setUp() {
    return controller.stream;
  }
}

final codeScanStreamProvider = StreamProvider<CodeScanController>((ref) async* {
  final counter = CodeScanController(ref);
 
  ref.onDispose(() => counter.controller.sink.close());
 
  await for (final value in counter.controller.stream) {
    yield counter;
  }
});

final codeScanProvider = Provider<CodeScanController>((ref) {
  return CodeScanController(ref);
});