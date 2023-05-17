import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/teacher/StudentController.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TeacherStudentDetailsPage extends ConsumerStatefulWidget {
  final String id;
  final String classroomId;
  const TeacherStudentDetailsPage({required this.id, required this.classroomId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeacherStudentDetailsPageState();
}

class _TeacherStudentDetailsPageState extends ConsumerState<TeacherStudentDetailsPage> {
  var top = 144.0;
  var showLeading = true;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {
      final topDistance = 144 - scrollController.offset;
      top = topDistance > 0 ? topDistance : 0;
      bool tempShowLeading = top > 26;
      if (showLeading != tempShowLeading) {
        setState(() {{
          showLeading = tempShowLeading;
        }});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final student = ref.watch(studentFutureProvider(widget.id));
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: student.when(
        data: (data) {
          return CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: showLeading ? true : false,
                backgroundColor: Colors.green,
                leading: IconButton(
                  onPressed: () => widget.classroomId != "" ? context.go('/teacher/classrooms/${widget.classroomId}') : context.pop(), 
                  icon: const Icon(CupertinoIcons.back)
                ),
                actions: [
                  TextButton(
                    onPressed: () => context.go('/teacher/students/edit-add?id=${data.id}'),
                    child: const Text("Chỉnh sửa", style: TextStyle(
                      color: Colors.white
                    ),)
                  ),
                ],
                floating: false,
                pinned: true,
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 250,
                        child: CachedNetworkImage(
                          imageUrl: data.getImage(),
                          imageBuilder: (context, imageProvider) => Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.green,
                                  Colors.orange,
                                ],
                              ),
                              image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Center(
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.green,
                                    Colors.orange,
                                  ],
                                ),
                              ),
                              child: Icon(CupertinoIcons.person_fill, color: Colors.green[50], size: 50,)
                            )
                          ),
                        ),
                      ),
                      Positioned.fill(child: Container(color: Colors.black.withOpacity(0.3),))
                    ],
                  ),
                  title: Text(data.name, style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w700
                  ),),
                  titlePadding: const EdgeInsetsDirectional.only(
                    start: 15.0,
                    bottom: 16.0,
                  ),
                  // centerTitle: true,
                )
              ),

              SliverToBoxAdapter(
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Thông tin chi tiết", style: TextStyle(
                              color: Colors.blue
                            ),),
                      
                            const SizedBox(height: 10,),
                            const Text("Giới tính", style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey
                            ),),
                            const SizedBox(height: 3,),
                            Text(data.gender != null ? (data.gender == "nam" ? "Name" : "Nữ") : "Chưa cập nhập"),
                            
                            const SizedBox(height: 10,),
                            const Text("Ngày sinh", style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey
                            ),),
                            const SizedBox(height: 3,),
                            Text(data.date_of_birth != null ? DateFormat("dd/MM/yyyy").format(data.date_of_birth!) : "Chưa cập nhập"),
                            
                            const SizedBox(height: 10,),
                            const Text("Địa chỉ", style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey
                            ),),
                            const SizedBox(height: 3,),
                            Text(data.address != null ? data.address! : "Chưa cập nhập"),

                            const SizedBox(height: 10,),
                            const Text("Thông tin liên hệ", style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey
                            ),),
                            const SizedBox(height: 3,),
                            Text(data.contact_info != null ? data.contact_info! : "Chưa cập nhập"),

                            const SizedBox(height: 10,),
                            const Text("Ngày tạo tài khoản", style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey
                            ),),
                            const SizedBox(height: 3,),
                            Text(DateFormat("dd/MM/yyyy").format(data.created_at)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10,),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Học tập", style: TextStyle(
                              color: Colors.blue
                            ),),
                      
                            const SizedBox(height: 10,),
                            const Text("Điểm đầu vào", style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey
                            ),),
                            const SizedBox(height: 3,),
                            Text(data.entrance_exam_score != null ? data.entrance_exam_score!.toString() : "Chưa cập nhập"),
                            
                            const SizedBox(height: 10,),
                            const Text("Học phí", style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey
                            ),),
                            const SizedBox(height: 3,),
                            Text(data.tuition != null ? formatCurrencyDouble(data.tuition!) : "Chưa cập nhập"),
                            
                            const SizedBox(height: 10,),
                            const Text("Lớp học", style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey
                            ),),
                            const SizedBox(height: 3,),
                            Text(data.classroom != null ? data.classroom!.name : "Chưa cập nhập"),

                            const SizedBox(height: 10,),
                            const Text("Môn học", style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey
                            ),),
                            const SizedBox(height: 3,),
                            Text(data.subjects.isNotEmpty ? data.subjects.fold("",(value, element, ) => "$value${element.name} ") : "Chưa cập nhập"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]
          );
        },
        error: (e,_) => Center(child: Text(e.toString()),),
        loading: () => const Center(child: CircularProgressIndicator(),)
      ),
    );
  }
}