import 'dart:convert';

class TeacherModel {
  final String id;
  final String uid;
  final String name;
  final DateTime date_of_birth;
  final String address;
  final String contact_info;
  final String qrcode;
  final double entrance_exam_score;
  final String avatar;
  
  TeacherModel({
    required this.id,
    required this.uid,
    required this.name,
    required this.date_of_birth,
    required this.address,
    required this.contact_info,
    required this.qrcode,
    required this.entrance_exam_score,
    required this.avatar,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'name': name,
      'date_of_birth': date_of_birth.toString(),
      'address': address,
      'contact_info': contact_info,
      'qrcode': qrcode,
      'entrance_exam_score': entrance_exam_score,
      'avatar': avatar,
    };
  }

  factory TeacherModel.fromMap(Map<String, dynamic> map) {
    return TeacherModel(
      id: map['id'] as String,
      uid: map['uid'] as String,
      name: map['name'] as String,
      date_of_birth: DateTime.parse(map['date_of_birth'] as String),
      address: map['address'] as String,
      contact_info: map['contact_info'] as String,
      qrcode: map['qrcode'] as String,
      entrance_exam_score: map['entrance_exam_score'] as double,
      avatar: map['avatar'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TeacherModel.fromJson(String source) => TeacherModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
