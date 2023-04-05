import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/teacher/StudentController.dart';
import 'package:go_router/go_router.dart';

class TeacherStudentsPage extends ConsumerStatefulWidget {
  const TeacherStudentsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeacherStudentsPageState();
}

class _TeacherStudentsPageState extends ConsumerState<TeacherStudentsPage> {
  final searchController = TextEditingController();
  final searchFocus = FocusNode();
  bool search = false;
  bool searchEmpty = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final heightSafeArea = size.height -
      AppBar().preferredSize.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[600]!, Colors.green[400]!], 
              stops: [0.5, 1.0],
            ),
          ),
        ),
        leading: !search ? IconButton(
          onPressed: () => context.pop(), 
          icon: const Icon(CupertinoIcons.back)
        ) : null,
        title: search ? TextField(
          focusNode: searchFocus,
          controller: searchController,
          onChanged: (value) {
            setState(() {
              searchEmpty = value.isEmpty;
            });
          },
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Tìm kiếm",
            enabledBorder:  UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.white.withOpacity(.7))
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.white)
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10,),
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.normal),
          ),
        ) : const Text("Danh sách học sinh"),
        actions: [
          search ? IconButton(
            onPressed: () {
              if (searchEmpty) {
                setState(() {
                  search = false;
                });
              }
            }, 
            icon: searchEmpty ? const Icon(CupertinoIcons.clear) : const Icon(Icons.person_search_sharp)
          )
          : IconButton(
            onPressed: () => setState(() {
              search = true;
              searchFocus.requestFocus();
            }), 
            icon: const Icon(CupertinoIcons.search)
          )
        ],
      ),
      body: Container(
        constraints: BoxConstraints(
          minHeight: heightSafeArea
        ),
        child: RefreshIndicator(
          onRefresh: () => ref.read(studentControllerProvider.notifier).refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 10,),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Học sinh", style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),),
                          Text("Tổng số: 20", style: TextStyle(
                            fontSize: 12,
                          ),),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(7)
                        ),
                        child: Text("Thêm mới", style: TextStyle(color: Colors.white),),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Consumer(
                  builder: (context, ref, child) {
                    final students = ref.watch(studentControllerProvider);
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7)
                        ),
                    );
                  },
                )
              ],
            ),
          )
        )
      ),
    );
  }
}