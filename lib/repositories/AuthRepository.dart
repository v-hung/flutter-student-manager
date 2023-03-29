// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/models/TeacherModel.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_student_manager/config/app.dart';
import 'package:flutter_student_manager/models/UserModel.dart';
import 'package:flutter_student_manager/services/shared_prefs_service.dart';

class UserData {
  final dynamic user;
  final String token;
  final String type;

  UserData({
    required this.user,
    required this.token,
    required this.type,
  });
}

class AuthRepository {
  final Ref ref;

  AuthRepository({
    required this.ref,
  });

  Future<UserModel?> userDataById(String id) async {
    try {
      var url = Uri.https(BASE_URL, '/api/collections/users/records/:$id');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        UserModel user = UserModel.fromJson(response.body);
        return user;
      }  
      else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<UserData?> getCurrentUserData() async {
    // await Future.delayed(const Duration(seconds: 2));
    try {
      final prefs = await ref.read(sharedPrefsProvider.future);
      String? token = await prefs.getString('token');
      String? type = await prefs.getString('type');

      if (token == null || type == null) return null;

      var url = Uri.https(BASE_URL, '/api/resfeshToken');
      var response = await http.post(url, headers: {
        'authorization': "Bearer $token",
      }, body: {
        'type': type
      });

      print(token);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var user = null;
        if (type == "teacher") {
          user = TeacherModel.fromMap(data['user']);
        }
        else if (type == "student") {
          print(data['user']);
          user = StudentModel.fromMap(data['user']);
        }

        return UserData(user: user, token: data['token'], type: type);
      } 
      else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserData?> signInWithPassword(String identity, String password, String type) async {
    try {
      var url = Uri.https(BASE_URL, '/api/login');
      var response = await http.post(url, body: {
        "username": identity,
        "password": password,
        "type": type
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var user = null;
        if (type == "teacher") {
          user = TeacherModel.fromMap(data['user']);
        }
        else if (type == "student") {
          user = StudentModel.fromMap(data['user']);
        }

        final prefs = await ref.read(sharedPrefsProvider.future);
        await prefs.setString('token', data['token']);
        await prefs.setString('type', type);

        return UserData(user: user, token: data['token'], type: type);
      } 
      else {
        return null;
      }

    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> logout() async {
    try {
      var url = Uri.https(BASE_URL, '/api/logout');
      var response = await http.post(url);

      final prefs = await ref.read(sharedPrefsProvider.future);
      await prefs.setString('token', "");
      await prefs.setString('type', "");

    } catch (e) {}
  }
}

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(ref: ref);
});