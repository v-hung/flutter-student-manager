import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/controllers/student/ClassroomController.dart';
import 'package:flutter_student_manager/models/StudentInfoModel.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class StudyUserInfoWidget extends ConsumerWidget {
  final bool moveInfo;
  const StudyUserInfoWidget({this.moveInfo = true, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classroom = ref.watch(classroomFutureProvider).whenData((value) => value).value;
    return Consumer(
      builder: (context, ref, child) {
        final user = ref.watch(authControllerProvider).user as StudentModel;
        return InkWell(
          onTap: () => moveInfo ? context.go('/student/study/year') : null,
          child: Container(
            // height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.circular(10),
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!)
              )
            ),
            child: Row(
              children: [
                const SizedBox(width: 10,),
                SizedBox(
                  width: 55,
                  height: 55,
                  child: CachedNetworkImage(
                    imageUrl: user.getImage(),
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
                    errorWidget: (context, url, error) => Center(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.green,
                              Colors.orange,
                            ],
                          ),
                        ),
                        child: Icon(CupertinoIcons.person_fill, color: Colors.green[50]!, size: 40,)
                      )
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
                        Text(user.name ?? "...", style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                        ),),
                        const SizedBox(height: 5,),
                        Text(classroom?.name ?? (user.date_of_birth != null ? DateFormat("dd/MM/yyy").format(user.date_of_birth!) : 
                        user.entrance_exam_score != null ? "Điểm đầu vào: ${user.entrance_exam_score}" : "Học sinh")),
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
            ),
          ),
        );
      }
    );
  }
}