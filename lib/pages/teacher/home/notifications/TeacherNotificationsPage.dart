import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/student/bottom_navbar_student.dart';
import 'package:flutter_student_manager/components/teacher/notifications/notification_widget.dart';
import 'package:flutter_student_manager/controllers/teacher/BreakSchoolController.dart';
import 'package:flutter_student_manager/models/CodeScanModel.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TeacherNotificationsPage extends ConsumerStatefulWidget {
  const TeacherNotificationsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeacherNotificationsPageState();
}

class _TeacherNotificationsPageState extends ConsumerState<TeacherNotificationsPage> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        ref.read(breakSchoolControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final heightSafeArea = size.height -
      AppBar().preferredSize.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom;

    // final breakSchools = ref.watch(breakSchoolsStreamProvider);
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
        title: const Text("Xin nghỉ"),
      ),
      body: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: heightSafeArea
        ),
        child: Consumer(
          builder: (context, ref, child) {
            final breakSchoolsData = ref.watch(breakSchoolControllerProvider);
            if (breakSchoolsData.loading) {
              return const Center(child: CircularProgressIndicator(),);
            }

            final breakSchools = breakSchoolsData.breakSchools;

            if (breakSchools.isEmpty) {
              return const Center(child: Text("Không có xin nghỉ nào"),);
            }

            return RefreshIndicator(
              onRefresh: () => ref.read(breakSchoolControllerProvider.notifier).loadData(),
              child: Container(
                width: double.infinity,
                height: heightSafeArea,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  itemCount: breakSchools.length + 1,
                  itemBuilder: (context, index) {
                    if (index == breakSchools.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Center(
                          child: breakSchoolsData.current_page < breakSchoolsData.last_page 
                            ? const CircularProgressIndicator()
                            : const Text("Không còn xin nghỉ"),
                        ),
                      );
                    }
                          
                    final breakSchool = breakSchools[index];
                    return Container(
                      // margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.circular(7),
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]!)
                        )
                      ),
                      child: NotificationTeacherWidget(breakSchool: breakSchool),
                    );
                  },
                ),
              ),
            );
          }
        ),
      )
    );
  }
}