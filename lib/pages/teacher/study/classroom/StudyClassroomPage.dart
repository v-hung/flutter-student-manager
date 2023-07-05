import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/teacher/ClassroomsController.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:tiengviet/tiengviet.dart';

class StudyClassroomPage extends ConsumerStatefulWidget {
  const StudyClassroomPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudyClassroomPageState();
}

class _StudyClassroomPageState extends ConsumerState<StudyClassroomPage> {
  int? idCheck = null;
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
    final classrooms = ref.watch(classroomsFutureProvider);
    final classroomStatus = ref.watch(classroomStatusProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(CupertinoIcons.back)
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
        ) : const Text("Chọn lớp"),
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
      body: Stack(
        children: [
          Container(),
          classrooms.when(
            data: (data) {
              final filter = TiengViet.parse(searchController.text).toLowerCase();
              final dataFilter = data.where((item) => TiengViet.parse(item.name).toLowerCase().contains(filter)).toList();

              if (dataFilter.isEmpty) {
                return const Center(child: Text("Không có lớp nào"),);
              }

              return ListView.builder(
                itemCount: dataFilter.length,
                padding: const EdgeInsets.only(bottom: 60),
                itemBuilder: (context, index) {
                  final classroom = dataFilter[index];
                  List<String> images = [];
                  
                  if (classroom.images != null) {
                    images = (jsonDecode(classroom.images!) as List<dynamic>).map((e) => toImage(e)).toList();
                  }

                  return InkWell(
                    onTap: () => setState(() {
                      idCheck = classroom.id;
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.circular(10),
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]!)
                        )
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10,),
                          SizedBox(
                            width: 55,
                            height: 55,
                            child: images.isNotEmpty ? CachedNetworkImage(
                              imageUrl: images[0],
                              imageBuilder: (context, imageProvider) => Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Center(child: Icon(CupertinoIcons.exclamationmark_circle_fill)),) 
                            : Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage("assets/img/classroom_default2.jpg"), fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15,),
                          Expanded(
                            child: Container(
                              constraints: const BoxConstraints(minHeight: 55),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(classroom.name, style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500
                                  ),),
                                  const SizedBox(height: 5,),
                                  Text("Sỹ số: ${classroom.students_count ?? 0} học sinh"),
                                ],
                              ),
                            ),
                          ),
                         
                          const SizedBox(width: 5,),
                          classroomStatus.id == classroom.id ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: const Text("Mặc định", style: TextStyle(color: Colors.white),),
                          ) : const SizedBox(),
                  
                          const SizedBox(width: 10,),
                          Icon(CupertinoIcons.check_mark, 
                            color: idCheck == classroom.id ? Colors.blue : Colors.transparent,
                          ),
                          const SizedBox(width: 5,),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            error: (_,__) => const Center(child: Text("Không có lớp nào"),),
            loading: () => const Center(child: CircularProgressIndicator(),)
          ),

          idCheck != null ? Positioned(
            left: 10,
            bottom: 10,
            right: 10,
            child: Container(
              child: ElevatedButton(
                onPressed: () {
                  ref.read(classroomStatusProvider.notifier).changeStatus(idCheck!);
                  context.pop();
                },
                child: const Text("Chọn lớp"),
              ),
            ),
          ) : const SizedBox()
        ],
      ),
    );
  }
}