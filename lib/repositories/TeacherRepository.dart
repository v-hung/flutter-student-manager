// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter_student_manager/models/CodeScanModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/models/BreakSchoolModel.dart';
import 'package:flutter_student_manager/models/SubjectModel.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_student_manager/config/app.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/models/ClassroomModel.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/models/TeacherModel.dart';
import 'package:flutter_student_manager/models/TuitionModel.dart';
import 'package:http_parser/http_parser.dart';

class TuitionData {
  final List<TuitionModel> tuitions;
  final int debt;
  final int paid;
  TuitionData({
    required this.tuitions,
    required this.debt,
    required this.paid,
  });
}

class TeacherRepository {
  final Ref ref;

  TeacherRepository({
    required this.ref,
  });

  Future<TeacherModel?> updateTeacherInfoById(XFile? avatar, String name, String date, String address, String phone) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/student/edit');

      var request = http.MultipartRequest("POST", url);
      request.headers['authorization'] = "Bearer ${auth.token}";
      request.fields['name'] = name;
      request.fields['date_of_birth'] = date;
      request.fields['address'] = address;
      request.fields['contact_info'] = phone;
      if (avatar != null) {
        print(avatar);
        request.files.add(await http.MultipartFile.fromPath('avatar', avatar.path, 
          contentType: MediaType.parse(lookupMimeType(avatar.path) ?? "jpg")
          // contentType: MediaType('image', 'jpeg')
        ));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        return TeacherModel.fromMap(data['data']);
      } 
      else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<ClassroomModel>> getClassrooms() async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/classrooms');
      var response = await http.get(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        final data =  List<ClassroomModel>.from((body['data'] as List<dynamic>).map<ClassroomModel>((x) => ClassroomModel.fromMap(x as Map<String,dynamic>),),);
        return data;
      } 
      else {
        return Future.error("Không thể tải danh sách lớp học");
      }
    } catch (e) {
      print(e);
      return Future.error("Không thể tải danh sách lớp học");
    }
  }

  Future<ClassroomModel> getClassroomById(String id) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/classrooms/$id');
      var response = await http.get(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        final data =  ClassroomModel.fromMap(body['data']);
        return data;
      } 
      else {
        return Future.error("Không thể tải lớp học");
      }
    } catch (e) {
      print(e);
      return Future.error("Không thể tải lớp học");
    }
  }

  Future<Map> getStudents() async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/students');
      var response = await http.get(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body)['data'];

        final data =  List<StudentModel>.from((body['data'] as List<dynamic>).map<StudentModel>((x) => StudentModel.fromMap(x as Map<String,dynamic>),),);
        return {
          "data": data,
          "current_page": body['current_page'],
          "per_page": body['per_page'],
          "last_page": body['last_page'],
        };
      } 
      else {
        return Future.error("Không thể tải danh sách lớp học");
      }
    } catch (e) {
      print(e);
      return Future.error("Không thể tải danh sách lớp học");
    }
  }
}

final teacherRepositoryProvider = Provider((ref) {
  return TeacherRepository(ref: ref);
});