import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart'; 
import 'package:flutter_student_manager/controllers/teacher/ClassroomsController.dart';
import 'package:tiengviet/tiengviet.dart';

class TeacherClassroomPage extends ConsumerStatefulWidget {
  const TeacherClassroomPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeacherClassroomPageState();
}

class _TeacherClassroomPageState extends ConsumerState<TeacherClassroomPage> {
  bool isSearch = false;
  final searchController = TextEditingController();
  final searchFocus = FocusNode();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final heightSafeArea = size.height -
      AppBar().preferredSize.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom;

    final classrooms = ref.watch(classroomsFutureProvider);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[600]!, Colors.green[400]!], 
              stops: [0.5, 1.0],
            ),
          ),
        ),
        title: isSearch ? TextField(
          focusNode: searchFocus,
          controller: searchController,
          onChanged: (value) => setState(() {}),
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
          )
        ) : const Text("Danh sách lớp"),
        actions: [
          IconButton(
            onPressed: () => setState(() {
              isSearch = !isSearch;  
              if (isSearch) {
                searchFocus.requestFocus();
              }
              else {
                searchController.text = "";
              }
            }),
            icon: Icon(isSearch ? CupertinoIcons.xmark : CupertinoIcons.search)
          )
        ],
      ),
      body: Container(
        constraints: BoxConstraints(
          minHeight: heightSafeArea
        ),
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(classroomsFutureProvider.future),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              constraints: BoxConstraints(
                minHeight: heightSafeArea
              ),
              child: classrooms.when(
                data: (data) {
                  final filter = TiengViet.parse(searchController.text).toLowerCase();
                  final dataFilter = data.where((item) => TiengViet.parse(item.name).toLowerCase().contains(filter)).toList();

                  if (dataFilter.isEmpty) {
                    return const Center(child: Text("Không có lớp nào"),);
                  }

                  return AlignedGridView.count(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dataFilter.length,
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    itemBuilder: (context, index) {
                      final classroom = dataFilter[index];
                      List<String> images = [];
                      if (classroom.images != null) {
                        images = (jsonDecode(classroom.images!) as List<dynamic>).map((e) => toImage(e)).toList();
                      }
                      return InkWell(
                        onTap: () => context.go('/teacher/classrooms/${classroom.id}'),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.05),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 1), // changes position of shadow
                              ),
                            ]
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 100,
                                child: images.isNotEmpty ? CachedNetworkImage(
                                  imageUrl: images.isNotEmpty ? images[0] : "",
                                  imageBuilder: (context, imageProvider) => Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      // shape: BoxShape.circle,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(7),
                                        topRight: Radius.circular(7)
                                      ),
                                      color: Colors.green,
                                      image: DecorationImage(
                                        image: imageProvider, fit: BoxFit.cover),
                                    ),
                                  ),
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                  errorWidget: (_, __, ___) => const Center(child: Icon(CupertinoIcons.exclamationmark_circle,)),
                                )
                                : Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: const BoxDecoration(
                                    // shape: BoxShape.circle,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight: Radius.circular(7)
                                    ),
                                    color: Colors.green,
                                    image: DecorationImage(
                                      image: AssetImage("assets/img/classroom_default2.jpg"), fit: BoxFit.cover),
                                  ),
                                )
                              ),
                              const SizedBox(height: 5,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(classroom.name, style: const TextStyle(
                                  fontWeight: FontWeight.w500
                                ),),
                              ),
                              const SizedBox(height: 5,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text("Sỹ số: ${classroom.students_count ?? 0} học sinh"),
                              ),
                              const SizedBox(height: 5,),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                error: (e,__) => Center(child: Text(e.toString())), 
                loading: () => const Center(child: CircularProgressIndicator(),)
              ),
            ),
          ),
        )
      ),
      // bottomNavigationBar: const BottomNavBarTeacher(),
    );
  }
}