import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudyStudentPage extends ConsumerStatefulWidget {
  final String id;
  const StudyStudentPage({required this.id, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudyStudentPageState();
}

class _StudyStudentPageState extends ConsumerState<StudyStudentPage> {

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
        title: const Text("Học tập"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Text("Fsadf")
          )
        ],
      ),
    );
  }
}