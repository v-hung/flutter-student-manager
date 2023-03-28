import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_student_manager/components/home/appbar_student.dart';
import 'package:flutter_student_manager/components/home/list_icon.dart';
import 'package:flutter_student_manager/components/home/list_notification.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_student_manager/components/bottom_navbar_student.dart';
import 'package:flutter_student_manager/components/logo.dart';

class HomeStudentPage extends ConsumerStatefulWidget {
  const HomeStudentPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeStudentPageState();
}

class _HomeStudentPageState extends ConsumerState<HomeStudentPage> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Image.asset(
          "assets/img/home_bg.jpg",
          height: size.height,
          width: size.width,
          fit: BoxFit.cover,
        ),
        // Container(color: Colors.black.withOpacity(0.3),),
        Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Column(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final auth = ref.watch(authControllerProvider);
                    return Container(
                      // height: 70,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200]!.withOpacity(.6),
                        borderRadius: BorderRadius.circular(10)
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
                          IconButton(
                            onPressed: () => context.go('/notifications'), 
                            icon: const Icon(CupertinoIcons.bell_fill), color: Colors.white,
                          )
                        ],
                      ),
                    );
                  }
                ),

                const SizedBox(height: 20,),
                const HomeListIcon(),

                const SizedBox(height: 20,),
                const Expanded(child: HomeListNotification())
              ],
            ),
          ),
          bottomNavigationBar: const BottomNavBarStudent(),
        ),
      ],
    );
  }
}