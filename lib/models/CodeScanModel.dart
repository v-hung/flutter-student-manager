import 'dart:convert';

import 'package:flutter_student_manager/models/StudentModel.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CodeScanModel {
  final String title;
  final DateTime date_time;
  final String action;
  final StudentModel? student;

  CodeScanModel({
    required this.title,
    required this.date_time,
    required this.action,
    required this.student,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'date_time': date_time.toString(),
      'action': action,
      'student': student?.toMap(),
    };
  }

  factory CodeScanModel.fromMap(Map<String, dynamic> map) {
    return CodeScanModel(
      title: map['title'] as String,
      date_time: DateTime.parse(map['date_time'] as String),
      action: map['action'] as String,
      student: map['student'] != null ? StudentModel.fromMap(map['student'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CodeScanModel.fromJson(String source) => CodeScanModel.fromMap(json.decode(source) as Map<String, dynamic>);
}