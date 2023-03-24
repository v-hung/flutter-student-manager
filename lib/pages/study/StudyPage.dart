import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/bottom_navbar.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';

class StudyPage extends ConsumerStatefulWidget {
  const StudyPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudyPageState();
}

class _StudyPageState extends ConsumerState<StudyPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        titleSpacing: 0,
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1
          )
        ),
        title: const Text("Học tập"),
        actions: [
          IconButton(onPressed: () {
          }, icon: const Icon(Icons.more_vert_rounded))
        ],
      ),
      body: Column(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final auth = ref.watch(authControllerProvider);
              return Container(
                // height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 55,
                      height: 55,
                      child: CachedNetworkImage(
                        imageUrl: auth.user?.getImage() ?? "",
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
                            Text(auth.user?.name ?? "...", style: const TextStyle(
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
                    Container(
                      child: Icon(CupertinoIcons.right_chevron, color: Colors.grey[600],)
                    )
                  ],
                ),
              );
            }
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}