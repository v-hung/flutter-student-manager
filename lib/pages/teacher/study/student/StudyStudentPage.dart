import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/components/expanded_section.dart';
import 'package:flutter_student_manager/controllers/teacher/StudentController.dart';
import 'package:flutter_student_manager/controllers/teacher/SubjectController.dart';
import 'package:flutter_student_manager/controllers/teacher/TestMarkController.dart';
import 'package:flutter_student_manager/models/SubjectModel.dart';
import 'package:flutter_student_manager/models/TestMarkModel.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class StudyStudentPage extends ConsumerStatefulWidget {
  final String id;
  const StudyStudentPage({required this.id, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudyStudentPageState();
}

class _StudyStudentPageState extends ConsumerState<StudyStudentPage> {
  List<SubjectModel> subjects = [];
  bool expandAdd = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final pointController = TextEditingController();
  String? exerciseValue = null;
  String? subjectValue = null;
  
  void load() async {
    subjects = await ref.read(subjectsFutureProvider.future).onError((error, stackTrace) => []);
    setState(() {});
  }

  void initState() {
    super.initState();
    load();
  }

  void dispose() {
    pointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final student = ref.watch(studentFutureProvider(widget.id));
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
        title: Text(student.whenData((value) => value).value?.name ?? "Điểm kiểm tra"),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(CupertinoIcons.back)
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final testMarksData = ref.watch(testMarksProvider(widget.id));

          if (testMarksData.loading) {
            return const Center(child: CircularProgressIndicator(),);
          }

          TestMarkModel? testMarkNow = testMarksData.testMarks.firstWhereOrNull((element) => 
            DateFormat("dd/MM/yyyy").format(element.date) == DateFormat("dd/MM/yyyy").format(DateTime.now()));

          return Container(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    // border: Border.all(color: Colors.grey[200]!)
                  ),
                  child: Column(
                    children: [
                      Text("Chấm điểm hôm nay ${testMarkNow != null ? "(Đã chấm)" : ""}", style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      ),),
          
                      ExpandedSection(expand: expandAdd, child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),
                            TextFormField(
                              controller: pointController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                                NumericalRangeFormatter(min: 0, max: 10),
                              ],
                              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                              decoration: InputDecoration(
                                labelText: "Điểm kiểm tra trên lớp",
                              ),
                            ),
                            const SizedBox(height: 15,),
                            DropdownButtonFormField(
                              decoration: const InputDecoration(
                                hintText: 'Điểm bài tập về nhà',
                              ),
                              items: const [
                                // DropdownMenuItem(value: 0,child: Text("Không chọn", style: TextStyle(
                                //   color: Colors.grey
                                // ),)),
                                DropdownMenuItem(value: "khonglam",child: Text("Không làm"),),
                                DropdownMenuItem(value: "khongdat",child: Text("Không đạt"),),
                                DropdownMenuItem(value: "dat",child: Text("Đạt"),)
                              ],
                              value: exerciseValue,
                              onChanged: (value) {
                                setState(() {
                                  exerciseValue = value;
                                });
                              },
                            ),
                                
                            const SizedBox(height: 15,),
                            DropdownButtonFormField(
                              decoration: const InputDecoration(
                                hintText: 'Môn học',
                              ),
                              items: subjects.map((e) => 
                                DropdownMenuItem(value: e.id.toString(),child: Text(e.name),),).toList(),
                              value: subjectValue,
                              onChanged: (value) {
                                setState(() {
                                  subjectValue = value;
                                });
                              },
                            ),
                                
                            const SizedBox(height: 15,),
                            ElevatedButton(
                              onPressed: () {
                                // ref.read(classroomStatusProvider.notifier).changeStatus(idCheck!);
                                // context.pop();
                              },
                              child: Text("Lưu"),
                            ),
                          ],
                        ),
                      )),
          
                      const SizedBox(height: 15,),
          
                      InkWell(
                        onTap: () => setState(() {
                          expandAdd = !expandAdd;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.grey[300]!)
                            )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: expandAdd ? const [
                              Center(child: Text("Thu nhỏ chấm điểm")),
                              SizedBox(width: 5,),
                              Icon(CupertinoIcons.chevron_up, size: 18,)
                            ] : const [
                              Center(child: Text("Hiện chấm điểm")),
                              SizedBox(width: 5,),
                              Icon(CupertinoIcons.chevron_down, size: 18,)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          
                testMarksData.testMarks.isNotEmpty ? Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ListView.builder(
                      itemCount: testMarksData.testMarks.length,
                      itemBuilder: (context, index) {
                        final testMark = testMarksData.testMarks[index];
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[300]!)
                            )
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(testMark.subject?.name ?? "", style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700]
                                  ),),
                                  Text(DateFormat("dd/MM/yyy").format(testMark.date), style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[800]
                                  ),),
                                ],
                              ),
                              const SizedBox(height: 5,),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text("Điểm trên lớp", style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),),
                                      SizedBox(height: 5,),
                                      Text("Điểm về nhà  ", style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),),
                                    ],
                                  ),
                                  const SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(testMark.point.toString(), style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),),
                                      const SizedBox(height: 5,),
                                      Text(testMark.getExercise(), style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),),
                                    ],
                                  ),
                                  const SizedBox(width: 10,),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () => modalEdit(), 
                                    style: TextButton.styleFrom(backgroundColor: Colors.green[100]),
                                    child: const Text("Chỉnh sửa")
                                  ) 
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ) : const Text("Chưa có điểm nào")
              ],
            ),
          );
        }
      ),
    );
  }

  Future modalEdit() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Điểm kiểm tra ngày 20/12/2023"),
          content: IntrinsicHeight(
            child: Column(
              children: [
                TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                    NumericalRangeFormatter(min: 0, max: 10),
                  ],
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                  decoration: InputDecoration(
                    labelText: "Điểm kiểm tra trên lớp",
                  ),
                ),
                const SizedBox(height: 15,),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    hintText: 'Điểm bài tập về nhà',
                  ),
                  items: const [
                    // DropdownMenuItem(value: 0,child: Text("Không chọn", style: TextStyle(
                    //   color: Colors.grey
                    // ),)),
                    DropdownMenuItem(value: "khonglam",child: Text("Không làm"),),
                    DropdownMenuItem(value: "khongdat",child: Text("Không đạt"),),
                    DropdownMenuItem(value: "dat",child: Text("Đạt"),)
                  ],
                  // value: classroomValue,
                  onChanged: (value) {
                    setState(() {
                      // classroomValue = value == 0 ? null : value;
                    });
                  },
                ),
    
                const SizedBox(height: 15,),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    hintText: 'Môn học',
                  ),
                  items: subjects.map((e) => 
                    DropdownMenuItem(value: e.id,child: Text(e.name),),).toList(),
                  // value: classroomValue,
                  onChanged: (value) {
                    setState(() {
                      // classroomValue = value == 0 ? null : value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Trở lại'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Lưu'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }
}