import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_student_manager/controllers/RouterController.dart';
import 'package:flutter_student_manager/utils/color.dart';

class BottomNavBarStudent extends ConsumerStatefulWidget {
  const BottomNavBarStudent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavBarStudentState();
}

class _BottomNavBarStudentState extends ConsumerState<BottomNavBarStudent>{
  static const menu = <Map>[
    {
      "icon": CupertinoIcons.home,
      "label": "Trang chủ",
      "path": "/",
    },
    {
      "icon": CupertinoIcons.book_solid,
      "label": "Học tập",
      "path": "/study",
    },
    {
      "icon": CupertinoIcons.settings,
      "label": "Khác",
      "path": "/settings",
    }
  ];

  @override
  Widget build(BuildContext context) {
    final location = "/${"${ref.watch(routerProvider).location}/".split("/")[2]}";
    final currentPageIndex = menu.indexWhere((v) => v['path'] == location);

    print(location);

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white))
      ),
      child: NavigationBar(
        destinations: menu.map((v) => 
          NavigationDestination(
            icon: Icon(v['icon'], color: location == v['path'] ? Colors.white : Colors.grey[800],), 
            label: v['label']
          )
        ).toList(),
        selectedIndex: currentPageIndex < 0 ? 0 : currentPageIndex,
        onDestinationSelected: (int index) {
          // setState(() {
          //   currentPageIndex = index;
          // });
          context.go("/student${menu[index]['path']}");
        },
        // animationDuration: const Duration(seconds: 1),
        height: 70,
        backgroundColor: Colors.white,
      ),
    );
  }
}