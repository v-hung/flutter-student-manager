import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/models/CodeScanModel.dart';
import 'package:intl/intl.dart';

class StudentNotificationWidget extends ConsumerStatefulWidget {
  final CodeScanModel codeScan;
  const StudentNotificationWidget({required this.codeScan, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudentNotificationWidgetState();
}

class _StudentNotificationWidgetState extends ConsumerState<StudentNotificationWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(widget.codeScan.action == "in" ? "Đến Trường" : "Về nhà", style: TextStyle(
                fontSize: 12,
                color: widget.codeScan.action == "in" ? Colors.green[900] : Colors.deepOrange[900]
              ),),
            ),
            const SizedBox(width: 5,),
            Text(DateFormat("dd/MM/yyy").format(widget.codeScan.date_time), style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800]
            ),),
          ],
        ),
        const SizedBox(height: 5,),
        Text(widget.codeScan.title, style: const TextStyle(
          // color: Colors.grey[800],
          // fontSize: 16,
          fontWeight: FontWeight.w500
        ),),
      ],
    );
  }
}