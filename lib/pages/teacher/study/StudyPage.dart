import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/components/teacher/bottom_navbar_teacher.dart';
import 'package:flutter_student_manager/components/teacher/study/study_user_info.dart';
import 'package:flutter_student_manager/controllers/teacher/ClassroomsController.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tiengviet/tiengviet.dart';

class TeacherStudyPage extends ConsumerStatefulWidget {
  const TeacherStudyPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeacherStudyPageState();
}

class _TeacherStudyPageState extends ConsumerState<TeacherStudyPage> {
  bool isSearch = false;
  final searchController = TextEditingController();
  final searchFocus = FocusNode();

  String titleStudent(String? gender, DateTime? date) {
    String value = (gender == "nam" ? "Nam" : gender == "nu" ? "Nữ" : "");
    if (gender != null && date != null) {
      value += " | ";
    }
    value += date != null ? DateFormat("dd/MM/yyyy").format(date) : "";
    return value;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[600]!, Colors.green[400]!], 
              stops: const [0.5, 1.0],
            ),
          ),
        ),
        title: isSearch ? TextField(
          focusNode: searchFocus,
          controller: searchController,
          onChanged: (value) => setState(() {}),
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Tìm kiếm",
            enabledBorder:  UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.white.withOpacity(.7))
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.white)
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10,),
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.normal),
          )
        ) : const Text("Học tập"),
        actions: [
          IconButton(
            onPressed: () => setState(() {
              isSearch = !isSearch;  
              if (isSearch) {
                searchFocus.requestFocus();
              }
            }),
            icon: Icon(isSearch ? CupertinoIcons.xmark : CupertinoIcons.search)
          )
        ],
      ),
      body: Column(
        children: [
          const StudyClassroomWidget(),
          
          Expanded(
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
                    final filter = TiengViet.parse(searchController.text).toLowerCase();
                    final students = data.students.where((student) => TiengViet.parse(student.name).toLowerCase().contains(filter)).toList();

                    if (students.isEmpty) {
                      return const Center(child: Text("Không có học sinh nào"),);
                    }
                    
                    return ListView.builder(
                      itemCount: students.length,
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return InkWell(
                          onTap: () => context.go('/teacher/study/${student.id}'),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white ,
                              border: Border(
                                bottom: BorderSide(color: Colors.grey[300]!)
                              )
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: student.avatar != null ? CachedNetworkImage(
                                    imageUrl: student.getImage(),
                                    imageBuilder: (context, imageProvider) => Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        // shape: BoxShape.circle,
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.green,
                                        image: DecorationImage(
                                          image: imageProvider, fit: BoxFit.cover),
                                      ),
                                    ),
                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                    errorWidget: (_, __, ___) => Center(child: Container(
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
                                      child: Icon(CupertinoIcons.person_fill, color: Colors.green[50], size: 20,)
                                    )),
                                  )
                                  : Center(child: Container(
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
                                    child: Icon(CupertinoIcons.person_fill, color: Colors.green[50], size: 20,)
                                  ))
                                ),
                                const SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(student.name, style: const TextStyle(
                                      fontWeight: FontWeight.w500
                                    ),),
                                    const SizedBox(height: 5,),
                                    Text(titleStudent(student.gender, student.date_of_birth),
                                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10,),
                                const Spacer(),
                                const Icon(CupertinoIcons.info, color: Colors.blue,)
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  error: (_,__) => const Center(child: Text("Không có lớp nào"),),
                  loading: () => const Center(child: CircularProgressIndicator(),)
                );
              }
            )
          )
        ],
      ),
      bottomNavigationBar: const BottomNavBarTeacher(),
    );
  }
}