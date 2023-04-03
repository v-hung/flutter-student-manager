import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/student/bottom_navbar_student.dart';
import 'package:flutter_student_manager/controllers/student/CodeScanController.dart';
import 'package:go_router/go_router.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {

  @override
  Widget build(BuildContext context) {
    final codeScan = ref.watch(codeScanStreamProvider);
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
        title: const Text("Bản tin"),
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              codeScan.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, stackTrace) => Text(error.toString()),
                data: (data) {
                  // Display all the messages in a scrollable list view.
                  print(data);
                  return Container();
                },
              ),
              // StreamBuilder(
              //   stream: ref.read(codeScanProvider).codeScanStream,
              //   builder: (context, snapshot) {
              //     print(snapshot);
              //     return Container();
              //   }
              // )
            ],
          ),
        ),
      )
    );
  }
}