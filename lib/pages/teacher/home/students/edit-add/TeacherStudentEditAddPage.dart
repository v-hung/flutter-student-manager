import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/teacher/ClassroomsController.dart';
import 'package:flutter_student_manager/controllers/teacher/SubjectController.dart';
import 'package:flutter_student_manager/controllers/teacher/StudentController.dart';
import 'package:flutter_student_manager/models/ClassroomModel.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/models/SubjectModel.dart';
import 'package:flutter_student_manager/repositories/TeacherRepository.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class TeacherStudentEditAddPage extends ConsumerStatefulWidget {
  final String id;
  const TeacherStudentEditAddPage({required this.id,  super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeacherStudentEditAddPageState();
}

class _TeacherStudentEditAddPageState extends ConsumerState<TeacherStudentEditAddPage> {
  String? imageUrl;
  final nameController = TextEditingController(); 
  // final genderController = TextEditingController();
  final dateController = TextEditingController();
  final addressController = TextEditingController();
  final infoController = TextEditingController();
  final phoneController = TextEditingController();
  final phone2Controller = TextEditingController();
  final emailController = TextEditingController();
  final scoreController = TextEditingController();
  final tuitionController = TextEditingController();
  int? classroomValue = null;
  String? genderValue = null;
  List<int> subjectsValue = [];
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;
  bool loading = true;
  late BuildContext dialogContext;
  final ImagePicker picker = ImagePicker();
  XFile? file;
  List<ClassroomModel> classrooms = [];
  List<SubjectModel> subjects = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future save() async {
    if (loading) {
      return;
    }

    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    StudentModel? student = widget.id == "" ? await ref.read(teacherRepositoryProvider).createStudent(
      nameController.text, dateController.text, addressController.text, infoController.text, 
      phoneController.text, phone2Controller.text, scoreController.text, tuitionController.text, 
      classroomValue != null ? classroomValue.toString() : "", 
      genderValue ?? "", usernameController.text, passwordController.text, subjectsValue.toString(), file
    )
    : await ref.read(teacherRepositoryProvider).updateStudentInfoById(
      widget.id, nameController.text, dateController.text, addressController.text, 
      infoController.text, phoneController.text, phone2Controller.text,
      scoreController.text, tuitionController.text, classroomValue != null ? classroomValue.toString() : "", 
      genderValue ?? "", usernameController.text, passwordController.text, subjectsValue.toString(), file
    );

    setState(() {
      loading = false;
    });

    if (student != null) {
      // ref.read(authControllerProvider.notifier).updateUserInfo(student);
      if (widget.id != "") {
        ref.refresh(studentFutureProvider(widget.id).future);
      }
      ref.read(studentControllerProvider.notifier).refresh();

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

        await Future.delayed(const Duration(milliseconds: 300));
        if (context.mounted) context.go('/teacher/students');
      }
    }
    else {
      if (context.mounted) {
        showSnackBar(context: context, content: "Không thể cập nhập thông tin, vui lòng thử lại sau");
      }
    }
  }

  void selectImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        file = image;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    StudentModel? student;
    classrooms = await ref.read(classroomsFutureProvider.future).onError((error, stackTrace) => []);
    subjects = await ref.read(subjectsFutureProvider.future).onError((error, stackTrace) => []);

    if (widget.id != "") {
      student = await (ref.read(studentFutureProvider(widget.id).future) as Future<StudentModel?>).onError((error, stackTrace) => null);

      imageUrl = student?.avatar;

      nameController.text = student?.name ?? "";
      if (student?.date_of_birth != null) {
        dateController.text = student?.date_of_birth != null ? DateFormat("yyyy-MM-dd").format(student!.date_of_birth!) : "";
      }
      if (student?.gender != null) {
        genderValue = student?.gender ?? "";
      }
      if (student?.contact_info != null) {
        infoController.text = student?.contact_info ?? "";
      }
      if (student?.phone != null) {
        phoneController.text = student?.phone ?? "";
      }
      if (student?.phone2 != null) {
        phone2Controller.text = student?.phone2 ?? "";
      }
      if (student?.address != null) {
        addressController.text = student?.address ?? "";
      }
      if (student?.entrance_exam_score != null) {
        scoreController.text = student?.entrance_exam_score.toString() ?? "";
      }
      if (student?.tuition != null) {
        tuitionController.text = student?.tuition.toString() ?? "";
      }

      if (student?.username != null) {
        usernameController.text = student?.username ?? "";
      }

      subjectsValue = student?.subjects.map((e) => e.id).toList() ?? [];

      classroomValue = student?.class_id ?? null;
    }

    setState(() {
      loading = false;
    });
  }

  @override 
  void dispose() {
    nameController.dispose(); 
    dateController.dispose();
    addressController.dispose();
    infoController.dispose();
    phoneController.dispose();
    phone2Controller.dispose();
    emailController.dispose();
    scoreController.dispose();
    tuitionController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: TextButton(
          onPressed: () => context.pop(),
          child: const Text("Hủy"),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
          )
        ),
        title: Text(widget.id == "" ? "Thêm học sinh" : "Sửa học sinh", style: const TextStyle(color: Colors.green),),
        actions: [
          TextButton(
            onPressed: save,
            child: widget.id != "" ? const Text("Lưu") : const Text("Thêm"),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: InkWell(
                        onTap: selectImage,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            shape: BoxShape.circle,
                            image: file != null ? DecorationImage(
                              image: FileImage(File(file!.path)),
                              fit: BoxFit.cover
                            ) : imageUrl != null ? DecorationImage(
                              image: NetworkImage(toImage(imageUrl!)),
                              fit: BoxFit.cover
                            ) : null
                          ),
                          child: imageUrl != null ? null : const Icon(CupertinoIcons.camera, color: Colors.green,),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Text("Thông tin cơ bản", style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600
                    ),),
                    const SizedBox(height: 5,),
                    Container(
                      // padding: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ]
                      ),
                      child: Column(children: [
                        Container(
                          decoration: BoxDecoration(border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!)
                          )),
                          child: TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              hintText: 'Họ tên',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                            ),
                            validator: (value) =>
                              value!.isEmpty ? 'Họ tên không được để trống' : null,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!)
                          )),
                          child: Container(
                            width: double.infinity,
                            child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                hintText: 'Giới tính',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                              ),
                              items: const [
                                DropdownMenuItem(value: "nam",child: Text("Nam")),
                                DropdownMenuItem(value: "nu",child: Text("Nữ")),
                              ],
                              value: genderValue,
                              onChanged: (value) {
                                setState(() {
                                  genderValue = value.toString();
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!)
                          )),
                          child: TextField(
                            controller: dateController,
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            decoration: const InputDecoration(
                              hintText: 'Ngày sinh',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!)
                          )),
                          child: TextField(
                            controller: addressController,
                            decoration: const InputDecoration(
                              hintText: 'Địa chỉ',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!)
                          )),
                          child: TextField(
                            controller: infoController,
                            keyboardType: TextInputType.multiline,
                            minLines: 2,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              hintText: 'Thông tin liên hệ',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!)
                          )),
                          child: TextField(
                            controller: phoneController,
                            decoration: const InputDecoration(
                              hintText: 'Số điện thoại mẹ',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!)
                          )),
                          child: TextField(
                            controller: phone2Controller,
                            decoration: const InputDecoration(
                              hintText: 'Số điện thoại bố',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!)
                          )),
                          child: TextField(
                            controller: scoreController,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Điểm đầu vào',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!)
                          )),
                          child: TextField(
                            controller: tuitionController,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Học phí',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!)
                          )),
                          child: Container(
                            width: double.infinity,
                            child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                hintText: 'Lớp',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                              ),
                              items: [
                                const DropdownMenuItem(value: 0,child: Text("Không chọn", style: TextStyle(
                                  color: Colors.grey
                                ),)),
                                for(var i = 0; i < classrooms.length; i++) ...[
                                  DropdownMenuItem(value: classrooms[i].id,child: Text(classrooms[i].name),)
                                ]
                              ],
                              value: classroomValue,
                              onChanged: (value) {
                                setState(() {
                                  classroomValue = value == 0 ? null : value;
                                });
                              }
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: MultiSelectDialogField(
                            title: const Text("Chọn môn"),
                            buttonText: Text("Môn học", style: TextStyle(
                              color: Colors.grey[700]!,
                              fontWeight: FontWeight.w500
                            ),),
                            confirmText: const Text("Chọn"),
                            cancelText: const Text("Hủy"),
                            buttonIcon: const Icon(CupertinoIcons.book),
                            decoration: const BoxDecoration(border: Border()),
                            items: subjects.map((e) => MultiSelectItem(e.id, e.name)).toList(),
                            listType: MultiSelectListType.LIST,
                            initialValue: subjectsValue,
                            onConfirm: (values) {
                              setState(() {
                                subjectsValue = values;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 5,)
                      ]),
                    ),
              
                    const SizedBox(height: 20,),
                    Text("Nâng cao", style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600
                    ),),
                    const SizedBox(height: 5,),
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ]
                      ),
                      child: Column(children: [
                        Container(
                          decoration: BoxDecoration(border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!)
                          )),
                          child: TextField(
                            controller: usernameController,
                            decoration: const InputDecoration(
                              hintText: 'Tài khoản',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 13, bottom: 13, right: 15),
                            ),
                          ),
                        ),
                        Container(
                          child: TextField(
                            controller: passwordController,
                            obscureText: !showPassword,
                            decoration: InputDecoration(
                              hintText: 'Mật khẩu',
                              suffixIcon: IconButton(
                                onPressed: () => setState(() {showPassword = !showPassword;}),
                                icon: Icon(showPassword ? CupertinoIcons.lock_open : CupertinoIcons.lock)
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 13, bottom: 13, right: 15),
                            ),
                          ),
                        )
                      ]),
                    ),

                    const SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          ),
          loading ? Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ) : const SizedBox()
        ],
      ),
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
        dateController.text = DateFormat("yyyy-MM-dd").format(picked);
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
                  dateController.text = DateFormat("yyyy-MM-dd").format(picked);
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