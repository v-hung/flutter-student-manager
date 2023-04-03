import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_manager/components/student/bottom_navbar_student.dart';
import 'package:flutter_student_manager/components/student/settings/body_settings.dart';
import 'package:flutter_student_manager/components/student/settings/qrcode.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/models/StudentModel.dart';
import 'package:flutter_student_manager/repositories/StudentRepository.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

final subjectsFutureProvider = FutureProvider((ref) async {
  return await ref.read(studentRepositoryProvider).getSubjects();
});

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  var top = 144.0;
  var opacity = 1.0;
  var opacity2 = 1.0;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {setState(() {
      final topDistance = 144 - scrollController.offset;
      top = topDistance > 0 ? topDistance : 0;
      opacity = top / 144;
      opacity2 = top / 10;
    });});
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).user as StudentModel;
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  onPressed: () {
                    if (user.qrcode != null) {
                      showModalQrCode(context, user.getImage(), user.getQrCode(), user.name);
                    }
                    else {
                      showSnackBar(context: context, content: "Tài khoản chưa cập nhập qrcode");
                    }
                  },
                  icon: const Icon(
                    CupertinoIcons.qrcode,
                    color: Colors.green
                  ),
                ),
                backgroundColor: Colors.white.withOpacity(opacity2 > 1 ? 0 : opacity2 < 0 ? 1 :  1 - opacity2),
                shape: opacity2 < 0.3 ? Border(bottom: BorderSide(color: Colors.grey[300]!)) : null,
                actions: [
                  TextButton(
                    onPressed: () => context.go('/student/settings/edit'),
                    child: const Text("Chỉnh sửa", style: TextStyle(
                      color: Colors.green
                    ),)
                  ),
                ],
                floating: false,
                pinned: true,
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: Transform.translate(
                        offset: Offset(0, top - 144),
                        child: SizedBox(
                          width: 90,
                          height: 90,
                          child: CachedNetworkImage(
                            imageUrl: user.getImage(),
                            imageBuilder: (context, imageProvider) => Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.green,
                                    Colors.orange,
                                  ],
                                ),
                                image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
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
                                child: Icon(CupertinoIcons.person_fill, color: Colors.green[50], size: 50,)
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  title: Text(user.name, style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  ),),
                  centerTitle: true,
                )
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Transform.translate(
                          offset: const Offset(0,-30),
                          child: Text(user.username ?? "Chưa tạo tài khoản", style: TextStyle(
                            color: Colors.black.withOpacity(opacity > 1 ? 1 : opacity < 0 ? 0 : opacity)
                          ),),
                        ),
                  
                        // Text("data")
                        const Expanded(child: StudentBodySettings()),
                      ],
                    ),
                  ),
                ),
              )
            ],
           
          ),
          // _buildFab()
        ],
      ),
      bottomNavigationBar: const BottomNavBarStudent(),
    );
  }
}