// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_student_manager/models/TeacherModel.dart';

class TimeKeeping {
  final int id;
  final DateTime start_time;
  final DateTime? end_time;
  final TeacherModel teacher;
  final DateTime created_at;

  TimeKeeping({
    required this.id,
    required this.start_time,
    required this.end_time,
    required this.teacher,
    required this.created_at,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'start_time': start_time.toString(),
      'end_time': end_time.toString(),
      'teacher': teacher.toMap(),
      'created_at': created_at.toString(),
    };
  }

  factory TimeKeeping.fromMap(Map<String, dynamic> map) {
    return TimeKeeping(
      id: map['id'] as int,
      start_time: DateTime.parse(map['start_time'] as String),
      end_time: map['end_time'] != null ? DateTime.parse(map['end_time'] as String) : null,
      teacher: TeacherModel.fromMap(map['teacher'] as Map<String,dynamic>),
      created_at: DateTime.parse(map['created_at'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeKeeping.fromJson(String source) => TimeKeeping.fromMap(json.decode(source) as Map<String, dynamic>);
}
