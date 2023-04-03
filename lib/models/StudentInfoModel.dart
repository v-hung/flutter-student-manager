// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_student_manager/models/ClassroomModel.dart';
import 'package:flutter_student_manager/models/SubjectModel.dart';

class StudentInfoModel {
  final int id;
  final String? uuid;
  final String name;
  final DateTime? date_of_birth;
  final String? address;
  final String? contact_info;
  final String? qrcode;
  final double? entrance_exam_score;
  final String? avatar;
  final double? tuition;
  final int? class_id;
  final String? username;
  final ClassroomModel? classroom;
  final List<SubjectModel> subjects;

  StudentInfoModel({
    required this.id,
    this.uuid,
    required this.name,
    this.date_of_birth,
    this.address,
    this.contact_info,
    this.qrcode,
    this.entrance_exam_score,
    this.avatar,
    this.tuition,
    this.class_id,
    this.username,
    this.classroom,
    required this.subjects,
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
      'entrance_exam_score': entrance_exam_score,
      'avatar': avatar,
      'tuition': tuition,
      'class_id': class_id,
      'username': username,
      'classroom': classroom?.toMap(),
      'subjects': subjects.map((x) => x.toMap()).toList(),
    };
  }

  factory StudentInfoModel.fromMap(Map<String, dynamic> map) {
    return StudentInfoModel(
      id: map['id'] as int,
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      name: map['name'] as String,
      date_of_birth: map['date_of_birth'] != null ? DateTime.parse(map['date_of_birth'] as String) : null,
      address: map['address'] != null ? map['address'] as String : null,
      contact_info: map['contact_info'] != null ? map['contact_info'] as String : null,
      qrcode: map['qrcode'] != null ? map['qrcode'] as String : null,
      entrance_exam_score: map['entrance_exam_score'] != null ? map['entrance_exam_score'] as double : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      tuition: map['tuition'] != null ? map['tuition'] as double : null,
      class_id: map['class_id'] != null ? map['class_id'] as int : null,
      username: map['username'] != null ? map['username'] as String : null,
      classroom: map['classroom'] != null ? ClassroomModel.fromMap(map['classroom'] as Map<String,dynamic>) : null,
      subjects: map['subjects'] != null ? List<SubjectModel>.from((map['subjects'] as List<int>).map<SubjectModel?>((x) => SubjectModel.fromMap(x as Map<String,dynamic>),),) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentInfoModel.fromJson(String source) => StudentInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
