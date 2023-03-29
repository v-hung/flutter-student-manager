import 'dart:convert';

import 'package:flutter_student_manager/config/app.dart';

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
  final double? tuition;
  final int? classroom;
  
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
    required this.tuition,
    required this.classroom,
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
      'classroom': classroom,
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
      entrance_exam_score: map['entrance_exam_score'] == null ? null : map['entrance_exam_score'] as double,
      tuition: map['tuition'] == null ? null : map['tuition'] as double,
      avatar: map['avatar'] == null ? null : map['avatar'] as String,
      classroom: map['classroom'] == null ? null : map['classroom'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentModel.fromJson(String source) => StudentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  String getImage() {
    return "https://$BASE_URL/storage/$avatar";
  }
}
