import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/models/TeacherModel.dart';
import 'package:flutter_student_manager/models/UserModel.dart';

enum AuthState {
  initial,
  login,
  notLogin
}

enum AuthType {
  teacher,
  student
}

class AuthModel {
  final AuthState authState;
  final dynamic user;
  final String? token;
  final AuthType? type;
  
  AuthModel({
    required this.user,
    required this.authState,
    required this.token,
    required this.type,
  });

  const AuthModel.unknown()
    : authState = AuthState.initial,
      user = null,
      type = null,
      token = null;

  AuthModel changeState (AuthState authState) {
    return AuthModel(user: user, authState: authState, token: token, type: type);
  }

  AuthModel changeUser (dynamic userData) {
    if (userData is StudentModel) {
      return AuthModel(user: userData, authState: authState, token: token, type: type);
    }
    else if (userData is TeacherModel) {
      return AuthModel(user: userData, authState: authState, token: token, type: type);
    }
    return AuthModel(user: user, authState: authState, token: token, type: type);
  }
}