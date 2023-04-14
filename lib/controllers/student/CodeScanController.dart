import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/controllers/student/CodeScanController.dart';
import 'package:flutter_student_manager/models/CodeScanModel.dart';
import 'package:flutter_student_manager/repositories/StudentRepository.dart';

class CodeScansNotifier extends StateNotifier<CodeScanData> {
  final Ref ref;
  final StreamController<List<CodeScanModel>> _codeScansController = StreamController<List<CodeScanModel>>.broadcast();
  Stream<List<CodeScanModel>> get codeScanStream => _codeScansController.stream;
 
  CodeScansNotifier(this.ref): super(CodeScanData.unknown()) {
    loadData();
  }

  Future<void> loadData() async {
    state = state.changeState(true);
    var data = await ref.read(studentRepositoryProvider).getCodeScans();
    state = CodeScanData(loading: false, current_page: data['current_page'], 
      per_page: data['per_page'], last_page: data['last_page'], codeScans: data['data']);
  }

  Future loadMore() async {
    if (state.current_page >= state.last_page || state.moreLoading) {
      return;
    }

    state = state.changeMoreLoading(true);
    var data = await ref.read(studentRepositoryProvider).getCodeScans(page: state.current_page + 1);
    state = state.addCodeScans(data['data'], data['current_page']);
  }

  Future refresh() async {
    
  }

  void dispose() {
    _codeScansController.close();
  }
}

final codeScanControllerProvider = StateNotifierProvider<CodeScansNotifier, CodeScanData>((ref) {
  return CodeScansNotifier(ref);
});

// final codeScansStreamProvider = StreamProvider<List<CodeScanModel>>((ref) {
//   final codeScans = ref.watch(studentControllerProvider);
//   return codeScans.codeScans.map((e) {
//     return e;
//   });
// });

class CodeScanData {
  bool loading;
  bool moreLoading;
  int current_page;
  int per_page;
  int last_page;
  List<CodeScanModel> codeScans;

  CodeScanData({
    required this.loading,
    this.moreLoading = false,
    required this.current_page,
    required this.per_page,
    required this.last_page,
    required this.codeScans,
  });

  CodeScanData.unknown()
    : loading = false,
      moreLoading = false,
      codeScans = [],
      current_page = 1,
      per_page = 1,
      last_page = 1;
  
  CodeScanData.first()
    : loading = true,
      moreLoading = false,
      codeScans = [],
      current_page = 1,
      per_page = 1,
      last_page = 1;

  CodeScanData changeState (bool loading) {
    return CodeScanData(loading: loading, current_page: current_page, per_page: per_page, last_page: last_page, codeScans: codeScans);
  }

  CodeScanData changeMoreLoading (bool moreLoading) {
    return CodeScanData(loading: loading, moreLoading: moreLoading, current_page: current_page, per_page: per_page, last_page: last_page, codeScans: codeScans);
  }

  CodeScanData addCodeScans (List<CodeScanModel>  data, int current_page) {
    codeScans.addAll(data);
    return CodeScanData(loading: loading, current_page: current_page, per_page: per_page, last_page: last_page, codeScans: codeScans);
  }
}