import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/student/bottom_navbar_student.dart';
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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        titleSpacing: 0,
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1
          )
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
            Consumer(
              builder: (context, ref, child) {
                return CachedNetworkImage(
                  imageUrl: "https://vtv1.mediacdn.vn/thumb_w/640/2021/8/17/vnapotalhocsinhhanoituutruongsomnhatvao192021-1629176652268160551271.jpg",
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
      
                return Container(
                  alignment: Alignment.center,
                  child: const Text("Chưa cập nhập lịch học"),
                );
              },
            ),
          ],
        ),
      )
    );
  }
}