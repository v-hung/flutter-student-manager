import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class HomeListIconTeacher extends ConsumerWidget {
  const HomeListIconTeacher({super.key});

  static const icons = [
    {
      "asset": "assets/img/icons/teaching.png",
      "label": "Lớp học",
      "path": "/teacher/classrooms",
    },
    {
      "asset": "assets/img/icons/student.png",
      "label": "Học sinh",
      "path": "/teacher/students",
    },
    {
      "asset": "assets/img/icons/qr-code-in.png",
      "label": "Vào lớp",
      "path": "/teacher/qrcode?type=in",
    },
    {
      "asset": "assets/img/icons/qr-code-out.png",
      "label": "Học về",
      "path": "/teacher/qrcode?type=out",
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AlignedGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        itemCount: icons.length,
        mainAxisSpacing: 25,
        crossAxisSpacing: 25,
        itemBuilder: (context, index) {
          final icon = icons[index];
          return InkWell(
            onTap: () => context.go(icon['path'] ?? "/"),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 1/1,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.9),
                      borderRadius: BorderRadius.circular(10),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.3),
                      //     spreadRadius: 1,
                      //     blurRadius: 5,
                      //     offset: const Offset(0, 1), // changes position of shadow
                      //   ),
                      // ],
                    ),
                    child: Image.asset(icon["asset"]!),
                  ),
                ),
                const SizedBox(height: 5,),
                Text(icon['label']!, style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500
                ), textAlign: TextAlign.center,)
              ],
            ),
          );
        }
      ),
    );
  }
}