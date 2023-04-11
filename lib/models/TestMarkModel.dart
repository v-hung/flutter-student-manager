// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_student_manager/models/SubjectModel.dart';

enum ExerciseEnum {
  khongLam('khonglam'),
  khongDat('khongdat'),
  dat('dat');

  const ExerciseEnum(this.type);
  final String type;
}

extension ConvertCall on String {
  ExerciseEnum toEnum() {
    switch (this) {
      case 'khonglam':
        return ExerciseEnum.khongLam;
      case 'khongdat':
        return ExerciseEnum.khongDat;
      case 'dat':
        return ExerciseEnum.dat;
      default:
        return ExerciseEnum.khongLam;
    }
  }
}

class TestMarkModel {
  final int id;
  final double point;
  final DateTime date;
  final String? node;
  final SubjectModel? subject;
  final ExerciseEnum? exercise;

  TestMarkModel({
    required this.id,
    required this.point,
    required this.date,
    this.node,
    required this.subject,
    required this.exercise,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'point': point,
      'date': date.toString(),
      'node': node,
      'subject': subject,
      'exercise': exercise?.type,
    };
  }

  factory TestMarkModel.fromMap(Map<String, dynamic> map) {
    return TestMarkModel(
      id: map['id'] as int,
      point: map['point'] is int ? map['point'].toDouble() : double.parse(map['point'] as String),
      date: DateTime.parse(map['date'] as String),
      node: map['node'] != null ? map['node'] as String : null,
      subject: map['subject'] != null ? SubjectModel.fromMap(map['subject'] as Map<String,dynamic>) : null,
      exercise: map['exercise'] != null ? (map['exercise'] as String).toEnum() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TestMarkModel.fromJson(String source) => TestMarkModel.fromMap(json.decode(source) as Map<String, dynamic>);

  String getExercise() {
    switch (exercise) {
      case ExerciseEnum.khongLam:
        return "Không làm";
      case ExerciseEnum.khongDat:
        return "Không đạt";
      case ExerciseEnum.dat:
        return "Đạt";
      default:
        return 'Chưa chấm';
    }
  }
}
