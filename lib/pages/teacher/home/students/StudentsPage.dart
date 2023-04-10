import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/teacher/StudentController.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

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

  final scrollController = ScrollController();

  void loadDataSearch() {
    if (ref.watch(studentControllerProvider).search != searchController.text) {
      ref.read(studentControllerProvider.notifier).loadDataSearch(searchController.text);
    }

    setState(() { 
      search = false;
    });
  }

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        ref.read(studentControllerProvider.notifier).loadMore();
      }
    });
  }

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

    final studentsData = ref.watch(studentControllerProvider);

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
        ) : studentsData.search == "" ? const Text("Danh sách học sinh")
        : Text("Tìm kiếm: '${studentsData.search}'"),
        actions: [
          search ? IconButton(
            onPressed: () {
              loadDataSearch();
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!)
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Học sinh", style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                    ),),
                    Text("Tổng số: ${studentsData.students.length}", style: const TextStyle(
                      fontSize: 12,
                    ),),
                  ],
                ),
                InkWell(
                  onTap: () => context.go('/teacher/students/edit-add'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(7)
                    ),
                    child: const Text("Thêm mới", style: TextStyle(color: Colors.white),),
                  ),
                )
              ],
            ),
          ),
          // const SizedBox(height: 10,),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                if (studentsData.loading) {
                  return const Center(child: CircularProgressIndicator(),);
                }

                final students = studentsData.students;

                if (students.isEmpty) {
                  return const Center(child: Text("Không có sinh viên nào"),);
                }

                return SlidableAutoCloseBehavior(
                  closeWhenTapped: true,
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: students.length + 1,
                    itemBuilder: (context, index) {
                      if (index == students.length) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Center(
                            child: studentsData.current_page < studentsData.last_page 
                              ? const CircularProgressIndicator()
                              : const Text("Không còn học sinh"),
                          ),
                        );
                      }
                      
                      final student = students[index];

                      return Container(
                        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: index == 0 ? 10 : 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Slidable(
                          key: UniqueKey(),
                          // closeOnScroll: false,
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            dragDismissible: true,
                            dismissible: DismissiblePane(
                              closeOnCancel: true,
                              dismissThreshold: 0.9,
                              onDismissed: () {
                                ref.read(studentControllerProvider.notifier).deleteStudent(student.id);
                              }, 
                              confirmDismiss: () async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Xóa học sinh"),
                                      content: Text("Bạn có chắc chắn muốn xóa học sinh '${student.name}'"),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Không', style: TextStyle(color: Colors.grey[800]!),),
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Xóa', style: TextStyle(color: Colors.red),),
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ) ?? false;
                              }
                            ),
                            children: [
                              SlidableAction(
                                backgroundColor: Colors.green,
                                icon: CupertinoIcons.pen,
                                label: 'Sửa',
                                onPressed: (context) => context.go('/teacher/students/edit-add?id=${student.id}'),
                              ),
                              SlidableAction(
                                backgroundColor: Colors.red,
                                icon: CupertinoIcons.trash,
                                label: 'Xóa',
                                onPressed: (context) async {
                                  bool isDel = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Xóa học sinh"),
                                        content: Text("Bạn có chắc chắn muốn xóa học sinh '${student.name}'"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Không', style: TextStyle(color: Colors.grey[800]!),),
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Xóa', style: TextStyle(color: Colors.red),),
                                            onPressed: () {
                                              Navigator.pop(context, true);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ) ?? false;

                                  if (isDel) {
                                    ref.read(studentControllerProvider.notifier).deleteStudent(student.id);
                                  }
                                },
                              )
                            ],
                          ),
                          child: Builder(
                            builder: (slidableContext) {
                              return InkWell(
                                onTap: () => context.go('/teacher/students/${student.id}'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: student.avatar != null ? CachedNetworkImage(
                                          imageUrl: student.getImage(),
                                          imageBuilder: (context, imageProvider) => Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              // shape: BoxShape.circle,
                                              borderRadius: BorderRadius.circular(30),
                                              color: Colors.green,
                                              image: DecorationImage(
                                                image: imageProvider, fit: BoxFit.cover),
                                            ),
                                          ),
                                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                          errorWidget: (_, __, ___) => Center(child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [
                                                  Colors.green,
                                                  Colors.orange,
                                                ],
                                              ),
                                            ),
                                            child: Icon(CupertinoIcons.person_fill, color: Colors.green[50], size: 20,)
                                          )),
                                        )
                                        : Center(child: Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Colors.green,
                                                Colors.orange,
                                              ],
                                            ),
                                          ),
                                          child: Icon(CupertinoIcons.person_fill, color: Colors.green[50], size: 20,)
                                        ))
                                      ),
                                      const SizedBox(height: 5,),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(student.name, style: const TextStyle(
                                              fontWeight: FontWeight.w500
                                            ),),
                                            const SizedBox(height: 5,),
                                            Text(student.date_of_birth != null ? DateFormat("dd/MM/yyyy").format(student.date_of_birth!) : ""),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 5,),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          final slidable = Slidable.of(slidableContext)!;
                                          final isClosed = slidable.actionPaneType.value == ActionPaneType.none;

                                          if (isClosed) {
                                            slidable.openEndActionPane();
                                          }
                                          else {
                                            slidable.close();
                                          }
                                        },
                                        icon: Icon(CupertinoIcons.info, color: Colors.blue,),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                          ),
                        ),
                      );
                    }
                  ),
                );
              }
            ),
          )
        ],
      ),
    );
  }
}