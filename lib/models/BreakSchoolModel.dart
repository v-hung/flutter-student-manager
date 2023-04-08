import 'dart:convert';

import 'package:flutter_student_manager/models/StudentModel.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class BreakSchoolModel {
  final int id;
  final String reason;
  final DateTime date;
  final StudentModel? student;

  BreakSchoolModel({
    required this.id,
    required this.reason,
    required this.date,
    required this.student,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'reason': reason,
      'date': date.toString(),
      'student': student?.toMap(),
    };
  }

  factory BreakSchoolModel.fromMap(Map<String, dynamic> map) {
    return BreakSchoolModel(
      id: map['id'] as int,
      reason: map['reason'] as String,
      date: DateTime.parse(map['date'] as String),
      student: map['student'] != null ? StudentModel.fromMap(map['student'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BreakSchoolModel.fromJson(String source) => BreakSchoolModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
