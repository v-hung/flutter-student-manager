import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeListNotification extends ConsumerStatefulWidget {
  const HomeListNotification({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeListNotificationState();
}

class _HomeListNotificationState extends ConsumerState<HomeListNotification> {

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        // final auth = ref.watch(authControllerProvider);
        return Column(
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200]!.withOpacity(.8),
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
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                color: Colors.grey[200]!.withOpacity(.6),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)
                )
              ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for(var i = 0; i < 2; i++) ...[
                        if (i > 0) ...[
                          const SizedBox(height: 20,),
                        ],
                        Row(
                          children: [
                            Expanded(
                              child: Text("Trường THPT Thái Nguyên", style: TextStyle(
                                color: Colors.grey[800]
                              ),),
                            ),
                            const SizedBox(width: 5,),
                            Text("28/03/2023", style: TextStyle(
                              color: Colors.grey[800]
                            ),),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        const Text("Về việc nghỉ học, phòng chống dịch covid 19 tại địa phương", style: TextStyle(
                          // color: Colors.grey[800],
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),),
                      ],
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () => context.go('/notifications'),
                            child: Text("Xem thêm", style: TextStyle(
                              color: Colors.blue[900],
                              decoration: TextDecoration.underline,
                            )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            // Container(
            //   width: double.infinity,
            //   height: 20,
            //   decoration: BoxDecoration(
            //     color: Colors.grey[200]!.withOpacity(.6),
            //     borderRadius: const BorderRadius.only(
            //       bottomLeft: Radius.circular(10),
            //       bottomRight: Radius.circular(10)
            //     )
            //   ),
            // )
          ],
        );
      }
    );
  }
}