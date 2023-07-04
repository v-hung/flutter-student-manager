import 'dart:convert';
// import 'dart:ffi';

import 'package:flutter_student_manager/config/app.dart';
import 'package:flutter_student_manager/models/ClassroomModel.dart';
import 'package:flutter_student_manager/models/SubjectModel.dart';

class StudentModel {
  final int id;
  final String? uuid;
  final String name;
  final DateTime? date_of_birth;
  final String? address;
  final String? contact_info;
  final String? qrcode;
  final double? entrance_exam_score;
  final String? avatar;
  final String? phone;
  final String? phone2;
  final double? tuition;
  final int? class_id;
  final String? username;
  final ClassroomModel? classroom;
  final List<SubjectModel> subjects;
  final String? gender;
  final DateTime created_at;
  
  StudentModel({
    required this.id,
    required this.uuid,
    required this.name,
    required this.date_of_birth,
    required this.address,
    required this.contact_info,
    required this.qrcode,
    required this.entrance_exam_score,
    required this.avatar,
    required this.phone,
    required this.phone2,
    required this.tuition,
    required this.class_id,
    required this.username,
    this.classroom,
    required this.subjects,
    required this.gender,
    required this.created_at,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'name': name,
      'date_of_birth': date_of_birth?.toString(),
      'address': address,
      'contact_info': contact_info,
      'qrcode': qrcode,
      'entrance_exam_score': entrance_exam_score.toString(),
      'avatar': avatar,
      'phone': phone,
      'phone2': phone2,
      'tuition': tuition.toString(),
      'class_id': class_id,
      'username': username,
      'classroom': classroom?.toMap(),
      'subjects': subjects.map((x) => x.toMap()).toList(),
      'gender': gender,
      'created_at': created_at.toString(),
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'] as int,
      uuid: map['uuid'] == null ? null : map['uuid'] as String,
      name: map['name'] as String,
      date_of_birth: map['date_of_birth'] == null ? null : DateTime.parse(map['date_of_birth'] as String),
      address: map['address'] == null ? null : map['address'] as String,
      contact_info: map['contact_info'] == null ? null : map['contact_info'] as String,
      qrcode: map['qrcode'] == null ? null : map['qrcode'] as String,
      entrance_exam_score: map['entrance_exam_score'] == null ? null 
        : map['entrance_exam_score'] is int ? (map['entrance_exam_score'] as int).toDouble()
        : double.parse(map['entrance_exam_score'] as String),
      tuition: map['tuition'] == null ? null 
        : map['tuition'] is int ? (map['tuition'] as int).toDouble()
        : double.parse(map['tuition'] as String),
      avatar: map['avatar'] == null ? null : map['avatar'] as String,
      phone: map['phone'] == null ? null : map['phone'] as String,
      phone2: map['phone2'] == null ? null : map['phone2'] as String,
      class_id: map['class_id'] == null ? null : map['class_id'] is int ? map['class_id'] : int.parse(map['class_id'] as String),
      username: map['username'] == null ? null : map['username'] as String,
      classroom: map['classroom'] != null ? ClassroomModel.fromMap(map['classroom'] as Map<String,dynamic>) : null,
      subjects: map['subjects'] != null ? List<SubjectModel>.from((map['subjects'] as List<dynamic>).map<SubjectModel>((x) => SubjectModel.fromMap(x as Map<String,dynamic>),),) : [],
      gender: map['gender'] == null ? null : map['gender'] as String,
      created_at: DateTime.parse(map['created_at'])
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentModel.fromJson(String source) => StudentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  String getImage() {
    return "https://$BASE_URL/storage/$avatar";
  }

  String getQrCode() {
    return "https://$BASE_URL/storage/$qrcode";
  }

  String getPhone() {
    return phone ?? "";
  }

  String getPhone2() {
    return phone2 ?? "";
  }

  String getPhoneChat() {
    return phone ?? phone2 ?? "";
  }
}
