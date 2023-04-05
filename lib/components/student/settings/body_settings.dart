import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/controllers/student/ClassroomController.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/models/TeacherModel.dart';
import 'package:flutter_student_manager/pages/student/settings/SettingsPage.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:intl/intl.dart';

class StudentBodySettings extends ConsumerStatefulWidget {
  const StudentBodySettings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudentBodySettingsState();
}

class _StudentBodySettingsState extends ConsumerState<StudentBodySettings> {
  bool isSwitched = false;
  
  void toggleSwitch(bool value) {
  
    if(isSwitched == false)
    {
      setState(() {
        isSwitched = true;
      });
    }
    else
    {
      setState(() {
        isSwitched = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).user as StudentModel?;
    final subjects = ref.watch(subjectsFutureProvider).whenData((value) => value).value ?? [];
    final classroom = ref.watch(classroomFutureProvider).whenData((value) => value).value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Thông tin cơ bản", style: TextStyle(
          color: Colors.grey[700],
          fontWeight: FontWeight.w600
        ),),
        const SizedBox(height: 5,),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ]
          ),
          child: Column(
            children: [
              InfoWidget(
                color: Colors.red,
                icon: CupertinoIcons.person_fill,
                label: "Họ tên",
                value: user?.name,
              ),

              InfoWidget(
                color: Colors.orange,
                icon: CupertinoIcons.time_solid,
                label: "Ngày sinh",
                value: user?.date_of_birth != null ? DateFormat("dd/MM,yyyy").format(user!.date_of_birth!) : "",
              ),

              InfoWidget(
                color: Colors.green,
                icon: CupertinoIcons.location_fill,
                label: "Địa chỉ",
                value: user?.address,
              ),

              InfoWidget(
                color: Colors.brown,
                icon: CupertinoIcons.phone_fill,
                label: "Số điện thoại liên hệ",
                value: user?.contact_info,
                border: false,
              )
            ],
          )
        ),

        const SizedBox(height: 20,),
        Text("Lớp học", style: TextStyle(
          color: Colors.grey[700],
          fontWeight: FontWeight.w600
        ),),
        const SizedBox(height: 5,),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ]
          ),
          child: Column(
            children: [
              InfoWidget(
                color: Colors.blue,
                icon: CupertinoIcons.home,
                label: "Lớp học",
                value: classroom != null ? classroom.name : "Chưa cập nhập",
              ),

              InfoWidget(
                color: Colors.cyan,
                icon: CupertinoIcons.money_dollar,
                label: "Học phí",
                value: user?.tuition != null ? formatCurrencyDouble(user!.tuition!) : null,
              ),

              InfoWidget(
                color: Colors.purple,
                icon: CupertinoIcons.suit_club,
                label: "Các môn theo học",
                value: subjects.fold("",(value, element, ) => value! + "${element.name} "),
                border: false,
              ),
            ],
          )
        ),

        const SizedBox(height: 20,),
        Text("Cài đặt", style: TextStyle(
          color: Colors.grey[700],
          fontWeight: FontWeight.w600
        ),),
        const SizedBox(height: 5,),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10 ,vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ]
          ),
          child: Row(
            children: [
              Container(
                width: 30, height: 30,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(7)
                ),
                alignment: Alignment.center,
                child: Icon(CupertinoIcons.bell_fill, color: Colors.white, size: 20,)
              ),
              const SizedBox(width: 10,),
              Expanded(child: Text("Thông báo", style: TextStyle(fontWeight: FontWeight.w500),)),
              SizedBox(
                height: 30,
                child: Transform.scale(
                  scale: 0.9,
                  child: CupertinoSwitch(  
                    onChanged: toggleSwitch,  
                    value: isSwitched,  
                  ),
                ),
              ) ,
            ],
          )
        ),
        
        const SizedBox(height: 10,),
        InkWell(
          onTap: () => ref.read(authControllerProvider.notifier).logout(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10 ,vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ]
            ),
            alignment: Alignment.center,
            child: const Text("Đăng xuất", style: TextStyle(
              color: Colors.red
            ),),
          ),
        ),
      ],
    );
  }
}

class InfoWidget extends ConsumerWidget {
  final Color color;
  final IconData icon;
  final String label;
  final String? value;
  final bool border;
  const InfoWidget({required this.color, required this.icon, required this.label, required this.value, this.border = true, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: border ? Border(
          bottom:  BorderSide(color: Colors.grey[300]!)
        ) : null
      ),
      child: Row(
        children: [
          Container(
            width: 35, height: 35,
            decoration: BoxDecoration(
              // color: Colors.red,
              border: Border.all(color: color),
              shape: BoxShape.circle
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color)
          ),
          const SizedBox(width: 10,),
          
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500
              ),),
              const SizedBox(height: 3,),
              Text(value ?? "Chưa cập nhập", style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600
              ),),
            ],
          )),
        ],
      ),
    );
  }
}