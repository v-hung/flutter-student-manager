import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/controllers/teacher/ClassroomsController.dart';
import 'package:flutter_student_manager/models/StudentInfoModel.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class StudyClassroomWidget extends ConsumerWidget {
  final bool moveInfo;
  const StudyClassroomWidget({this.moveInfo = true, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => moveInfo ? context.go('/teacher/study/classroom') : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(10),
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!)
          )
        ),
        child: Consumer(
          builder: (context, ref, child) {
            final classroomStatus = ref.watch(classroomStatusProvider);
      
            if (classroomStatus.loading || classroomStatus.id == null) {
              return const Center(child: CircularProgressIndicator(),);
            }

            if (classroomStatus.id == 0) {
              return const Center(child: Text("Không có lớp nào"),);
            }

            final classroom = ref.watch(classroomFutureProvider(classroomStatus.id.toString()));

            return classroom.when(
              data: (data) {
                List<String> images = [];
                
                if (data.images != null) {
                  images = (jsonDecode(data.images!) as List<dynamic>).map((e) => toImage(e)).toList();
                }

                return Row(
                  children: [
                    const SizedBox(width: 10,),
                    SizedBox(
                      width: 55,
                      height: 55,
                      child: images.isNotEmpty ? CachedNetworkImage(
                        imageUrl: images[0],
                        imageBuilder: (context, imageProvider) => Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Center(child: Icon(CupertinoIcons.exclamationmark_circle_fill)),) 
                      : Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage("assets/img/classroom_default2.jpg"), fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15,),
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 55),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(data.name, style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                            ),),
                            const SizedBox(height: 5,),
                            Text("Sỹ số: ${data.students.length} học sinh"),
                          ],
                        ),
                      ),
                    ),
                    if (moveInfo) ...[
                      const SizedBox(width: 5,),
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: const Icon(CupertinoIcons.right_chevron)
                      ),
                    ],
                    const SizedBox(width: 5,),
                  ],
                );
              },
              error: (_,__) => const Center(child: Text("Không có lớp nào"),),
              loading: () => const Center(child: CircularProgressIndicator(),)
            );
          }
        ),
      ),
    );
  }
}