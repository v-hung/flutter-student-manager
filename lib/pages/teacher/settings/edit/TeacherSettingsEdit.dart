import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/models/TeacherModel.dart';
import 'package:flutter_student_manager/repositories/StudentRepository.dart';
import 'package:flutter_student_manager/repositories/TeacherRepository.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class TeacherSettingsEditPage extends ConsumerStatefulWidget {
  const TeacherSettingsEditPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeacherSettingsEditPageState();
}

class _TeacherSettingsEditPageState extends ConsumerState<TeacherSettingsEditPage> {
  String? imageUrl;
  final nameController = TextEditingController(); 
  String? genderValue = null;
  final dateController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;
  bool loading = false;
  late BuildContext dialogContext;
  final ImagePicker picker = ImagePicker();
  XFile? file;

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
      displaySheet();
    });

    TeacherModel? teacher = await ref.read(teacherRepositoryProvider)
      .updateTeacherInfoById(file, nameController.text, genderValue ?? "", dateController.text, 
      addressController.text, phoneController.text, emailController.text, passwordController.text);

    setState(() {
      loading = false;
      Navigator.pop(dialogContext);
    });

    if (teacher != null) {
      ref.read(authControllerProvider.notifier).updateUserInfo(teacher);
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
        if (context.mounted) context.go('/teacher/settings');
      }
    }
    else {
      if (context.mounted) {
        showSnackBar(context: context, content: "Không thể cập nhập thông tin, vui lòng thử lại sau");
      }
    }
  }

  void displaySheet(){
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
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

    final user = ref.read(authControllerProvider).user as TeacherModel;

    imageUrl = user.avatar;

    nameController.text = user.name;
    if (user.date_of_birth != null) {
      dateController.text = DateFormat("yyyy-MM-dd").format(user.date_of_birth!);
    }
    if (user.sex != null) {
      genderValue = user.sex;
    }
    if (user.phone != null) {
      phoneController.text = user.phone!;
    }
    if (user.address != null) {
      addressController.text = user.address!;
    }
    if (user.email != null) {
      emailController.text = user.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(authControllerProvider).user as TeacherModel;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0),
        leading: TextButton(
          onPressed: () => context.pop(),
          child: const Text("Hủy"),
        ),
        actions: [
          TextButton(
            onPressed: save,
            child: const Text("Lưu"),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
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
                      child: TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          hintText: 'Số điện thoại',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                        ),
                      ),
                    )
                  ]),
                ),
          
                const SizedBox(height: 20,),
                Text("Nâng cao", style: TextStyle(
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
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Tài khoản',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                        ),
                      ),
                    )
                  ]),
                )
              ],
            ),
          ),
        ),
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