import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/teacher/StudentController.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
          // const SizedBox(height: 10,),
          Expanded(
            child: SlidableAutoCloseBehavior(
              closeWhenTapped: true,
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, item) {
                  return Container(
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: item == 0 ? 10 : 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Slidable(
                      key: Key("$item"),
                      closeOnScroll: false,
                      endActionPane: ActionPane(
                        motion: const StretchMotion(),
                        dragDismissible: true,
                        dismissible: DismissiblePane(
                          closeOnCancel: true,
                          dismissThreshold: 0.9,
                          onDismissed: () {
                            print('object');
                          }, 
                          confirmDismiss: () async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  title: const Text("Confirm"),
                                  content: const Text("Are you sure you wish to delete this item?"),
                                  actions: <Widget>[
                                    
                                  ],
                                );
                              },
                            ) != null;
                            return false;
                          }
                        ),
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.green,
                            icon: CupertinoIcons.pen,
                            label: 'Sửa',
                            onPressed: (context) {},
                          ),
                          SlidableAction(
                            backgroundColor: Colors.red,
                            icon: CupertinoIcons.trash,
                            label: 'Xóa',
                            onPressed: (context) {},
                          )
                        ],
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                child: CachedNetworkImage(
                                  imageUrl: "https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHw%3D&w=1000&q=80",
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
                                  errorWidget: (_, __, ___) => const Center(child: Icon(CupertinoIcons.exclamationmark_circle,)),
                                )
                              ),
                              const SizedBox(height: 5,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Nguyen viet Hung", style: const TextStyle(
                                      fontWeight: FontWeight.w500
                                    ),),
                                    const SizedBox(height: 5,),
                                    Text("28/08/1998"),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(CupertinoIcons.info, color: Colors.blue,),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              ),
            ),
          )
        ],
      ),
    );
  }
}