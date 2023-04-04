// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/student/ClassroomController.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_student_manager/models/AuthModel.dart';
import 'package:flutter_student_manager/repositories/AuthRepository.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:intl/intl.dart';

class AuthNotifier extends StateNotifier<AuthModel> {
  final Ref ref;
  AuthNotifier(this.ref): super(const AuthModel.unknown()) {
    getCurrentUserData();
  }
  
  void getCurrentUserData() async {
    // state = state.changeState(AuthState.loading);
    var data = await ref.read(authRepositoryProvider).getCurrentUserData();

    if (data != null) {
      state = AuthModel(user: data.user, token: data.token, authState: AuthState.login, type: data.type == "student" ? AuthType.student : AuthType.teacher);
    }
    else {
      state = AuthModel(user: null, token: null, authState: AuthState.notLogin, type: null);
    }
  }

  Future<void> signInWithPassword(BuildContext context, String identity, String password, String type) async {
    var data = await ref.read(authRepositoryProvider).signInWithPassword(identity, password, type);

    if (data != null) {
      state = AuthModel(user: data.user, token: data.token, authState: AuthState.login, type: data.type == "student" ? AuthType.student : AuthType.teacher);
      if (context.mounted) {
        context.go("/$type");
      }
    }
    else {
      if (context.mounted) {
        showSnackBar(context: context, content: "Tài khoản hoặc mật khẩu không chính xác");
      }
    }
  }

  void updateUserInfo(dynamic user) async {
    state = state.changeUser(user);
  }

  Future<void> logout() async {
    ref.read(authRepositoryProvider).logout();
    state = AuthModel(user: null, token: null, authState: AuthState.notLogin, type: null);
  }
}

final authControllerProvider = StateNotifierProvider<AuthNotifier, AuthModel>((ref) {
  return AuthNotifier(ref);
});

final getUserTextStateProvider = Provider<String>((ref) {
  final user = ref.watch(authControllerProvider).user;
  if (user is StudentModel) {
    final classroom = ref.watch(classroomFutureProvider).whenData((value) => value).value;
    return "Sao Thái Nguyên${classroom?.name != null ? " | ${classroom!.name}" : ""}";
  }
  return "";
});