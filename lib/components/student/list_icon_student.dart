import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class HomeListIconStudent extends ConsumerWidget {
  const HomeListIconStudent({super.key});

  static const icons = [
    {
      "asset": "assets/img/icons/classroom.png",
      "label": "Lớp học",
      "path": "/student/home/classroom",
    },
    {
      "asset": "assets/img/icons/calendar.png",
      "label": "Lịch học",
      "path": "/student/home/calendar",
    },
    {
      "asset": "assets/img/icons/note.png",
      "label": "Xin nghỉ",
      "path": "/student/home/break-school",
    },
    {
      "asset": "assets/img/icons/tuition.png",
      "label": "Học phí",
      "path": "/student/home/tuition",
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 1), // changes position of shadow
                        ),
                      ],
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