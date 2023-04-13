// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter_student_manager/models/CodeScanModel.dart';
import 'package:flutter_student_manager/models/TestMarkModel.dart';
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

  Future<TeacherModel?> updateTeacherInfoById(XFile? avatar, String name, String sex, String date, String address, String phone, String email, String password) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/teacher/${auth.user.id}');

      var request = http.MultipartRequest("POST", url);
      request.headers['authorization'] = "Bearer ${auth.token}";
      request.fields['name'] = name;
      request.fields['sex'] = sex;
      request.fields['date_of_birth'] = date;
      request.fields['address'] = address;
      request.fields['phone'] = phone;
      request.fields['email'] = email;
      request.fields['password'] = password;
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

  Future<Map> getStudents({int per_page = 20, int page = 1, String search = ""}) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/students', {
        "per_page": per_page.toString(),
        "page": page.toString(),
        "search": search.toString()
      });
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
        return {
          "data": [],
          "current_page": 1,
          "per_page": 1,
          "last_page": 1,
        };
      }
    } catch (e) {
      print(e);
      return {
        "data": [],
        "current_page": 1,
        "per_page": 1,
        "last_page": 1,
      };
    }
  }

  Future<StudentModel> getStudentById(String id) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/students/$id');
      var response = await http.get(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        final data =  StudentModel.fromMap(body['data']);
        return data;
      } 
      else {
        return Future.error("Không thể tải học sinh");
      }
    } catch (e) {
      print(e);
      return Future.error("Không thể tải học sinh");
    }
  }

  Future<StudentModel?> createStudent(String name, String date, String address, String phone, String entrance_exam_score,
  String tuition, String class_id, String gender, String username, String password, String subject_id, XFile? avatar) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/students');

      var request = http.MultipartRequest("POST", url);
      request.headers['authorization'] = "Bearer ${auth.token}";
      request.fields['name'] = name;
      request.fields['date_of_birth'] = date;
      request.fields['address'] = address;
      request.fields['contact_info'] = phone;
      request.fields['entrance_exam_score'] = entrance_exam_score;
      request.fields['tuition'] = tuition;
      request.fields['class_id'] = class_id;
      request.fields['gender'] = gender;
      request.fields['username'] = username;
      request.fields['password'] = password;
      request.fields['subject_id'] = subject_id;
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

  Future<StudentModel?> updateStudentInfoById(String id, String name, String date, String address, String phone, String entrance_exam_score,
  String tuition, String class_id, String gender, String username, String password, String subject_id, XFile? avatar) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/student/$id');

      var request = http.MultipartRequest("POST", url);
      request.headers['authorization'] = "Bearer ${auth.token}";
      request.fields['name'] = name;
      request.fields['date_of_birth'] = date;
      request.fields['address'] = address;
      request.fields['contact_info'] = phone;
      request.fields['entrance_exam_score'] = entrance_exam_score;
      request.fields['tuition'] = tuition;
      request.fields['class_id'] = class_id;
      request.fields['gender'] = gender;
      request.fields['username'] = username;
      request.fields['password'] = password;
      request.fields['subject_id'] = subject_id;
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

  Future<StudentModel?> deleteStudentInfoById(String id) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/student/$id');
      var response = await http.delete(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        final data =  StudentModel.fromMap(body['data']);
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
        return Future.error("Không thể tải danh sách lớp học");
      }
    } catch (e) {
      print(e);
      return Future.error("Không thể tải danh sách lớp học");
    }
  }

  Future<List<TestMarkModel>> getTestMarks(String id) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/test-marks-student/$id');
      var response = await http.get(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        final data =  List<TestMarkModel>.from((body['data'] as List<dynamic>).map<TestMarkModel>((x) => TestMarkModel.fromMap(x as Map<String,dynamic>),),);
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

  Future<TestMarkModel?> addTestMarks(String student_id, String subject_id, String point, String exercise) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/test-marks');
      var response = await http.post(url, headers: {
        'authorization': "Bearer ${auth.token}",
      }, body: {
        "student_id": student_id,
        "subject_id": subject_id,
        "point": point,
        "exercise": exercise,
        "date": DateTime.now().toString(),
      });

      print({student_id});

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        final data =  TestMarkModel.fromMap(body['data']);
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

  Future<TestMarkModel?> updateTestMarks(String id, String student_id, String subject_id, String point, String exercise, String date) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/test-marks/$id');
      var response = await http.post(url, headers: {
        'authorization': "Bearer ${auth.token}",
      }, body: {
        "student_id": student_id,
        "subject_id": subject_id,
        "point": point,
        "exercise": exercise,
        "date": date,
      });

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        final data =  TestMarkModel.fromMap(body['data']);
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

  Future<bool> deleteTestMarks(String id) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/test-marks/$id');
      var response = await http.delete(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        return true;
      } 
      else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map> getBreakSchools({int per_page = 20, int page = 1}) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/askforpermission', {
        "per_page": per_page.toString(),
        "page": page.toString(),
      });
      var response = await http.get(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body)['data'];

        final data =  List<BreakSchoolModel>.from((body['data'] as List<dynamic>).map<BreakSchoolModel>((x) => BreakSchoolModel.fromMap(x as Map<String,dynamic>),),);
        // final data2 = List.generate(20, (index) => data[0]);
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

  Future<CodeScanModel?> createQrCode(String id) async {
    try {
      final auth = ref.watch(authControllerProvider);
      var url = Uri.https(BASE_URL, '/api/${auth.type.toString().split('.').last}/qr-code/$id');
      var response = await http.post(url, headers: {
        'authorization': "Bearer ${auth.token}",
      });

      print(response.body);

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        final data =  CodeScanModel.fromMap(body['data']);
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

final teacherRepositoryProvider = Provider((ref) {
  return TeacherRepository(ref: ref);
});