// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_student_manager/config/app.dart';

class TeacherModel {
  final int id;
  final String email;
  final String name;
  final String? avatar;
  final String? sex;
  final String? address;
  final String? phone;
  final String? position;
  final DateTime? date_of_birth;
  final int? role_id;
  final String? qrcode;
  
  TeacherModel({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    this.sex,
    this.address,
    this.phone,
    this.position,
    this.date_of_birth,
    this.role_id,
    this.qrcode,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'sex': sex,
      'address': address,
      'phone': phone,
      'position': position,
      'date_of_birth': date_of_birth?.toString(),
      'role_id': role_id,
      'qrcode': qrcode,
    };
  }

  factory TeacherModel.fromMap(Map<String, dynamic> map) {
    return TeacherModel(
      id: map['id'] as int,
      email: map['email'] as String,
      name: map['name'] as String,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      sex: map['sex'] != null ? map['sex'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      position: map['position'] != null ? map['position'] as String : null,
      date_of_birth: map['date_of_birth'] != null ? DateTime.parse(map['date_of_birth'] as String) : null,
      role_id: map['role_id'] != null ? (map['role_id'] is int ? map['role_id'] as int : int.parse(map['role_id'] as String)) : null,
      qrcode: map['qrcode'] != null ? map['qrcode'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TeacherModel.fromJson(String source) => TeacherModel.fromMap(json.decode(source) as Map<String, dynamic>);

  String getImage() {
    return "https://$BASE_URL/storage/$avatar";
  }

  String getQrCode() {
    return "https://$BASE_URL/storage/$qrcode";
  }

  bool isAdmin() {
    return role_id == 5;
  }
}
