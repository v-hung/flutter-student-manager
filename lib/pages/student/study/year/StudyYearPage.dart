import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/bottom_navbar_student.dart';
import 'package:flutter_student_manager/components/study/main_info.dart';
import 'package:flutter_student_manager/components/study/study_user_info.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:go_router/go_router.dart';

class StudyYearPage extends ConsumerStatefulWidget {
  const StudyYearPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudyYearPageState();
}

class _StudyYearPageState extends ConsumerState<StudyYearPage> {
  late int selectedIndex = 0;

  late final List<Map<String, dynamic>> list = [
    {
      "class": "9A1",
      "title": "Năm học 2021-2022"
    },
    {
      "class": "8A1",
      "title": "Năm học 2020-2021"
    },
    {
      "class": "7A1",
      "title": "Năm học 2019-2020"
    },
    {
      "class": "6A1",
      "title": "Năm học 2018-2019"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        titleSpacing: 0,
        leadingWidth: 100,
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1
          )
        ),
        title: const Text("Lựa chọn"),
        leading: InkWell(
          onTap: () => context.go('/study'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const[
                Icon(CupertinoIcons.back, color: Colors.blue,),
                SizedBox(width: 5,),
                Padding(
                  padding: EdgeInsets.only(bottom: 3.0),
                  child: Text("Học tập", style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                  ),),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StudyUserInfoWidget(moveInfo: false),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
            child: Text("Năm học", style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700
            ),),
          ),

          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!)
                      )
                    ),
                    child: Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(list[index]['class'], style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                            ),),
                            const SizedBox(height: 3,),
                            Text(list[index]['title'], style: TextStyle(
                              color: Colors.grey[600]
                            ),)
                          ],
                        ),
                      ),
                      if (0 == index) ...[
                        const SizedBox(width: 5,),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: const Text("Mặc định", style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500
                          ),),
                        )
                      ],
                      const SizedBox(width: 5,),
                      Icon(CupertinoIcons.check_mark, 
                        color: selectedIndex == index ? Colors.blue : Colors.transparent,
                      )
                      
                    ],)
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 15,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ElevatedButton(onPressed: () {
              context.go('/study');
            }, 
              child: Text("Chọn")
            ),
          )
        ],
      ),
      bottomNavigationBar: const BottomNavBarStudent(),
    );
  }
}