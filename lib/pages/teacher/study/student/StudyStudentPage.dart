import 'dart:async';

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
import 'package:flutter_student_manager/repositories/TeacherRepository.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
  final GlobalKey<FormState> formKeyEdit = GlobalKey<FormState>();
  
  final pointController = TextEditingController();
  String? exerciseValue;
  String? subjectValue;
  final pointEditController = TextEditingController();
  final dateEditController = TextEditingController();
  String? exerciseEditValue;
  String? subjectEditValue; 
  bool loading = false;
  String? testMarkUpdateId;
  
  Future save({bool edit = false}) async {
    if (loading) {
      return;
    }

    if (edit) {
      if (!formKeyEdit.currentState!.validate()) {
        return;
      }
    }
    else {
      if (!formKey.currentState!.validate()) {
        return;
      }
    }

    setState(() {
      loading = true;
    });

    TestMarkModel? testMark = !edit ? await ref.read(teacherRepositoryProvider)
      .addTestMarks(widget.id, subjectValue ?? "", pointController.text, exerciseValue ?? "")
    : await ref.read(teacherRepositoryProvider)
      .updateTestMarks(testMarkUpdateId ?? "", widget.id, subjectEditValue ?? "", 
      pointEditController.text, exerciseEditValue ?? "", dateEditController.text);

    setState(() {
      loading = false;
    });

    if (testMark != null) {
      if (!edit) {
        ref.read(testMarksProvider(widget.id).notifier).add(testMark);
      }
      else {
        ref.read(testMarksProvider(widget.id).notifier).add(testMark);
      }

      if (context.mounted) {
        late Timer _timer;

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            _timer = Timer(const Duration(seconds: 1), () {
              Navigator.of(context).pop();
            });
            return const AlertWidget(type: AlertEnum.success,);
          }
        );

        if (_timer.isActive) {
          _timer.cancel();
        }
      }
    }
    else {
      if (context.mounted) {
        showSnackBar(context: context, content: "Không thể cập nhập thông tin, vui lòng thử lại sau");
      }
    }
  }

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
    pointEditController.dispose();
    dateEditController.dispose();
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

          if (testMarkNow != null) {
            if (pointController.text.isEmpty) {
              pointController.text = testMarkNow.point.toString();
            }
            exerciseValue ??= testMarkNow.exercise?.type;
            subjectValue ??= testMarkNow.subject?.id.toString();
          }

          return Stack(
            children: [
              Container(),
              SingleChildScrollView(
                child: IntrinsicHeight(
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
                                    validator: (value) =>
                                      value!.isEmpty ? 'Điểm kiểm tra trên lớp không được để trống' : null,
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
                                    validator: (value) =>
                                      value == null ? 'Bài tập về nhà không được để trống' : null,
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
                                    validator: (value) =>
                                      value == null ? 'Môn không được để trống' : null,
                                  ),
                                      
                                  const SizedBox(height: 15,),
                                  ElevatedButton(
                                    onPressed: save,
                                    child: const Text("Lưu"),
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
                          child: Column(
                            children: testMarksData.testMarks.map((testMark) {
                              // final testMark = testMarksData.testMarks[index];
                              return Slidable(
                                key: UniqueKey(),
                                endActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  dragDismissible: true,
                                  dismissible: DismissiblePane(
                                    closeOnCancel: true,
                                    dismissThreshold: 0.9,
                                    onDismissed: () {
                                      ref.read(testMarksProvider(widget.id).notifier).delete(testMark.id);
                                    }, 
                                    confirmDismiss: () async {
                                      return await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Xóa điểm"),
                                            content: Text("Bạn có chắc chắn muốn xóa điểm ngày'${DateFormat("dd/MM/yyyy").format(testMark.date)}'"),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Không', style: TextStyle(color: Colors.grey[800]!),),
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Xóa', style: TextStyle(color: Colors.red),),
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      ) ?? false;
                                    }
                                  ),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: Colors.red,
                                      icon: CupertinoIcons.trash,
                                      label: 'Xóa',
                                      onPressed: (context) async {
                                        bool isDel = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Xóa điểm"),
                                              content: Text("Bạn có chắc chắn muốn xóa điểm ngày'${DateFormat("dd/MM/yyyy").format(testMark.date)}'"),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Không', style: TextStyle(color: Colors.grey[800]!),),
                                                  onPressed: () {
                                                    Navigator.pop(context, false);
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('Xóa', style: TextStyle(color: Colors.red),),
                                                  onPressed: () {
                                                    Navigator.pop(context, true);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        ) ?? false;
                
                                        if (isDel) {
                                          ref.read(testMarksProvider(widget.id).notifier).delete(testMark.id);
                                        }
                                      },
                                    )
                                  ],
                                ),
                                child: Container(
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
                                            onPressed: () async {
                                              bool isSave = await modalEdit(testMark) ?? false;
                                              if (isSave) {
                                                save(edit: true);
                                              }
                                            }, 
                                            style: TextButton.styleFrom(backgroundColor: Colors.green[100]),
                                            child: const Text("Chỉnh sửa")
                                          ) 
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      ) : const Center(child: Text("Chưa có điểm nào"))
                    ],
                  ),
                ),
              ),

              loading ? Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator(),),
                ),
              ) : const SizedBox()
            ],
          );
        }
      ),
    );
  }

  Future modalEdit(TestMarkModel testMark) {
    pointEditController.text = testMark.point.toString();
    exerciseEditValue = testMark.exercise?.type;
    subjectEditValue = testMark.subject?.id.toString();
    dateEditController.text = DateFormat("dd/MM/yyyy").format(testMark.date);
    selectedDate = testMark.date;
    testMarkUpdateId = testMark.id.toString();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Điểm kiểm tra ngày ${DateFormat("dd/MM/yyyy").format(testMark.date)}"),
          content: Form(
            key: formKeyEdit,
            child: IntrinsicHeight(
              child: Column(
                children: [
                  TextFormField(
                    controller: pointEditController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                      NumericalRangeFormatter(min: 0, max: 10),
                    ],
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                    decoration: InputDecoration(
                      labelText: "Điểm kiểm tra trên lớp",
                    ),
                    validator: (value) =>
                      value!.isEmpty ? 'Điểm kiểm tra trên lớp không được để trống' : null,
                  ),
                  const SizedBox(height: 15,),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      hintText: 'Điểm bài tập về nhà',
                    ),
                    items: const [
                      DropdownMenuItem(value: "khonglam",child: Text("Không làm"),),
                      DropdownMenuItem(value: "khongdat",child: Text("Không đạt"),),
                      DropdownMenuItem(value: "dat",child: Text("Đạt"),)
                    ],
                    value: exerciseEditValue,
                    onChanged: (value) {
                      setState(() {
                        exerciseEditValue = value;
                      });
                    },
                    validator: (value) =>
                      value == null ? 'Điểm bài tập về nhà không được để trống' : null,
                  ),
              
                  const SizedBox(height: 15,),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      hintText: 'Môn học',
                    ),
                    items: subjects.map((e) => 
                      DropdownMenuItem(value: e.id.toString(),child: Text(e.name),),).toList(),
                    value: subjectEditValue,
                    onChanged: (value) {
                      setState(() {
                        subjectEditValue = value;
                      });
                    },
                    validator: (value) =>
                      value == null ? 'Môn học không được để trống' : null,
                  ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    controller: dateEditController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                      labelText: "Ngày chấm",
                    ),
                    validator: (value) =>
                      value!.isEmpty ? 'Ngày không được để trống' : null,
                  ),
                ],
              ),
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

  late DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context);
    }
  }

  /// This builds material date picker in Android
  buildMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale("vi"),
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateEditController.text = DateFormat("yyyy-MM-dd").format(picked);
      });
    }
  }

  /// This builds cupertion date picker in iOS
  buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (picked) {
              if (picked != null && picked != selectedDate) {
                setState(() {
                  selectedDate = picked;
                  dateEditController.text = DateFormat("yyyy-MM-dd").format(picked);
                });
              }
            },
            initialDateTime: selectedDate,
            minimumYear: 1900,
            maximumYear: DateTime.now().year + 5,
          ),
        );
      }
    );
  }
}