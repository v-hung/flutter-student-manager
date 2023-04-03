import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/student/bottom_navbar_student.dart';
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final heightSafeArea = size.height -
      AppBar().preferredSize.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom;

    final codeScans = ref.watch(codeScansStreamProvider);
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
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: heightSafeArea
          ),
          child: codeScans.when(
            data: (codeScans) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: codeScans.map((codeScan) => 
                  Container(
                    // margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(7),
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!)
                      )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(codeScan.action == "in" ? "Đến Trường" : "Về nhà", style: TextStyle(
                                color: codeScan.action == "in" ? Colors.green[700] : Colors.orange[700]
                              ),),
                            ),
                            const SizedBox(width: 5,),
                            Text(DateFormat("dd/MM/yyy").format(codeScan.date_time), style: TextStyle(
                              color: Colors.grey[800]
                            ),),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Text(codeScan.title, style: const TextStyle(
                          // color: Colors.grey[800],
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),),
                      ],
                    ),
                  )
                ).toList(),
              );
            }, 
            error: (_,__) => const Center(child: Text("error")), 
            loading: () => const Center(child: CircularProgressIndicator(),)
          ),
        ),
      )
    );
  }
}