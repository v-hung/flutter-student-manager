import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:flutter_student_manager/config/app.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ClassroomModel {
  final int id;
  final String name;
  final String? contact_info;
  final String? schedule;
  final String? images;
  final String? description;
  final int? students_count;
  final List<StudentModel> students;

  ClassroomModel({
    required this.id,
    required this.name,
    required this.contact_info,
    required this.schedule,
    required this.images,
    required this.description,
    required this.students_count,
    required this.students,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'contact_info': contact_info,
      'schedule': schedule,
      'images': images,
      'description': description,
      'students_count': students_count,
      'students': students.map((x) => x.toMap()).toList(),
    };
  }

  factory ClassroomModel.fromMap(Map<String, dynamic> map) {
    return ClassroomModel(
      id: map['id'] as int,
      name: map['name'] as String,
      contact_info: map['contact_info'] != null ? map['contact_info'] as String : null,
      schedule: map['schedule'] != null ? map['schedule'] as String : null,
      images: map['images'] != null ? map['images'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      students_count: map['students_count'] != null ? (map['students_count'] is int ? map['students_count'] as int : int.parse(map['students_count'] as String)) : null,
      students: map['students'] != null ? List<StudentModel>.from((map['students'] as List<dynamic>).map<StudentModel>((x) => StudentModel.fromMap(x as Map<String,dynamic>),),) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassroomModel.fromJson(String source) => ClassroomModel.fromMap(json.decode(source) as Map<String, dynamic>);

  String getSchedule() {
    return "https://$BASE_URL/storage/$schedule";
  }

  List<String> getListImage() {
    if (images == null) {
      return [];
    }
    else {
      return images!.split(",").map((e) => "https://$BASE_URL/storage/$e").toList();
    }
  }

  bool operator ==(o) => o is ClassroomModel && name == o.name && id == o.id;
  int get hashCode => Object.hash(id, name);
}
