import 'dart:convert';

class TuitionModel {
  final int id;
  final int student_id;
  final int tuition_fee;
  final String status;
  final DateTime date;

  TuitionModel({
    required this.id,
    required this.student_id,
    required this.tuition_fee,
    required this.status,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'student_id': student_id,
      'tuition_fee': tuition_fee,
      'status': status,
      'date': date.toString(),
    };
  }

  factory TuitionModel.fromMap(Map<String, dynamic> map) {
    return TuitionModel(
      id: map['id'] as int,
      student_id: map['student_id'] as int,
      tuition_fee: map['tuition_fee'] as int,
      status: map['status'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory TuitionModel.fromJson(String source) => TuitionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
