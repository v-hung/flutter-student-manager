import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/components/teacher/bottom_navbar_teacher.dart';
import 'package:flutter_student_manager/components/teacher/list_icon_teacher.dart';
import 'package:flutter_student_manager/components/teacher/notifications/list_notification.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/models/TeacherModel.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeTeacherPage extends ConsumerStatefulWidget {
  const HomeTeacherPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeTeacherPageState();
}

class _HomeTeacherPageState extends ConsumerState<HomeTeacherPage> with WidgetsBindingObserver {

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose(){
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("App Lifecycle State : $state");
  }

  @override
  Widget build(BuildContext context) {
    // final classroom = ref.watch(classroomFutureProvider).whenData((value) => value).value;
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Image.asset(
          "assets/img/home_bg2.jpg",
          height: size.height,
          width: size.width,
          fit: BoxFit.cover,
        ),
        Container(color: Colors.black.withOpacity(0.3),),
        Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Column(
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      final user = ref.watch(authControllerProvider).user as TeacherModel;
                      return Container(
                        // height: 70,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.8),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 55,
                              height: 55,
                              child: CachedNetworkImage(
                                imageUrl: user.getImage(),
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
                                errorWidget: (context, url, error) => Center(
                                  child: Container(
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
                                    child: Icon(CupertinoIcons.person_fill, color: Colors.green[50], size: 40,)
                                  )
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
                                    Text(user.name, style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500
                                    ),),
                                    const SizedBox(height: 5,),
                                    Text(ref.watch(getUserTextStateProvider)),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => context.go('/teacher/notifications'), 
                              icon: const Icon(CupertinoIcons.bell_fill), color: Colors.white,
                            )
                          ],
                        ),
                      );
                    }
                  ),
          
                  const SizedBox(height: 20,),
                  const HomeListIconTeacher(),
          
                  const SizedBox(height: 20,),
                  const Expanded(child: HomeListNotification())
                ],
              ),
            ),
          ),
          bottomNavigationBar: const BottomNavBarTeacher(),
        ),
      ],
    );
  }
}