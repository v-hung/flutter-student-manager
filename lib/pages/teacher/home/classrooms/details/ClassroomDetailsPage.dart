import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/teacher/classroom/classroom_info.dart';
import 'package:flutter_student_manager/controllers/teacher/ClassroomsController.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

class ClassroomDetailsPage extends ConsumerStatefulWidget {
  final String id;
  const ClassroomDetailsPage({required this.id, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ClassroomDetailsPageState();
}

class ClassroomDetailsPageState extends ConsumerState<ClassroomDetailsPage> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final classroom = ref.watch(classroomFutureProvider(widget.id));
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
        title: const Text("Thông tin Lớp học"),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black12
                // color: Color.fromARGB(255, 202, 202, 202)
              ),
              child: TabBar(
                controller: tabController,
                
                tabs: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.center,
                    child: const Text("Lớp học", style: TextStyle(fontWeight: FontWeight.w600),),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.center,
                    child: const Text("Lịch học", style: TextStyle(fontWeight: FontWeight.w600),),
                  ),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: tabController,
              children: [
                TeacherClassroomInfo(id: widget.id,),
                Container(
                  child: RefreshIndicator(
                    onRefresh: () => ref.refresh(classroomFutureProvider(widget.id).future),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: classroom.when(
                        data: (data) {
                          if (data.schedule == null) {
                            return const Center(child: Text("Chưa cập nhập lịch học"),);
                          }

                          return CachedNetworkImage( 
                            imageUrl: toImage(data.schedule ?? ""),
                            imageBuilder: (context, imageProvider) => Image(
                              image: imageProvider, 
                              fit: BoxFit.cover
                            ),
                            placeholder: (context, url) => Container(
                              height: 200,
                              child: const Center(child: CircularProgressIndicator())
                            ),
                            errorWidget: (context, url, error) => const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text("Không thể tải lịch học"),),
                            ),
                          );
                        },
                        error: (e,__) => Center(child: Text(e.toString())), 
                        loading: () => SizedBox(
                          height: MediaQuery.of(context).size.height * .5,
                          child: const Center(child: CircularProgressIndicator())
                        )
                      )
                    )
                  )
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}