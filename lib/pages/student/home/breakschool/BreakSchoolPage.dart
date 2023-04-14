import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/student/bottom_navbar_student.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/controllers/student/BreakSchoolController.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class BreakSchoolPage extends ConsumerStatefulWidget {
  const BreakSchoolPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BreakSchoolPageState();
}

class BreakSchoolPageState extends ConsumerState<BreakSchoolPage> {
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
      firstDate: DateTime(2000),
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
            minimumYear: 2000,
            maximumYear: DateTime.now().year + 5,
          ),
        );
      }
    );
  }

  final dateController = TextEditingController();
  final reasonController = TextEditingController();
  late bool loadingAsk = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future askForPermission() async {
    if (loadingAsk) {
      return;
    }

    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loadingAsk = true;
    });

    bool isSuccess = await ref.read(breakSchoolControllerProvider.notifier)
      .askForPermission(context, reasonController.text, DateTime.parse(dateController.text));

    if (isSuccess) {
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

        reasonController.text = "";
        dateController.text = "";
      }
    }
    else {
      if (context.mounted) {
        showSnackBar(context: context, content: "Không thể xin nghỉ, vui lòng thử lại sau");
      }
    }

    setState(() {
      loadingAsk = false;
    });
  }

  @override
  void dispose() {
    dateController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final heightSafeArea = size.height -
      AppBar().preferredSize.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom;

    final data = ref.watch(breakSchoolControllerProvider);
    final user = ref.watch(authControllerProvider).user as StudentModel;
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
        title: const Text("Xin nghỉ học", style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        constraints: BoxConstraints(
          minHeight: heightSafeArea
        ),
        child: RefreshIndicator(
          onRefresh: () => ref.read(breakSchoolControllerProvider.notifier).loadData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final check = ref.watch(breakSchoolControllerProvider.notifier).checkNowBreakSchool();
                    if (check) {
                      return Container(
                        margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.green[200],
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Text("Bạn đã xin nghỉ ngày hôm nay", style: TextStyle(
                          color: Colors.green[700]
                        ),),
                      );
                    }
                    else {
                      return Container();
                    }
                  },
                ),
                
                Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        const Text("Đơn xin nghỉ học", textAlign: TextAlign.center, style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700
                        ),),
                        const SizedBox(height: 20,),
                        TextFormField(
                          initialValue: user.name,
                          // controller: TextEditingController(text: user.name),
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Học sinh',
                            // prefixIcon: Icon(CupertinoIcons.person_fill),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        TextFormField(
                          controller: dateController,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          decoration: const InputDecoration(
                            labelText: 'Ngày nghỉ',
                          ),
                          validator: (value) =>
                            value!.isEmpty ? 'Ngày không được để trống' : null,
                        ),
                        const SizedBox(height: 20,),
                        TextFormField(
                          controller: reasonController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Lý do xin nghỉ',
                          ),
                          validator: (value) =>
                            value!.isEmpty ? 'Lý do không được để trống' : null,
                        ),
                          
                        const SizedBox(height: 20,),
                        
                        SizedBox(
                          child: ElevatedButton(
                            onPressed: askForPermission,
                            child: loadingAsk ? const CircularProgressIndicator() : const Text("Xin nghỉ"),
                            // onPressed: loading ? null : signInWithPassword,
                            // child: loading ? const CircularProgressIndicator() : const Text("Login"),
                          )
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                      const Text("Lịch sử xin nghỉ", textAlign: TextAlign.left, style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700
                      ),),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Consumer(
                          builder: (context, ref, child) {
                            final data = ref.watch(breakSchoolControllerProvider);
                            if (data.loading) {
                              return const Center(child: CircularProgressIndicator(),);
                            }
                            else {
                              return ListView.builder(
                                itemCount: data.breakSchools.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final breakSchool = data.breakSchools[index];
                                  return Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: index < data.breakSchools.length - 1 ? BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Colors.grey[300]!)
                                      )
                                    ) : null,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: Text(breakSchool.reason, style: const TextStyle(
                                                // color: Colors.grey[800],
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500
                                              ),),
                                            ),
                                            const SizedBox(height: 5,),
                                            Transform.translate(
                                              offset: const Offset(0, 5),
                                              child: Text(DateFormat("dd/MM/yyyy").format(breakSchool.date), style: TextStyle(
                                                color: Colors.grey[800]
                                              ),),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }

                          },
                        )
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
