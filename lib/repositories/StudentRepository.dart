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
        return Future.error("Không thể học sinh");
      }
    } catch (e) {
      print(e);
      return Future.error("Không thể học sinh");
    }
  }

  Future<StudentModel?> updateStudentInfoById(XFile? avatar, String name, String date, String address, String info, String phone, String phone2) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/student/${auth.user.id}');

      var request = http.MultipartRequest("POST", url);
      request.headers['authorization'] = "Bearer ${auth.token}";
      request.fields['name'] = name;
      request.fields['date_of_birth'] = date;
      request.fields['address'] = address;
      request.fields['contact_info'] = info;
      request.fields['phone'] = phone;
      request.fields['phone2'] = phone2;
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

      print(id);

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

  Future<Map> getCodeScans({int per_page = 20, int page = 1}) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/attendance-notification/${auth.user.id}', {
        "per_page": per_page.toString(),
        "page": page.toString(),
      });
      var response = await http.get(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body)['data'];

        final data =  List<CodeScanModel>.from((body['data'] as List<dynamic>).map<CodeScanModel>((x) => CodeScanModel.fromMap(x as Map<String,dynamic>),),);
        
        return {
          "data": data,
          "current_page": body['current_page'],
          "per_page": body['per_page'],
          "last_page": body['last_page'],
        };
      } 
      else {
        return {
          "data": [],
          "current_page": 1,
          "per_page": per_page,
          "last_page": 1,
        };
      }
    } catch (e) {
      print(e);
      return {
        "data": [],
        "current_page": 1,
        "per_page": per_page,
        "last_page": 1,
      };
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

        return TuitionData(
          tuitions: tuitions, 
          debt: data['debt'] is int ? data['debt'] : int.parse(data['debt'] as String), 
          paid: data['paid'] is int ? data['paid'] : int.parse(data['paid'] as String)
        );
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

  Future<List<SubjectModel>> getTestMarks(int id) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/test-marks-subject/$id');
      var response = await http.get(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        final data =  List<SubjectModel>.from((body['data'] as List<dynamic>).map<SubjectModel>((x) => SubjectModel.fromMap(x as Map<String,dynamic>),),);
        print(data);
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

  Future<TeacherModel> getTeacherById(String id) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/teacher/$id');
      var response = await http.get(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        final data = TeacherModel.fromMap(body['data']);
        return data;
      } 
      else {
        return Future.error("Không thể tải giáo viên");
      }
    } catch (e) {
      return Future.error("Không thể tải giáo viên");
    }
  }
}

final studentRepositoryProvider = Provider((ref) {
  return StudentRepository(ref: ref);
});