import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/student/bottom_navbar_student.dart';
import 'package:flutter_student_manager/components/student/notifications/notification_widget.dart';
import 'package:flutter_student_manager/controllers/student/CodeScanController.dart';
import 'package:flutter_student_manager/models/CodeScanModel.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        ref.read(codeScanControllerProvider.notifier).loadMore();
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
        constraints: BoxConstraints(
          minHeight: heightSafeArea
        ),
        child: Consumer(
          builder: (context, ref, child) {
            final codeScansData = ref.watch(codeScanControllerProvider);
            if (codeScansData.loading) {
              return const Center(child: CircularProgressIndicator(),);
            }

            final codeScans = codeScansData.codeScans;

            if (codeScans.isEmpty) {
              return const Center(child: Text("Không có xin nghỉ nào"),);
            }

            return RefreshIndicator(
              onRefresh: () => ref.read(codeScanControllerProvider.notifier).loadData(),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: scrollController,
                itemCount: codeScans.length + 1,
                itemBuilder: (context, index) {
                  if (index == codeScans.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Center(
                        child: codeScansData.current_page < codeScansData.last_page 
                          ? const CircularProgressIndicator()
                          : const Text("Không còn xin nghỉ"),
                      ),
                    );
                  }

                  final codeScan = codeScans[index];
                  
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
                    child: StudentNotificationWidget(codeScan: codeScan),
                  );
                }
              )
            );
          }
        ),
      )
    );
  }
}