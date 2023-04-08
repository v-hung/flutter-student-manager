import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StudyClassroomPage extends ConsumerStatefulWidget {
  const StudyClassroomPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudyClassroomPageState();
}

class _StudyClassroomPageState extends ConsumerState<StudyClassroomPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sdfsd"),
        leading: IconButton(
          onPressed: () => context.go('/teacher/study'),
          icon: Icon(CupertinoIcons.back)
        ),
      ),
      body: Text("classroom"),
    );
  }
}