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

class StudentRepository {
  final Ref ref;

  StudentRepository({
    required this.ref,
  });

  Future<StudentModel> getStudentInfoById(int id) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/student/$id');
      var response = await http.get(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        return StudentModel.fromMap(data['data']);
      } 
      else {
        return Future.error("Không thể tải lớp");
      }
    } catch (e) {
      print(e);
      return Future.error("Không thể tải lớp");
    }
  }

  Future<StudentModel?> updateStudentInfoById(XFile? avatar, String name, String date, String address, String phone) async {
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
      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        return StudentModel.fromMap(data['data']);
      } 
      else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ClassroomModel> getClassroomById(int id) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/classrooms/$id');
      var response = await http.get(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        return ClassroomModel.fromMap(data['data']);
      } 
      else {
        return Future.error("Không thể tải lớp");
      }
    } catch (e) {
      print(e);
      return Future.error("Không thể tải lớp");
    }
  }

  Future<List<TeacherModel>> getTeachers() async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/teacher');
      var response = await http.get(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        final teachers =  List<TeacherModel>.from((data['data'] as List<dynamic>).map<TeacherModel>((x) => TeacherModel.fromMap(x as Map<String,dynamic>),),);
        return teachers;
      } 
      else {
        return Future.error("Không thể tải giáo viên");
      }
    } catch (e) {
      print(e);
      return Future.error("Không thể tải giáo viên");
    }
  }

  Future<List<CodeScanModel>> getCodeScans(int id) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/attendance-notification/$id');
      var response = await http.get(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        final data =  List<CodeScanModel>.from((body['data'] as List<dynamic>).map<CodeScanModel>((x) => CodeScanModel.fromMap(x as Map<String,dynamic>),),);
        return data;
      } 
      else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<SubjectModel>> getSubjects() async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/subjects');
      var response = await http.get(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        final data =  List<SubjectModel>.from((body['data'] as List<dynamic>).map<SubjectModel>((x) => SubjectModel.fromMap(x as Map<String,dynamic>),),);
        return data;
      } 
      else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<TuitionData> getTuitionByUserId(int id) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/tuitions-history/$id');
      var response = await http.get(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        final tuitions =  List<TuitionModel>.from((data['tuition'] as List<dynamic>).map<TuitionModel>((x) => TuitionModel.fromMap(x as Map<String,dynamic>),),);

        return TuitionData(tuitions: tuitions, debt: data['debt'], paid: data['paid']);
      } 
      else {
        return Future.error("Không thể tải học phí");
      }
    } catch (e) {
      print(e);
      return Future.error("Không thể tải học phí");
    }
  }

  Future<List<BreakSchoolModel>> getAskForPermissionByUserId(int id) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/askforpermission/$id');
      var response = await http.get(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);

        final data =  List<BreakSchoolModel>.from((res['data'] as List<dynamic>).map<BreakSchoolModel>((x) => BreakSchoolModel.fromMap(x as Map<String,dynamic>),),);

        return data;
      } 
      else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<BreakSchoolModel?> askForPermissionByUserId(int id, String reason, DateTime date) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/askforpermission');
      var response = await http.post(url, headers: {
        'authorization': "Bearer ${auth.token}",
      }, body: {
        'student_id': id.toString(),
        'reason': reason,
        'date': date.toString()
      });

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);

        final data = BreakSchoolModel.fromMap(res['data']);

        return data;
      } 
      else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}

final studentRepositoryProvider = Provider((ref) {
  return StudentRepository(ref: ref);
});