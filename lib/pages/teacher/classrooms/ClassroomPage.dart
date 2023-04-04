import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/components/teacher/bottom_navbar_teacher.dart';
import 'package:flutter_student_manager/repositories/TeacherRepository.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'; 

final classroomFutureProvider = FutureProvider((ref) async {
  return ref.watch(teacherRepositoryProvider).getClassrooms();
});

class TeacherClassroomPage extends ConsumerStatefulWidget {
  const TeacherClassroomPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeacherClassroomPageState();
}

class _TeacherClassroomPageState extends ConsumerState<TeacherClassroomPage> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final heightSafeArea = size.height -
      AppBar().preferredSize.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom;

    final classrooms = ref.watch(classroomFutureProvider);

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
        title: const Text("Danh sách lớp"),
      ),
      body: Container(
        constraints: BoxConstraints(
          minHeight: heightSafeArea
        ),
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(classroomFutureProvider.future),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              constraints: BoxConstraints(
                minHeight: heightSafeArea
              ),
              child: classrooms.when(
                data: (data) {
                  if (data.length == 0) {
                    return const Center(child: Text("Không có lớp nào"),);
                  }

                  return AlignedGridView.count(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    itemBuilder: (context, index) {
                      final classroom = data[index];
                      List<String> images = [];
                      if (classroom.images != null) {
                        images = (jsonDecode(classroom.images!) as List<dynamic>).map((e) => toImage(e)).toList();
                      }
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ]
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 45,
                              height: 45,
                              child: CachedNetworkImage(
                                imageUrl: images.length > 0 ? images[0] : "",
                                imageBuilder: (context, imageProvider) => Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    // shape: BoxShape.circle,
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.green,
                                    image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                errorWidget: (_, __, ___) => const Center(child: Icon(CupertinoIcons.exclamationmark_circle,)),
                              )
                            ),
                            const SizedBox(width: 20,),
                            Expanded(child: Container(
                              height: 45,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(classroom.name, style: TextStyle(
                                    fontWeight: FontWeight.w500
                                  ),),
                                  Text(classroom.name, style: TextStyle(
                                    fontWeight: FontWeight.w500
                                  ),),
                                  Text("Sỹ số: 25 học sinh")
                                ],
                              ),
                            ))
                          ],
                        ),
                      );
                    },
                  );
                },
                error: (e,__) => Center(child: Text(e.toString())), 
                loading: () => const Center(child: CircularProgressIndicator(),)
              ),
            ),
          ),
        )
      ),
      bottomNavigationBar: const BottomNavBarTeacher(),
    );
  }
}