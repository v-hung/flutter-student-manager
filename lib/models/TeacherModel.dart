import 'dart:convert';

import 'package:flutter_student_manager/config/app.dart';

class TeacherModel {
  final int id;
  final String email;
  final String name;
  final String? avatar;
  
  TeacherModel({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': email,
      'name': name,
      'avatar': avatar,
    };
  }

  factory TeacherModel.fromMap(Map<String, dynamic> map) {
    return TeacherModel(
      id: map['id'] as int,
      email: map['uid'] as String,
      name: map['name'] as String,
      avatar: map['avatar'] == null ? null : map['avatar'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TeacherModel.fromJson(String source) => TeacherModel.fromMap(json.decode(source) as Map<String, dynamic>);

  String getImage() {
    return "$BASE_URL/storage/$avatar";
  }
}
