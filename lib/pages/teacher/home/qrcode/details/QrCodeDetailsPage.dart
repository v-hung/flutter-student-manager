import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/components/teacher/bottom_navbar_teacher.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:typed_data';

class TeacherQrCodeDetailsPage extends ConsumerStatefulWidget {
  final String value;
  final String type;
  const TeacherQrCodeDetailsPage({required this.value, required this.type, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeacherQrCodeDetailsPageState();
}

class _TeacherQrCodeDetailsPageState extends ConsumerState<TeacherQrCodeDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[600]!, Colors.green[400]!], 
              stops: [0.5, 1.0],
            ),
          ),
        ),
        // leading: IconButton(onPressed: () {
        //   context.go('/teacher/qrcode?type=${widget.type}');
        // }, icon: const Icon(CupertinoIcons.back)),
        title: Text(widget.type == "in" ? "Quét giờ vào" : "Quét giờ ra"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(widget.value)
      ),
    );
  }
}