import 'dart:convert';

class TuitionModel {
  final int id;
  final String title;
  final int student_id;
  final int tuition_fee;
  final String status;
  final DateTime? name;

  TuitionModel({
    required this.id,
    required this.title,
    required this.student_id,
    required this.tuition_fee,
    required this.status,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'student_id': student_id,
      'tuition_fee': tuition_fee,
      'status': status,
      'name': name?.toString(),
    };
  }

  factory TuitionModel.fromMap(Map<String, dynamic> map) {
    return TuitionModel(
      id: map['id'] as int,
      title: map['title'] as String,
      student_id: map['student_id'] is int ? map['student_id'] as int : int.parse(map['student_id'] as String),
      tuition_fee: map['tuition_fee'] is int ? map['tuition_fee'] as int : int.parse(map['tuition_fee'] as String),
      status: map['status'] as String,
      name: map['name'] != null ? DateTime.parse(map['name'] as String) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TuitionModel.fromJson(String source) => TuitionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
