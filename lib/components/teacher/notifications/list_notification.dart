import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/teacher/notifications/notification_widget.dart';
import 'package:flutter_student_manager/controllers/teacher/BreakSchoolController.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeListNotification extends ConsumerStatefulWidget {
  const HomeListNotification({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeListNotificationState();
}

class _HomeListNotificationState extends ConsumerState<HomeListNotification> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.8),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10)
            )
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(7)
              ),
              child: const Icon(CupertinoIcons.news_solid, color: Colors.white, size: 20,)
            ),
            const SizedBox(width: 10,),
            Expanded(child: Text("LỊCH SỬ XIN NGHỈ", style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.grey[800]
            ),))
          ]),
        ),
        Flexible(
          flex: 0,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.grey[200]!.withOpacity(.8),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)
              )
            ),
            child: SingleChildScrollView(
              child: Consumer(
                builder: (context, ref, child) {
                  final breakSchoolsData = ref.watch(breakSchoolControllerProvider);
                    if (breakSchoolsData.loading) {
                    return const Center(child: CircularProgressIndicator(),);
                  }

                  final breakSchools = breakSchoolsData.breakSchools;

                  if (breakSchools.isEmpty) {
                    return Text("Lịch sử xin nghỉ của các con sẽ được hiện thị tại đây");
                  }

                  final length = breakSchools.length >= 3 ? 3 : breakSchools.length;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for(var i = 0; i < length; i ++) ...[
                        if (i > 0) ...[
                          const SizedBox(height: 10,),
                        ],

                        NotificationTeacherWidget(breakSchool: breakSchools[i]),

                        const SizedBox(height: 10,),

                        if (i == 2) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () => context.go('/student/notifications'),
                                child: Text("Xem thêm", style: TextStyle(
                                  color: Colors.green[900],
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.green[900]
                                )),
                              ),
                            ],
                          )
                        ]
                      ]
                    ]
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}