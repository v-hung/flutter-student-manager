import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/models/AuthModel.dart';
import 'package:go_router/go_router.dart';

class ErrorPage extends ConsumerWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Không tìm thấy trang hiện tại"),
            Consumer(builder: (context, ref, child) {
              final auth = ref.watch(authControllerProvider);
      
              if (auth.type == AuthType.student) {
                return TextButton(onPressed: () {
                  context.go('/student');
                }, child: Text("Về trang chủ"));
              }
              else if (auth.type == AuthType.teacher) {
                return TextButton(onPressed: () {
                  context.go('/teacher');
                }, child: Text("Về trang chủ"));
              }
              else {
                return TextButton(onPressed: () {
                  context.go('/you-are');
                }, child: Text("Về trang đăng nhập"));
              }
            },)
          ]
        ),
      ),
    );
  }
}