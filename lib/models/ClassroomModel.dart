import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Classroom {
  final int id;
  final String name;
  final String? contact_info;
  final String? schedule;

  Classroom({
    required this.id,
    required this.name,
    required this.contact_info,
    required this.schedule,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'contact_info': contact_info,
      'schedule': schedule,
    };
  }

  factory Classroom.fromMap(Map<String, dynamic> map) {
    return Classroom(
      id: map['id'] as int,
      name: map['name'] as String,
      contact_info: map['contact_info'] != null ? map['contact_info'] as String : null,
      schedule: map['schedule'] != null ? map['schedule'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Classroom.fromJson(String source) => Classroom.fromMap(json.decode(source) as Map<String, dynamic>);
}
