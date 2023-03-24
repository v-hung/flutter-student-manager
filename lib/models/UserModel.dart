import 'dart:convert';

import 'package:flutter_student_manager/config/app.dart';

class UserModel {
  final String collectionId;
  final String id;
  final String username;
  final String email;
  final String name;
  final String avatar;
  final bool emailVisibility;
  final bool verified;
  final DateTime created;
  final DateTime updated;
  
  UserModel({
    required this.collectionId,
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.avatar,
    required this.emailVisibility,
    required this.verified,
    required this.created,
    required this.updated,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': collectionId,
      'id': id,
      'username': username,
      'email': email,
      'name': name,
      'avatar': avatar,
      'emailVisibility': emailVisibility,
      'verified': verified,
      'created': created.millisecondsSinceEpoch,
      'updated': updated.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      collectionId: map['collectionId'] as String,
      id: map['id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      avatar: map['avatar'] as String,
      emailVisibility: map['emailVisibility'] as bool,
      verified: map['verified'] as bool,
      created: DateTime.parse(map['created'] as String),
      updated: DateTime.parse(map['updated'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  String getImage() {
    return "https://$BASE_URL/api/files/$collectionId/$id/$avatar";
  }
}