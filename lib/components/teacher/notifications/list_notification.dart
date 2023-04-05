import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/controllers/student/CodeScanController.dart';
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
    final codeScans = ref.watch(codeScansStreamProvider);
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
            Expanded(child: Text("LỊCH SỬ ĐI HỌC", style: TextStyle(
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.grey[200]!.withOpacity(.8),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)
              )
            ),
            child: SingleChildScrollView(
              child: codeScans.when(
                data: (codeScans) {
                  if (codeScans.length == 0) {
                    return Text("Lịch trình đi học của con bạn sẽ được hiện thị tại đây");
                  }
                      
                  final length = codeScans.length >= 3 ? 3 : codeScans.length;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for(var i = 0; i < length; i ++) ...[
                        if (i > 0) ...[
                          const SizedBox(height: 10,),
                        ],
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(codeScans[i].action == "in" ? "Đến Trường" : "Về nhà", style: TextStyle(
                                    fontSize: 12,
                                    color: codeScans[i].action == "in" ? Colors.green[900] : Colors.deepOrange[900]
                                  ),),
                                ),
                                const SizedBox(width: 5,),
                                Text(DateFormat("dd/MM/yyy").format(codeScans[i].date_time), style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[800]
                                ),),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Text(codeScans[i].title, style: const TextStyle(
                              // color: Colors.grey[800],
                              // fontSize: 16,
                              fontWeight: FontWeight.w500
                            ),),
                          ],
                        ),

                        const SizedBox(height: 10,),

                        if (codeScans.length > 3) ...[
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
                error: (_,__) => const Center(child: Text("error")), 
                loading: () => const Center(child: CircularProgressIndicator(),)
              )
            ),
          ),
        ),
      ],
    );
  }
}