import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/student/bottom_navbar_student.dart';
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
      lastDate: DateTime(2025),
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
            maximumYear: 2025,
          ),
        );
      }
    );
  }

  final dateController = TextEditingController();
  final reasonController = TextEditingController();

  @override
  void dispose() {
    dateController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        shape: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
        title: const Text("Xin nghỉ học"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(5)
              ),
              child: Text("Bạn đã xin nghỉ ngày hôm nay", style: TextStyle(
                color: Colors.green[700]
              ),),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  const Text("Đơn xin nghỉ học", textAlign: TextAlign.center, style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700
                  ),),
                  const SizedBox(height: 20,),
                  TextField(
                    controller: TextEditingController(text: "Nguyễn Việt Hùng"),
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Học sinh',
                      border: OutlineInputBorder(),
                      // prefixIcon: Icon(CupertinoIcons.person_fill),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                    controller: dateController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: const InputDecoration(
                      labelText: 'Ngày nghỉ',
                      border: OutlineInputBorder(),
                      // prefixIcon: Icon(CupertinoIcons.person_fill),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                    controller: reasonController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Lý do xin nghỉ',
                      border: OutlineInputBorder(),
                      // prefixIcon: Icon(CupertinoIcons.person_fill),
                    ),
                  ),

                  const SizedBox(height: 20,),
                  
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("Xin nghỉ"),
                      // onPressed: loading ? null : signInWithPassword,
                      // child: loading ? const CircularProgressIndicator() : const Text("Login"),
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: primary2,
                        minimumSize: const Size(double.infinity, 48),
                        elevation: 0.0,
                        shadowColor: Colors.transparent,
                      ),
                    )
                  ),
                ],
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
                    child: ListView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: const Text("Con bị ốm", style: TextStyle(
                                      // color: Colors.grey[800],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500
                                    ),),
                                  ),
                                  const SizedBox(height: 5,),
                                  Transform.translate(
                                    offset: Offset(0, 5),
                                    child: Text("28/03/2023", style: TextStyle(
                                      color: Colors.grey[800]
                                    ),),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
