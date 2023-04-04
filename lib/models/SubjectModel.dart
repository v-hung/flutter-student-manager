import 'dart:convert';

import 'package:flutter_student_manager/models/TestMarkModel.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SubjectModel {
  final int id;
  final String name;
  final List<TestMarkModel> test_marks;
  SubjectModel({
    required this.id,
    required this.name,
    required this.test_marks,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'test_marks': test_marks.map((x) => x.toMap()).toList(),
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'] as int,
      name: map['name'] as String,
      test_marks: map['test_marks'] != null ? List<TestMarkModel>.from((map['test_marks'] as List<dynamic>).map<TestMarkModel>((x) => TestMarkModel.fromMap(x as Map<String,dynamic>),),) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectModel.fromJson(String source) => SubjectModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
