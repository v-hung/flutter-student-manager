import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TestMarkModel {
  final int id;
  final double point;
  final DateTime date;
  final String? node;

  TestMarkModel({
    required this.id,
    required this.point,
    required this.date,
    this.node,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'point': point,
      'date': date.toString(),
      'node': node,
    };
  }

  factory TestMarkModel.fromMap(Map<String, dynamic> map) {
    return TestMarkModel(
      id: map['id'] as int,
      point: map['point'].toDouble(),
      date: DateTime.parse(map['date'] as String),
      node: map['node'] != null ? map['node'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TestMarkModel.fromJson(String source) => TestMarkModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
