import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:shimmer/shimmer.dart';

final studentsProvider = FutureProvider<List<StudentModel>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  final List<StudentModel> a = [];
  for (var i = 0; i < 10; i++) {
    a.add(ref.watch(authControllerProvider).user as StudentModel);
  }
  return a;
});

final filterTextProvider = StateProvider<String>((ref) {
  return "";
});

final studentsFilterProvider = Provider<List<StudentModel>>((ref) {
  List<StudentModel> students = ref.watch(studentsProvider).whenData((value) => value).value ?? [];
  final filter = ref.watch(filterTextProvider);
  return students.where((student) => student.name.toLowerCase().contains(filter.toLowerCase())).toList();
});

class ClassroomStudents extends ConsumerStatefulWidget {
  const ClassroomStudents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClassroomStudentsState();
}

class _ClassroomStudentsState extends ConsumerState<ClassroomStudents> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final students = ref.watch(studentsProvider);
    return Container(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            alignment: Alignment.center,
            child: Center(
              child: TextField(
                controller: searchController,
                onChanged: (value) => ref.read(filterTextProvider.notifier).state = value,
                decoration: InputDecoration(
                  labelText: 'Tìm kiếm',
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!)),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(CupertinoIcons.search),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: students.when(
                data: (data) {
                  final students = ref.watch(studentsFilterProvider);
                  return ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Row(children: [
                          SizedBox(
                            width: 55,
                            height: 55,
                            child: CachedNetworkImage(
                              imageUrl: "https://play-lh.googleusercontent.com/Dfh0hAkVR-FAuwjF6h6EP992gtzVNy-jgfvshsyEUUJXvevtB92XCdyyZkFYqf21BA=w2560-h1440-rw",
                              imageBuilder: (context, imageProvider) => Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
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
                                  Text("Nguyễn Việt Hùng", style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500
                                  ),),
                                  const SizedBox(height: 5,),
                                  Text("Trường THPT Thái Nguyên | Lớp 11A3", style: const TextStyle(
                                    // color: Colors.grey[700]!,
                                    // // fontSize: 18,
                                    // fontWeight: FontWeight.w500
                                  ),),
                                ],
                              ),
                            ),
                          ),
                        ],),
                      );
                    }
                  );
                }, 
                error: (_,__) => const Center(child: Text("Không thể tải dữ liệu")), 
                loading: () => const StudentLoadingWidget()
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StudentLoadingWidget extends ConsumerWidget {
  const StudentLoadingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Colors.grey[300]!,
      child: Column(
        children: [
          for(var i = 0; i < 4; i ++) ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Row(children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                  // color: Colors.grey
                ),
                const SizedBox(width: 15,),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 55),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5,),
                        Container(
                          width: 150, height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          width: 200, height: 15,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],),
            ),
          ]
        ],
      ),
    );
  }
}