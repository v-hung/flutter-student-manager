import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/student/bottom_navbar_student.dart';
import 'package:flutter_student_manager/controllers/student/ClassroomController.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CalendarPageState();
}

class CalendarPageState extends ConsumerState<CalendarPage> {
  late DateTime toDay = DateTime.now();
  late bool extend = false;

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      toDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final heightSafeArea = size.height -
      AppBar().preferredSize.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom;

    final classroom = ref.watch(classroomFutureProvider);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[600]!, Colors.green[400]!], 
              stops: [0.5, 1.0],
            ),
          ),
        ),
        title: const Text("Lịch học"),
        // leading: IconButton(
        //   onPressed: () => context.pop(),
        //   icon: const Icon(CupertinoIcons.xmark),
        // ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            classroom.when(
              data: (data) {
                if (data == null) {
                  return Container();
                }
                if (data.schedule == null) {
                  return Container(
                    height: heightSafeArea,
                    alignment: Alignment.center,
                    child: const Text("Chưa cập nhập lịch học"),
                  );
                }

                return CachedNetworkImage(
                  imageUrl: toImage(data.schedule ?? ""),
                  imageBuilder: (context, imageProvider) => Image(
                    image: imageProvider, 
                    fit: BoxFit.cover
                  ),
                  placeholder: (context, url) => Container(
                    height: 200,
                    child: const Center(child: CircularProgressIndicator())
                  ),
                  errorWidget: (context, url, error) => const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: Text("Không thể tải lịch học"),),
                  ),
                );

              },
              error: (e,__) => Container(
                height: heightSafeArea,
                child: Center(child: Text(e.toString()))
              ), 
              loading: () => SizedBox(
                height: MediaQuery.of(context).size.height * .5,
                child: const Center(child: CircularProgressIndicator())
              )
            ),
          ],
        ),
      )
    );
  }
}