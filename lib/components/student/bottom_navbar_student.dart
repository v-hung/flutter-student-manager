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
      "label": "Tài khoản",
      "path": "/settings",
    }
  ];

  @override
  Widget build(BuildContext context) {
    final location = "/${"${ref.watch(routerProvider).location}/".split("/")[2]}";
    final currentPageIndex = menu.indexWhere((v) => v['path'] == location);
    final selectedIndex = currentPageIndex < 0 ? 0 : currentPageIndex;

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!))
      ),
      child: NavigationBar(
        destinations: [
          for(var i = 0; i < menu.length; i++) ...[
            NavigationDestination(
              icon: Icon(menu[i]['icon'], color: selectedIndex == i ? Colors.white : Colors.grey[800],), 
              label: menu[i]['label']
            )
          ],
        ],
        selectedIndex: selectedIndex,
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