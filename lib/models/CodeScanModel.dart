import 'dart:convert';

import 'package:flutter_student_manager/models/StudentModel.dart';

enum ActionEnum {
  goIn('in'),
  goOut('out'),
  diemKiemTra('diemkiemtra'),
  baiTap('baitap'),
  hocPhi('hocphi'),
  empty('');

  const ActionEnum(this.type);
  final String type;
}

extension ConvertCall on String {
  ActionEnum toEnum() {
    switch (this) {
      case 'in':
        return ActionEnum.goIn;
      case 'out':
        return ActionEnum.goOut;
      case 'diemkiemtra':
        return ActionEnum.diemKiemTra;
      case 'baitap':
        return ActionEnum.baiTap;
      case 'hocphi':
        return ActionEnum.hocPhi;
      default:
        return ActionEnum.empty;
    }
  }
}

class CodeScanModel {
  final String title;
  final DateTime date_time;
  final ActionEnum action;
  final StudentModel? student;

  CodeScanModel({
    required this.title,
    required this.date_time,
    required this.action,
    required this.student,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'date_time': date_time.toString(),
      'action': action.type,
      'student': student?.toMap(),
    };
  }

  factory CodeScanModel.fromMap(Map<String, dynamic> map) {
    return CodeScanModel(
      title: map['title'] as String,
      date_time: DateTime.parse(map['date_time'] as String),
      action: (map['action'] as String).toEnum(),
      student: map['student'] != null ? StudentModel.fromMap(map['student'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CodeScanModel.fromJson(String source) => CodeScanModel.fromMap(json.decode(source) as Map<String, dynamic>);

  String getNameAction() {
    return action == ActionEnum.goIn ? "Đến Trường" 
      : action == ActionEnum.goOut ? "Về nhà"
      : action == ActionEnum.diemKiemTra ? "Điểm kiểm tra"
      : action == ActionEnum.hocPhi ? "Học phí"
      : action == ActionEnum.baiTap ? "Điểm bài tập" : "Thông báo";
  }
}