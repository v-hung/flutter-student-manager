import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/components/student/study/line_bar.dart';
import 'package:flutter_student_manager/models/SubjectModel.dart';
import 'package:flutter_student_manager/models/TestMarkModel.dart';
import 'package:intl/intl.dart';

class TestMarkWidget extends ConsumerStatefulWidget {
  final SubjectModel testMark;
  final int index;
  const TestMarkWidget({required this.testMark, required this.index, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestMarkWidgetState();
}

class _TestMarkWidgetState extends ConsumerState<TestMarkWidget> {
  bool char = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!)
              )
            ),
            child: Text("${widget.index + 1}. ${widget.testMark.name}", style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500
            ),),
          ),
          const SizedBox(height: 5,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => setState(() { char = false; }),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: char == false ? Colors.green : Colors.grey
                  ),
                  child: const Text("Danh sách", style: TextStyle(
                    fontSize: 12,
                    color: Colors.white
                  ),),
                ),
              ),
              InkWell(
                onTap: () => setState(() { char = true; }),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: char == true ? Colors.green : Colors.grey
                  ),
                  child: const Text("Biểu đồ", style: TextStyle(
                    fontSize: 12,
                    color: Colors.white
                  ),),
                ),
              ),
            ],
          ),

          char ? Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.only(top: 15, left: 5, right: 5),
            child: LineBar(test_marks: widget.testMark.test_marks),
          )
          : Container(
            constraints: const BoxConstraints(
              maxHeight: 200
            ),
            child: SingleChildScrollView(
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                      for(var i = 0; i < widget.testMark.test_marks.length; i++) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            border: i != 0 ? Border(
                              bottom:  BorderSide(color: Colors.grey[300]!)
                            ): null
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Điểm / Bài tập", style: TextStyle(
                                // fontWeight: FontWeight.w500,
                                // color: Colors.grey
                              ),),
                              const SizedBox(width: 10,),
                              Text("${widget.testMark.test_marks[i].point} | ${widget.testMark.test_marks[i].getExercise()}", style: const TextStyle(
                                fontWeight: FontWeight.w500
                              ),),
                              const SizedBox(width: 10,),
                              Text(DateFormat("dd/MM/yyyy").format(widget.testMark.test_marks[i].date), style: const TextStyle(
                                // fontWeight: FontWeight.w500,
                                color: Colors.grey
                              ),),
                            ],
                          ),
                        )
                      ],
                      const SizedBox(height: 10,),
                    ],
                  ),
              ),
            ),
          )
        ],
      ),
    );
  }
}